//
//  GoalManager.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/05.
//

import Foundation
import UIKit
import Firebase

class GoalManager {
    
    let dateManager = DateManager()
    let DangunQueue = DispatchQueue(label: "DG")
    
    func returnSuccessAndFail(daysArray: [SingleDayInfo]) -> [String : Int] {
        var successNumber = 0
        var failNumber = 0
        for day in daysArray {
            if day.success == true {
                successNumber += 1
            } else {
                failNumber += 1
            }
        }
        let analysis = [K.success:successNumber, K.fail:failNumber]
        return analysis
    }

    
    func daysArray(newGoal: GoalStruct) -> [SingleDayInfo] {
        var daysArray : [SingleDayInfo] = []
        let numOfDays = newGoal.numOfDays
        for i in 1...numOfDays {
            let start = newGoal.startDate
            let date = Calendar.current.date(byAdding: .day, value: (i-1), to: start)!
            let singleDay = SingleDayInfo(date: date, dayNum: i, success: false, userChecked: false)
            daysArray.append(singleDay)
            db.collection(K.FS_userCurrentArr).document(newGoal.userID).setData(
                ["day \(i)": [
                    sd.date: date,
                    sd.dayNum: i,
                    sd.success: false,
                    sd.userChecked: false
                ]
            ], merge: true)
        }
        return daysArray
    }
    
    
    //3번의 시도 후, 100일 중 98일의 실행으로 목표 달성 성공
    func historyGoalAnalysis(goal : GoalStruct) -> String {
        
        let distanceday = Calendar.current.dateComponents([.day], from: goal.startDate, to: Date()).day! as Int
        
        if goal.completed {
            //성공했을 때
            if goal.goalAchieved {
                let analysis = "\(goal.numOfDays)일 중 \(goal.numOfSuccess)일의 실행으로 목표 달성 성공!"
                return analysis
            } else {
                let analysis = "100일 중 \(goal.numOfSuccess)일의 실행으로 목표 달성 실패"
                return analysis
            }
        } else {
            let analysis = "\(goal.numOfDays)일 중 \(goal.numOfSuccess)일의 실행으로 목표 달성 진행중 - \(distanceday+1)일째 "
            return analysis
        }
    }
    
    
    func successCount(){
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        let goalID = defaults.string(forKey: keyForDf.crrGoalID)!
        
        let numOfsuccess = defaults.integer(forKey: keyForDf.crrNumOfSucc) as Int
        let oneMore = numOfsuccess + 1
        defaults.set(oneMore, forKey: keyForDf.crrNumOfSucc)
        
        ///goal info 에 저장
        db.collection(K.FS_userGoal).document(userID).setData(
            [goalID: [
                G.numOfSuccess: oneMore
            ]], merge: true)
        

        
        ///general info에 저장
        loadGeneralInfo { (UsersGeneralInfo) in
            var info = UsersGeneralInfo
            info.totalSuccess += 1
            info.totalDaysBeenThrough += 1
            db.collection(K.FS_userGeneral).document(userID).setData([
                fb.GI_generalInfo : [
                    fb.GI_totalSuccess : info.totalSuccess,
                    fb.GI_totalDaysBeenThrough : info.totalDaysBeenThrough
                ]
            ], merge: true)
        }
        NotificationCenter.default.post(name: goalAddedHistoryUpdateNoti, object: nil, userInfo: nil)
    }
        
