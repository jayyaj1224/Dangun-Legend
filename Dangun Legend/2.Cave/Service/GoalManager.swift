//
//  GoalManager.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/05.
//

import Foundation
import UIKit
import Firebase

struct GoalManager {
    
    private let dateManager = DateManager()
    private let serialQueue = DispatchQueue(label: "serialQueue")
    private let historyManager = HistoryManager()
    
    func createNewGoal(_ usersInput: UsersInputForNewGoal) -> TotalGoalInfo {
        let lastDate = Calendar.current.date(byAdding: .day, value: 99, to: Date())!
        let startDateForDB = DateManager().dateFormat(type: "yearToSeconds", date: Date())
        let id = defaults.string(forKey: keyForDf.crrUser)!
        
        let goal = Goal(userID: id, goalID: startDateForDB, startDate: Date(), endDate: lastDate, failAllowance: usersInput.failAllowance,description: usersInput.goalDescripteion, numOfDays: 100, completed: false, goalAchieved: false, numOfSuccess: 0, numOfFail: 0, shared: false)
        let days = self.createNewDaysArray()
        let newTotalGoalInfo = TotalGoalInfo(goal: goal, days: days)
        return newTotalGoalInfo
    }
    
    private func createNewDaysArray()->[SingleDayInfo] {
        var daysArray = [SingleDayInfo]()
        for i in 1...100 {
            let date = Calendar.current.date(byAdding: .day, value: (i-1), to: Date())!
            let DateForDB = dateManager.dateFormat(type: "yyyyMMdd", date: date)
            let day = SingleDayInfo(dayNum: i, status: DayStatus.unchecked, date: DateForDB)
            daysArray.append(day)
        }
        return daysArray
    }
    
    
    func loadGeneralInfo(_ completion: @escaping (UsersGeneralInfo)->Void) {
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
                        completion(currentGeneralInfo)
                    }
                }
            }
        }
    }

    
    
    
//MARK: - Cave
    

    
///**********************************************************************
///**********************************************************************
    
    
    
    
    func lastDayControl(successed:Bool, goal: Goal){
        
//        var numOfSuccess : Int {
//            if successed { return defaults.integer(forKey: keyForDf.crrNumOfSucc)+1 }
//            else { return defaults.integer(forKey: keyForDf.crrNumOfSucc)}
//        }
//        var numOfFail : Int {
//            if successed { return defaults.integer(forKey: keyForDf.crrNumOfFail)}
//            else { return defaults.integer(forKey: keyForDf.crrNumOfFail)+1}
//        }
//        let startDateForDB = dateManager.dateFormat(type: "yearToSeconds", date: goal.startDate)
//        let lastDateForDB = dateManager.dateFormat(type: "yearToSeconds", date: goal.endDate)
//       
//        if goal.failAllowance+1 == numOfFail {
//            NotificationCenter.default.post(Notification(name: failedNoti))
//        } else {
//            serialQueue.async {
//                db.collection(K.FS_userHistory).document(goal.userID).setData([
//                    goal.goalID : [
//                        G.userID: goal.userID,
//                        G.goalID : goal.goalID,
//                        G.startDate: startDateForDB,
//                        G.endDate: lastDateForDB,
//                        G.failAllowance : goal.failAllowance,
//                        G.description : goal.description,
//                        G.numOfDays: 100,
//                        G.completed : true,
//                        G.goalAchieved: true,
//                        
//                        G.numOfSuccess: numOfSuccess,
//                        G.numOfFail: numOfFail,
//                        G.shared: false
//                    ]
//                ], merge: true)
//                
//                
//                
//                self.loadGeneralInfo { info in
//                    var totalSuc : Int {
//                        return successed ? (info.totalSuccess + 1) : info.totalSuccess
//                    }
//                    let totalDays = info.totalDaysBeenThrough + 1
//                    let totalAch = info.totalAchievement + 1
//                    
//                    let sucPerHun = totalSuc/info.totalTrial
//                    db.collection(K.FS_userGeneral).document(goal.userID).setData([
//                        fb.GI_generalInfo : [
//                            fb.GI_totalSuccess : totalSuc,
//                            fb.GI_totalDaysBeenThrough : totalDays,
//                            fb.GI_totalAchievement: totalAch,
//                            fb.GI_successPerHundred: sucPerHun
//                        ]
//                    ], merge: true)
//                }
//            }
//            
//            serialQueue.async {
//                db.collection(K.FS_userCurrentGID).document(goal.userID).delete()
//                db.collection(K.FS_userCurrentArr).document(goal.userID).delete()
//                db.collection(K.FS_userCurrentGoal).document(goal.userID).delete()
//                defaults.set(0, forKey: keyForDf.crrNumOfSucc)
//                defaults.set(0, forKey: keyForDf.crrNumOfFail)
//                defaults.set(false, forKey: keyForDf.goalExistence)
//                defaults.removeObject(forKey: keyForDf.crrGoalID)
//                defaults.removeObject(forKey: keyForDf.crrFailAllowance)
//                defaults.removeObject(forKey: keyForDf.crrGoal)
//                defaults.removeObject(forKey: keyForDf.crrDaysArray)
//            }
//        }
        
    }
    
    
    
    

    
    
}




extension GoalManager {
    func createNewGoalFORTEST() -> TotalGoalInfo {
        let startDate = Calendar.current.date(byAdding: .day, value: -50, to: Date())!
        let lastDate = Calendar.current.date(byAdding: .day, value: 99, to: startDate)!
        let startDateForDB = DateManager().dateFormat(type: "yearToSeconds", date: startDate)
        let id = defaults.string(forKey: keyForDf.crrUser)!
        
        let goal = Goal(userID: id, goalID: startDateForDB, startDate: startDate, endDate: lastDate, failAllowance: 2,description: "This goal is a sample for a test", numOfDays: 100, completed: false, goalAchieved: false, numOfSuccess: 40, numOfFail: 0, shared: false)
        let days = self.createNewDaysArrayFORTEST()
        let newTotalGoalInfo = TotalGoalInfo(goal: goal, days: days)
        return newTotalGoalInfo
    }
    
    
    private func createNewDaysArrayFORTEST()->[SingleDayInfo] {
        let startDate = Calendar.current.date(byAdding: .day, value: -50, to: Date())!
        var daysArray = [SingleDayInfo]()
        for i in 1...40 {
            let date = Calendar.current.date(byAdding: .day, value: (i-1), to: startDate)!
            let DateForDB = dateManager.dateFormat(type: "yyyyMMdd", date: date)
            let day = SingleDayInfo(dayNum: i, status: DayStatus.success, date: DateForDB)
            daysArray.append(day)
        }
        for i in 41...100 {
            let date = Calendar.current.date(byAdding: .day, value: (i-1), to: startDate)!
            let DateForDB = dateManager.dateFormat(type: "yyyyMMdd", date: date)
            let day = SingleDayInfo(dayNum: i, status: DayStatus.unchecked, date: DateForDB)
            daysArray.append(day)
        }
        return daysArray
    }
    
}
