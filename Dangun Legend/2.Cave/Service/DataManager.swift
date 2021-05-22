//
//  DataManager.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/20.
//

import Foundation

struct DataManager {
    
    private let goalManager = GoalManager()
    private let dateManager = DateManager()
    
    func saveNewGoalOnFS(_ totalGoalInfo: TotalGoalInfo){
        let goal = totalGoalInfo.goal
        let daysInfo = totalGoalInfo.days
        defaults.set(true, forKey: keyForDf.goalExistence)
        print("defaults.set(true, forKey: keyForDf.goalExistence)")
        self.fs_SaveGoalData(goal)
        
        self.fs_SaveNewGoalID(userID: goal.userID, goalID: goal.goalID)
        
        self.fs_SaveDaysInfo(daysInfo)
        
        self.updateUsersGeneralInfoTotalTrial()
        
        self.df_SaveGoalInfo(goal)
        self.df_saveDaysInfo(daysInfo)
    }
    
//MARK: - Save
    
    func fs_SaveDaysInfo(_ daysInfo: [SingleDayInfo]){
        for i in 1...100 {
            let dayi = daysInfo[i-1]
            let userID = defaults.string(forKey: keyForDf.crrUser)!
            db.collection(K.FS_userCurrentArr).document(userID).setData(
                [ "Day\(i)" : [
                    FS_daysInfo.status : dayi.status.rawValue,
                    FS_daysInfo.dayNum : dayi.dayNum,
                    FS_daysInfo.date : dayi.date
                ]
                ], merge: true)
        }
    }
    
    
    func fs_SaveGoalData(_ goal: Goal){
        let startDateForDB = DateManager().dateFormat(type: "yearToSeconds", date: Date())
        let lastDateForDB = DateManager().dateFormat(type: "yearToSeconds", date: goal.endDate)
        db.collection(K.FS_userCurrentGoal).document(goal.userID).setData([
            goal.goalID : [
                G.userID: goal.userID,
                G.goalID : goal.goalID,
                G.startDate: startDateForDB,
                G.endDate: lastDateForDB,
                G.failAllowance : goal.failAllowance,
                G.description : goal.description,
                G.numOfDays: goal.numOfDays,
                G.completed : goal.completed,
                G.goalAchieved: goal.goalAchieved,
                G.numOfSuccess: goal.numOfSuccess,
                G.numOfFail: goal.numOfFail,
                G.shared: goal.shared
            ]
        ], merge: true)
    }
    
    private func fs_SaveNewGoalID(userID: String, goalID: String){
        db.collection(K.FS_userCurrentGID).document(userID).setData([G.currentGoal: goalID], merge: true)
    }
    
    private func updateUsersGeneralInfoTotalTrial(){
        let userID = defaults.string(forKey: keyForDf.crrUser) ?? ""
        self.goalManager.loadGeneralInfo { info in
            let update = info.totalTrial + 1
            db.collection(K.FS_userGeneral).document(userID).setData([
                fb.GI_generalInfo : [
                    fb.GI_totalTrial : update
                ]
            ], merge: true)
        }
    }
    
    func df_SaveGoalInfo(_ goal: Goal){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(goal) {
            defaults.set(encoded, forKey: keyForDf.crrGoal)
        } else {
            print("--->>> encode failed \(keyForDf.crrGoal)")
        }
    }
    
    func df_saveDaysInfo(_ singleDayInfo: [SingleDayInfo]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(singleDayInfo) {
            defaults.set(encoded, forKey: keyForDf.crrDaysArray)
        } else {
            print("--->>> encode failed: \(keyForDf.crrDaysArray)")
        }
    }
}


//MARK: - Load

extension DataManager {
    
    func loadDefaultsCurrentGoalInfo(completion: (Goal)->())  {
        if let savedData = defaults.data(forKey: keyForDf.crrGoal) {
            let decoder = JSONDecoder()
            if let goal = try? decoder.decode(Goal.self, from: savedData) {
                completion(goal)
            }
        }
    }

    func loadDefaultsCurrentDaysArrayInfo(completion: ([SingleDayInfo])->()){
        if let savedData = defaults.object(forKey: keyForDf.crrDaysArray) as? Data {
            let decoder = JSONDecoder()
            if let daysArray = try? decoder.decode([SingleDayInfo].self, from: savedData) {
                completion(daysArray)
            }
        }
    }


}


//MARK: - Delete

extension DataManager {
    
    
    func removeCurrentGoal(_ goal: Goal) {

        removeCurrentGoalFSData(goal)
        removeCurrentGoalDefaultsData()
        updateGeneralInfo(goal: goal)
    }

    
    private func removeCurrentGoalFSData(_ goal: Goal){
        let startDateForDB = dateManager.dateFormat(type: "yearToSeconds", date: goal.startDate)
        let lastDateForDB = dateManager.dateFormat(type: "yearToSeconds", date: goal.endDate)
        let userID = goal.userID
        db.collection(K.FS_userHistory).document(userID).setData([
            goal.goalID : [
                G.userID: goal.userID,
                G.goalID : goal.goalID,
                G.startDate: startDateForDB,
                G.endDate: lastDateForDB,
                G.failAllowance : goal.failAllowance,
                G.description : goal.description,
                G.numOfDays: 100,
                G.completed : true,
                G.goalAchieved: goal.goalAchieved,
                G.numOfSuccess: goal.numOfSuccess,
                G.numOfFail: goal.numOfFail,
                G.shared: false
            ]
        ], merge: true)
        
    }
    
    private func removeCurrentGoalDefaultsData(){
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        db.collection(K.FS_userCurrentGID).document(userID).delete()
        db.collection(K.FS_userCurrentArr).document(userID).delete()
        db.collection(K.FS_userCurrentGoal).document(userID).delete()
        defaults.set(false, forKey: keyForDf.goalExistence)
        defaults.removeObject(forKey: keyForDf.crrGoal)
        defaults.removeObject(forKey: keyForDf.crrDaysArray)
    }
    
}

//MARK: - Update

extension DataManager {
    
    func updateGeneralInfo(goal: Goal) {
        self.goalManager.loadGeneralInfo { info in
            let userID = defaults.string(forKey: keyForDf.crrUser)!
            let updateTotalSuccess = info.totalSuccess + goal.numOfSuccess
            var updateTotalAchievement : Int {
                if goal.goalAchieved {
                    return info.totalAchievement + 1
                } else {
                    return info.totalAchievement
                }
            }
            
            db.collection(K.FS_userGeneral).document(userID).setData([
                fb.GI_generalInfo : [
                    fb.GI_totalSuccess : updateTotalSuccess,
                    fb.GI_totalAchievement: updateTotalAchievement
                ]
            ], merge: true)
        }
        
    }
}