    func failCount(){
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        let goalID = defaults.string(forKey: keyForDf.crrGoalID)!
        var numOfFail = defaults.integer(forKey: keyForDf.crrNumOfFail) as Int
        numOfFail += 1
        defaults.set(numOfFail, forKey: keyForDf.crrNumOfFail)
        db.collection(K.FS_userGoal).document(userID).setData(
            [goalID: [
                G.numOfFail: numOfFail
            ]], merge: true)
        
        loadGeneralInfo { (UsersGeneralInfo) in
            var info = UsersGeneralInfo
            info.totalDaysBeenThrough += 1
            db.collection(K.FS_userGeneral).document(userID).setData([
                fb.GI_generalInfo : [
                    fb.GI_totalDaysBeenThrough : info.totalDaysBeenThrough
                ]
            ], merge: true)
        }
        NotificationCenter.default.post(name: goalAddedHistoryUpdateNoti, object: nil, userInfo: nil)
    }
    
    
    func loadGeneralInfo(_ completion: @escaping (_ data: UsersGeneralInfo) -> Void ) {
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        let idDocument = db.collection(K.FS_userGeneral).document(userID)
        DangunQueue.sync {
            idDocument.getDocument { (querySnapshot, error) in
                if let e = error {
                    print("load doc failed: \(e.localizedDescription)")
                } else {
                    if let idDoc = querySnapshot?.data() {
                        if let idGeneralData = idDoc[fb.GI_generalInfo] as? [String:Any] {
                            let totalTrial = idGeneralData[fb.GI_totalTrial] as! Int
                            let numOfAchieve = idGeneralData[fb.GI_totalAchievement] as! Int
                            let totalDays = idGeneralData[fb.GI_totalDaysBeenThrough] as! Int
                            let sucPerHund = idGeneralData[fb.GI_successPerHundred] as! Int
                            let totalSuc = idGeneralData[fb.GI_totalSuccess] as! Int
                            let currentGeneralInfo = UsersGeneralInfo(totalTrial: totalTrial, totalAchievement: numOfAchieve, successPerHundred: sucPerHund, totalDaysBeenThrough: totalDays, totalSuccess: totalSuc)
                            completion(currentGeneralInfo)
                        }}}}
        }
    }
    
    
    //아이디가 없으면
    func initialDataSetForIdAndGeneralInfo(id:String) {
        let date = dateManager.dateFormat(type: "yyyy년M월d일", date: Date())
        let idList = db.collection(K.userIdList).document(id)
        idList.getDocument { (document, error) in
            if let doc = document {
                if doc.exists == false {
                    ///첫 로그인
                    print("No saved general info about \(id)")
                    
                    db.collection(K.FS_userGeneral).document(id).setData([
                        fb.GI_generalInfo : [
                            fb.GI_totalTrial : 0,
                            fb.GI_totalDaysBeenThrough : 0,
                            fb.GI_totalSuccess : 0,
                            fb.GI_totalAchievement : 0,
                            fb.GI_successPerHundred : 0
                        ]
                    ], merge: true)
                    db.collection(K.userIdList).document(id).setData([
                        "date" : date
                    ], merge: true)
                    defaults.set(false, forKey: keyForDf.goalExistence)
                    defaults.set(K.none, forKey: keyForDf.nickName)
                    defaults.set(0, forKey: keyForDf.crrNumOfSucc)
                    defaults.set(0, forKey: keyForDf.crrNumOfFail)
                    defaults.removeObject(forKey: keyForDf.crrGoalID)
                    defaults.removeObject(forKey: keyForDf.crrGoal)
                    defaults.removeObject(forKey: keyForDf.crrDaysArray)

                } else {
                    ///존재하는 id로 로그인했다면.
                    
                    
                    
                    
                }
            }
        }
    }
    
    
    
    func quitTheGoal() {
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        let goalID = defaults.string(forKey: keyForDf.crrGoalID)!
    
        db.collection(K.FS_userCurrentGID).document(userID).setData([G.currentGoal: ""])
        ///2. goalID: completed = true
        db.collection(K.FS_userGoal).document(userID).setData(
            [goalID: [
                G.completed: true
            ]], merge: true)
        
        ///3. DaysArray 삭제
        db.collection(K.FS_userCurrentArr).document(userID).delete()
 
        defaults.set(0, forKey: keyForDf.crrNumOfSucc)
        defaults.set(0, forKey: keyForDf.crrNumOfFail)
        defaults.removeObject(forKey: keyForDf.crrGoalID)
        defaults.removeObject(forKey: keyForDf.crrGoal)
        defaults.removeObject(forKey: keyForDf.crrDaysArray)
    }
    
    
    
}

///Firebase & UserDefault
struct GoalStruct: Codable {
    let userID: String
    let goalID: String
    let startDate : Date
    let endDate: Date
    
    let failAllowance: Int
    let description: String

    let numOfDays: Int
    let completed: Bool
    let goalAchieved: Bool
    
    let numOfSuccess : Int
    let numOfFail : Int
}

///Array로 UserDefault
struct SingleDayInfo: Codable {
    let date: Date
    let dayNum: Int
    var success: Bool
    var userChecked : Bool
}

struct UsersGeneralInfo {
    var totalTrial: Int
    var totalAchievement: Int
    var successPerHundred: Int
    var totalDaysBeenThrough: Int
    var totalSuccess: Int
}



