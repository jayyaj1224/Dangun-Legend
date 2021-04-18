//
//  GoalManager.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/05.
//

import Foundation
import UIKit
import Firebase


//MARK: - Structs

///Firebase & UserDefault
struct GoalStruct: Codable {
    let userID: String
    let goalID: String
    let startDate : Date
    let endDate: Date
    
    let failAllowance: Int
    let description: String

    let numOfDays: Int
    var completed: Bool
    var goalAchieved: Bool
    
    var numOfSuccess : Int
    var numOfFail : Int
}

struct GoalStructForHistory: Codable {
    let userID: String
    let goalID: String
    let startDate : Date
    let endDate: Date
    
    let failAllowance: Int
    let description: String

    let numOfDays: Int
    var completed: Bool
    var goalAchieved: Bool
    
    var numOfSuccess : Int
    var numOfFail : Int
    var shared: Bool
}

///Array로 UserDefault
struct SingleDayInfo: Codable {
    let date: String
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

struct Analysis {
    let analysis : String
    let type : Int
}

struct GoalStructForBoard: Codable {
    let userID: String
    let goalID: String
    let nickName: String
    let startDate : Date
    let endDate: Date
    let description: String
    var numOfSuccess : Int
}


class GoalManager {
    
    let dateManager = DateManager()
    let DangunQueue = DispatchQueue(label: "DG")
    
    
    
    
    
//MARK: - CaveAdd
    

