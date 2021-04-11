//
//  GoalManager.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/05.
//

import Foundation
import UIKit

class GoalManager {
    
    let dateManager = DateManager()
    
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
        }
        return daysArray
    }
    
    
    //3번의 시도 후, 100일 중 98일의 실행으로 목표 달성 성공
    func historyGoalAnalysis(goal : GoalStruct) -> String {
        
        let distanceday = Calendar.current.dateComponents([.day], from: goal.startDate, to: Date()).day! as Int
        
        if goal.completed {
            //성공했을 때
            if goal.goalAchieved {
                if goal.trialNumber == 1 {
                    let analysis = "단 한번의 시도로, \(goal.numOfDays)일 중 \(goal.numOfSuccess)일의 실행으로 목표 달성 성공!"
                    return analysis
                } else {
                    let analysis = "\(goal.trialNumber)번의 시도 후, \(goal.numOfDays)일 중 \(goal.numOfSuccess)일의 실행으로 목표 달성 성공!"
                    return analysis
                }
            } else {
                let analysis = "\(goal.trialNumber)번의 시도 후, \(goal.numOfDays)일 중 \(goal.numOfSuccess)일의 실행으로 목표 달성 실패"
                return analysis
            }
        } else {
            if goal.trialNumber == 1 {
                let analysis = "\(goal.numOfDays)일 중 \(goal.numOfSuccess)일의 실행으로 목표 달성 진행중 - 첫번째 시도, \(distanceday+1)일째 "
                return analysis
            } else {
                let analysis = "\(goal.numOfDays)일 중 \(goal.numOfSuccess)일의 실행으로 목표 달성 진행중 - \(goal.trialNumber)번째 시도, \(distanceday+1)일째 "
                return analysis
            }
        }
    }
    
    func resetCurrent(){
        defaults.set(0, forKey: keyForDf.crrNumOfSucc)
        defaults.set(0, forKey: keyForDf.crrNumOfFail)
        defaults.removeObject(forKey: keyForDf.crrGoalID)
        defaults.removeObject(forKey: keyForDf.crrGoal)
        defaults.removeObject(forKey: keyForDf.crrDaysArray)
    }
    
    
    func successCount(){
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        let goalID = defaults.string(forKey: keyForDf.crrGoalID)!
        var numOfsuccess = defaults.integer(forKey: keyForDf.crrNumOfSucc) as Int
        numOfsuccess += 1
        defaults.set(numOfsuccess, forKey: keyForDf.crrNumOfSucc)
        db.collection(K.userData).document(userID).setData(
            [goalID: [
                G.numOfSuccess: numOfsuccess
            ]], merge: true)
    }
    
    func failCount(){
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        let goalID = defaults.string(forKey: keyForDf.crrGoalID)!
        var numOfFail = defaults.integer(forKey: keyForDf.crrNumOfFail) as Int
        numOfFail += 1
        defaults.set(numOfFail, forKey: keyForDf.crrNumOfFail)
        db.collection(K.userData).document(userID).setData(
            [goalID: [
                G.numOfFail: numOfFail
            ]], merge: true)
    }
 
    
    func loadGeneralInfo() -> UsersGeneralInfo {
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        let idDocument = db.collection(K.userData).document(userID)
        idDocument.getDocument { (querySnapshot, error) in
            if let e = error {
                print("load doc failed: \(e.localizedDescription)")
                ///디폴트값 세팅
            } else {
                if let idDoc = querySnapshot?.data() {
                    if let idGeneralData = idDoc[keyForDf.GI_generalInfo] as? [String:Any] {
                        let totalTrial = idGeneralData[keyForDf.GI_totalTrial] as! Int
                        let numOfAchieve = idGeneralData[keyForDf.GI_totalAchievement] as! Int
                        let sucPerHund = idGeneralData[keyForDf.GI_successPerHundred] as! Int
                        let ability = idGeneralData[keyForDf.GI_usersAbility] as! Double
                        let currentGeneralInfo = UsersGeneralInfo(totalTrial: totalTrial, totalAchievement: numOfAchieve, successPerHundred: sucPerHund, usersAbility: ability)
                        return currentGeneralInfo
                    }}}}
    }
    

}

///Firebase & UserDefault
struct GoalStruct: Codable {
    let userID: String
    let goalID: String
    let startDate : Date
    let endDate: Date
    
    let failAllowance: Int
    let trialNumber : Int
    let description: String


    let numOfDays: Int
    let completed: Bool
    let goalAchieved: Bool
    
    let numOfSuccess : Int
    let numOfFail : Int
    let progress : Int
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
    var usersAbility: Double
}



