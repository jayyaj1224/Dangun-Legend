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
                        let totalSuc = idGeneralData[fb.GI_totalSuccess] as! Int
                        let currentGeneralInfo = UsersGeneralInfo(totalTrial: totalTrial, totalAchievement: numOfAchieve, totalSuccess: totalSuc)
                        completion(currentGeneralInfo)
                    }
                }
            }
        }
    }

    
}
    
//MARK: - CreateNewGoalFORTEST
    

extension GoalManager {
    func createNewGoalFORTEST() -> TotalGoalInfo {
        let startDate = Calendar.current.date(byAdding: .day, value: -99, to: Date())!
        let lastDate = Calendar.current.date(byAdding: .day, value: 99, to: startDate)!
        let startDateForDB = DateManager().dateFormat(type: "yearToSeconds", date: startDate)
        let id = defaults.string(forKey: keyForDf.crrUser)!
        
        let goal = Goal(userID: id, goalID: startDateForDB, startDate: startDate, endDate: lastDate, failAllowance: 2,description: "This goal is a sample for a test", numOfDays: 100, completed: false, goalAchieved: false, numOfSuccess: 97, numOfFail: 0, shared: false)
        
        let days = self.createNewDaysArrayFORTEST(goal)
        
        let newTotalGoalInfo = TotalGoalInfo(goal: goal, days: days)
        return newTotalGoalInfo
    }
    
    
    private func createNewDaysArrayFORTEST(_ goal:Goal)->[SingleDayInfo] {
        var daysArray = [SingleDayInfo]()
        for i in 1...97 {
            let date = Calendar.current.date(byAdding: .day, value: (i-1), to: goal.startDate)!
            let DateForDB = dateManager.dateFormat(type: "yyyyMMdd", date: date)
            let day = SingleDayInfo(dayNum: i, status: DayStatus.success, date: DateForDB)
            daysArray.append(day)
        }
        for i in 98...100 {
            let date = Calendar.current.date(byAdding: .day, value: (i-1), to: goal.startDate)!
            let DateForDB = dateManager.dateFormat(type: "yyyyMMdd", date: date)
            let day = SingleDayInfo(dayNum: i, status: DayStatus.unchecked, date: DateForDB)
            daysArray.append(day)
        }
        return daysArray
    }
    
}