    func daysArray(newGoal: GoalStruct) -> [SingleDayInfo] {
        var daysArray : [SingleDayInfo] = []
        //let numOfDays = newGoal.numOfDays
        for i in 1...100 {
            let start = newGoal.startDate
            let date = Calendar.current.date(byAdding: .day, value: (i-1), to: start)!
            let DateForDB = dateManager.dateFormat(type: "yyyyMMdd", date: date)
            
            let singleDay = SingleDayInfo(date: DateForDB, dayNum: i, success: false, userChecked: false)
            daysArray.append(singleDay)
            db.collection(K.FS_userCurrentArr).document(newGoal.userID).setData(
                ["day \(i)": [
                    sd.date: DateForDB,
                    sd.dayNum: i,
                    sd.success: false,
                    sd.userChecked: false
                ]
                ], merge: true)
        }
        
        return daysArray
    }
    
    
    
    
    
//MARK: - Cave
    
    
    func successCount(){
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        let goalID = defaults.string(forKey: keyForDf.crrGoalID)!
        
        let numOfsuccess = defaults.integer(forKey: keyForDf.crrNumOfSucc)
        
        let oneMore = numOfsuccess + 1
        defaults.set(oneMore, forKey: keyForDf.crrNumOfSucc)
        ///goal info 에 저장
        db.collection(K.FS_userCurrentGoal).document(userID).setData(
            [goalID: [
                G.numOfSuccess: oneMore
            ]], merge: true)
        

        ///general info에 저장
        loadGeneralInfo(forDelegate: false) { (UsersGeneralInfo) in
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
    }
    
    
        
    func failCount(){
        
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        let failAllowance = defaults.integer(forKey: keyForDf.crrFailAllowance)
        let goalID = defaults.string(forKey: keyForDf.crrGoalID)!
        var numOfFail = defaults.integer(forKey: keyForDf.crrNumOfFail) as Int
        print("### numOfFail:\(numOfFail) - failAllowance: \(failAllowance)")
        if failAllowance == numOfFail {
            NotificationCenter.default.post(Notification(name: failedNoti))
        } else {
            numOfFail += 1
            defaults.set(numOfFail, forKey: keyForDf.crrNumOfFail)
            db.collection(K.FS_userCurrentGoal).document(userID).setData(
                [goalID: [
                    G.numOfFail: numOfFail
                ]], merge: true)
            
            loadGeneralInfo(forDelegate: false) { (UsersGeneralInfo) in
                var info = UsersGeneralInfo
                info.totalDaysBeenThrough += 1
                db.collection(K.FS_userGeneral).document(userID).setData([
                    fb.GI_generalInfo : [
                        fb.GI_totalDaysBeenThrough : info.totalDaysBeenThrough
                    ]
                ], merge: true)
            }
        }
    }
    
    func lastDayControl(successed:Bool, goal: GoalStruct){
        
        var numOfSuccess : Int {
            if successed { return defaults.integer(forKey: keyForDf.crrNumOfSucc)+1 }
            else { return defaults.integer(forKey: keyForDf.crrNumOfSucc)}
        }
        var numOfFail : Int {
            if successed { return defaults.integer(forKey: keyForDf.crrNumOfFail)}
            else { return defaults.integer(forKey: keyForDf.crrNumOfFail)+1}
        }
        let startDateForDB = dateManager.dateFormat(type: "yearToSeconds", date: goal.startDate)
        let lastDateForDB = dateManager.dateFormat(type: "yearToSeconds", date: goal.endDate)
       
        if goal.failAllowance+1 == numOfFail {
            NotificationCenter.default.post(Notification(name: failedNoti))
        } else {
            DangunQueue.async {
                db.collection(K.FS_userHistory).document(goal.userID).setData([
                    goal.goalID : [
                        G.userID: goal.userID,
                        G.goalID : goal.goalID,
                        G.startDate: startDateForDB,
                        G.endDate: lastDateForDB,
                        G.failAllowance : goal.failAllowance,
                        G.description : goal.description,
                        G.numOfDays: 100,
                        G.completed : true,
                        G.goalAchieved: true,
                        
                        G.numOfSuccess: numOfSuccess,
                        G.numOfFail: numOfFail,
                        G.shared: false
                    ]
                ], merge: true)
                
                
                
                self.loadGeneralInfo(forDelegate: false) { (UsersGeneralInfo) in
                    let info = UsersGeneralInfo
                    var totalSuc : Int {
                        if successed {
                            return info.totalSuccess + 1
                        } else {
                            return info.totalSuccess
                        }
                    }
                    let totalDays = info.totalDaysBeenThrough + 1
                    let totalAch = info.totalAchievement + 1
                    
                    let sucPerHun = totalSuc/info.totalTrial
                    db.collection(K.FS_userGeneral).document(goal.userID).setData([
                        fb.GI_generalInfo : [
                            fb.GI_totalSuccess : totalSuc,
                            fb.GI_totalDaysBeenThrough : totalDays,
                            fb.GI_totalAchievement: totalAch,
                            fb.GI_successPerHundred: sucPerHun
                        ]
                    ], merge: true)
                }
            }
            
            DangunQueue.async {
                db.collection(K.FS_userCurrentGID).document(goal.userID).delete()
                db.collection(K.FS_userCurrentArr).document(goal.userID).delete()
                db.collection(K.FS_userCurrentGoal).document(goal.userID).delete()
                defaults.set(0, forKey: keyForDf.crrNumOfSucc)
                defaults.set(0, forKey: keyForDf.crrNumOfFail)
                defaults.set(false, forKey: keyForDf.goalExistence)
                defaults.removeObject(forKey: keyForDf.crrGoalID)
                defaults.removeObject(forKey: keyForDf.crrFailAllowance)
                defaults.removeObject(forKey: keyForDf.crrGoal)
                defaults.removeObject(forKey: keyForDf.crrDaysArray)
                defaults.removeObject(forKey: keyForDf.pressedMoment)
                self.loadHistory()
            }
        }
        
    }
    
    
    
    func quitTheGoal() {
        defaults.removeObject(forKey: keyForDf.pressedMoment)
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        let numSucc = defaults.integer(forKey: keyForDf.crrNumOfSucc)
        let numFail = defaults.integer(forKey: keyForDf.crrNumOfFail)
        let decoder = JSONDecoder()
        if let savedData = defaults.data(forKey: keyForDf.crrGoal) as Data?
        {
            if let arr = try? decoder.decode(GoalStruct.self, from: savedData) {
                let startDateForDB = dateManager.dateFormat(type: "yearToSeconds", date: arr.startDate)
                let lastDateForDB = dateManager.dateFormat(type: "yearToSeconds", date: arr.endDate)
                DangunQueue.async {
                    db.collection(K.FS_userHistory).document(userID).setData([
                        arr.goalID : [
                            G.userID: userID,
                            G.goalID : arr.goalID,
                            G.startDate: startDateForDB,
                            G.endDate: lastDateForDB,
                            G.failAllowance : arr.failAllowance,
                            G.description : arr.description,
                            G.numOfDays: 100,
                            G.completed : true,
                            G.goalAchieved: false,
                            G.numOfSuccess: numSucc,
                            G.numOfFail: numFail,
                            G.shared: false
                        ]
                    ], merge: true)
        
                    self.loadGeneralInfo(forDelegate: false) { (UsersGeneralInfo) in
                        let info = UsersGeneralInfo
                        let totalDays = info.totalDaysBeenThrough + 1
                        let sucPerHun = info.totalSuccess/info.totalTrial
                        db.collection(K.FS_userGeneral).document(userID).setData([
                            fb.GI_generalInfo : [
                                fb.GI_totalDaysBeenThrough : totalDays,
                                fb.GI_successPerHundred: sucPerHun
                            ]
                        ], merge: true)
                    }
                }
                DangunQueue.async {
                    db.collection(K.FS_userCurrentGID).document(userID).delete()
                    db.collection(K.FS_userCurrentArr).document(userID).delete()
                    db.collection(K.FS_userCurrentGoal).document(userID).delete()
                    defaults.set(0, forKey: keyForDf.crrNumOfSucc)
                    defaults.set(0, forKey: keyForDf.crrNumOfFail)
                    defaults.removeObject(forKey: keyForDf.crrGoalID)
                    defaults.removeObject(forKey: keyForDf.crrGoal)
                    defaults.removeObject(forKey: keyForDf.crrDaysArray)
                    self.loadHistory()
                }
                
            }
        }

        
        
    }

    
    
    
    
    
    //MARK: - History
    
    
    
    var delegate: HistoryUpdateDelegate?
    
    func loadHistory() {
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        let historyDoc = db.collection(K.FS_userHistory).document(userID)
        let currentDoc = db.collection(K.FS_userCurrentGoal).document(userID)
        self.loadFromDocRef(docRef: historyDoc, current: false)
        self.loadFromDocRef(docRef: currentDoc, current: true)
    }

    func loadFromDocRef(docRef: DocumentReference, current: Bool) {
        docRef.getDocument { (querySnapshot, error) in
            if let e = error {
                print("load doc failed: \(e.localizedDescription)")
            } else {
                if let usersHistory = querySnapshot?.data() {
                    for history in usersHistory {
                        if let aGoal = history.value as? [String:Any] {
                            if let compl = aGoal[G.completed] as? Bool,
                               let des = aGoal[G.description] as? String,
                               let end = aGoal[G.endDate] as? String,
                               let fail = aGoal[G.failAllowance] as? Int,
                               let goalAch = aGoal[G.goalAchieved] as? Bool,
                               let gID = aGoal[G.goalID] as? String,
                               let daysNum = aGoal[G.numOfDays] as? Int,
                               let start = aGoal[G.startDate] as? String,
                               let numOfFail = aGoal[G.numOfFail] as? Int,
                               let numOfSuc = aGoal[G.numOfSuccess] as? Int,
                               let uID = aGoal[G.userID] as? String,
                               let shared = aGoal[G.shared] as? Bool
                                
                            {
                                let startDate = self.dateManager.dateFromString(string: start)
                                let endDate = self.dateManager.dateFromString(string: end)
                                let aHistory = GoalStructForHistory(userID: uID, goalID: gID, startDate: startDate, endDate: endDate, failAllowance: fail, description: des, numOfDays: daysNum, completed: compl, goalAchieved: goalAch, numOfSuccess: numOfSuc, numOfFail: numOfFail, shared: shared)
                                self.delegate?.loadHistory(self, history: aHistory)
                            }}}}}
            NotificationCenter.default.post(Notification(name: labelControlNoti, object: nil, userInfo: nil))
        }
    }
    
    

    
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
    
    
    //3번의 시도 후, 100일 중 98일의 실행으로 목표 달성 성공
    func historyGoalAnalysis(goal : GoalStructForHistory) -> Analysis {
        
        let distanceday = Calendar.current.dateComponents([.day], from: goal.startDate, to: Date()).day! as Int
        
        if goal.completed {
            //성공했을 때
            if goal.goalAchieved {
                let analysis = Analysis(analysis: "\(goal.numOfDays)일 중 \(goal.numOfSuccess)일의 실행으로 목표 달성 성공!", type: 1 )
                return analysis
            } else {
                let analysis = Analysis(analysis:"100일 중 \(goal.numOfSuccess)일의 실행으로 목표 달성 실패" , type: 2 )
                return analysis
            }
        } else {
            let analysis =  Analysis(analysis: "\(goal.numOfDays)일 중 \(goal.numOfSuccess)일의 실행으로 목표 달성 진행중: \(distanceday+1)일째 " , type: 3 )
            return analysis
        }
    }
    
    func loadGeneralInfo(forDelegate: Bool, _ completion: @escaping (_ data: UsersGeneralInfo)->Void) {
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        let idDocument = db.collection(K.FS_userGeneral).document(userID)
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
                            if forDelegate {
                                self.delegate?.setUpperBoxDescription(self, info: currentGeneralInfo)
                            } else {
                                completion(currentGeneralInfo)
                            }
                        }}}
        }
    }
    
    

    
}


