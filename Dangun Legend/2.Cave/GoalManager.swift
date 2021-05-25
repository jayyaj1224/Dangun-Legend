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
    
    func createNewGoal(_ usersInput: UsersInputForNewGoal) -> TotalGoalInfoModel {
        let lastDate = Calendar.current.date(byAdding: .day, value: 99, to: Date())!
        let startDateForDB = DateManager().dateFormat(type: "yearToSeconds", date: Date())
        let id = defaults.string(forKey: KeyForDf.userID)!
        
        let goal = GoalModel(userID: id, goalID: startDateForDB, startDate: Date(), endDate: lastDate, failAllowance: usersInput.failAllowance,description: usersInput.goalDescripteion, numOfDays: 100, completed: false, goalAchieved: false, numOfSuccess: 0, numOfFail: 0, shared: false)
        let days = self.createNewDaysArray()
        let newTotalGoalInfo = TotalGoalInfoModel(goal: goal, days: days)
        return newTotalGoalInfo
    }
    
    private func createNewDaysArray()->[DayModel] {
        var daysArray = [DayModel]()
        for i in 1...100 {
            let date = Calendar.current.date(byAdding: .day, value: (i-1), to: Date())!
            let DateForDB = dateManager.dateFormat(type: "yyyyMMdd", date: date)
            let day = DayModel(dayIndex: i, status: Status.none, date: DateForDB)
            daysArray.append(day)
        }
        return daysArray
    }
    
    
    func loadGeneralInfo(_ completion: @escaping (UserInfoModel)->Void) {
        let userID = defaults.string(forKey: KeyForDf.userID)!
        let idDocument = db.collection(K.FS_userGeneral).document(userID)
        idDocument.getDocument { (querySnapshot, error) in
            if let e = error {
                print("load doc failed: \(e.localizedDescription)")
            } else {
                if let idDoc = querySnapshot?.data() {
                    if let idGeneralData = idDoc[FS.GI_generalInfo] as? [String:Any] {
                        let totalTrial = idGeneralData[FS.GI_totalTrial] as! Int
                        let numOfAchieve = idGeneralData[FS.GI_totalAchievement] as! Int
                        let totalSuc = idGeneralData[FS.GI_totalSuccess] as! Int
                        let totalFail = idGeneralData[FS.GI_totalFail] as! Int
                        let currentGeneralInfo = UserInfoModel(totalTrial: totalTrial, totalAchievement: numOfAchieve, totalSuccess: totalSuc, totalFail: totalFail)
                        completion(currentGeneralInfo)
                    }
                }
            }
        }
    }

    
}
    
//MARK: - CreateNewGoalFORTEST
    

extension GoalManager {
    func createNewGoalFORTEST() -> TotalGoalInfoModel {
        let startDate = Calendar.current.date(byAdding: .day, value: -99, to: Date())!
        let lastDate = Calendar.current.date(byAdding: .day, value: 99, to: startDate)!
        let startDateForDB = DateManager().dateFormat(type: "yearToSeconds", date: startDate)
        let id = defaults.string(forKey: KeyForDf.userID)!
        
        let goal = GoalModel(userID: id, goalID: startDateForDB, startDate: startDate, endDate: lastDate, failAllowance: 2,description: "This goal is a sample for a test", numOfDays: 100, completed: false, goalAchieved: false, numOfSuccess: 97, numOfFail: 0, shared: false)
        
        let days = self.createNewDaysArrayFORTEST(goal)
        
        let newTotalGoalInfo = TotalGoalInfoModel(goal: goal, days: days)
        return newTotalGoalInfo
    }
    
    
    private func createNewDaysArrayFORTEST(_ goal:GoalModel)->[DayModel] {
        var daysArray = [DayModel]()
        for i in 1...97 {
            let date = Calendar.current.date(byAdding: .day, value: (i-1), to: goal.startDate)!
            let DateForDB = dateManager.dateFormat(type: "yyyyMMdd", date: date)
            let day = DayModel(dayIndex: i, status: Status.success, date: DateForDB)
            daysArray.append(day)
        }
        for i in 98...100 {
            let date = Calendar.current.date(byAdding: .day, value: (i-1), to: goal.startDate)!
            let DateForDB = dateManager.dateFormat(type: "yyyyMMdd", date: date)
            let day = DayModel(dayIndex: i, status: Status.none, date: DateForDB)
            daysArray.append(day)
        }
        return daysArray
    }
    
}
