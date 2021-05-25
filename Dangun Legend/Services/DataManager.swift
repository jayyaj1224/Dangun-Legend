//
//  DataManager.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/20.
//

//import Foundation
//
//struct DataManager {
//
//    private let goalManager = GoalManager()
//    private let dateManager = DateManager()
//    private let userID = defaults.string(forKey: KeyForDf.userID) ?? ""
//
//    func saveNewGoalOnFS(_ totalGoalInfo: TotalGoalInfoModel){
//        let goal = totalGoalInfo.goal
//        let daysInfo = totalGoalInfo.days
//        defaults.set(true, forKey: KeyForDf.crrGoalExists)
//        print("\(defaults.bool(forKey: KeyForDf.crrGoalExists))-----defaults.set(true, forKey: keyForDf.goalExistence)")
//        self.fs_SaveGoalData(goal)
//
//        self.fs_SaveNewGoalID(userID: goal.userID, goalID: goal.goalID)
//
//        self.fs_SaveDaysInfo(daysInfo)
//
//        self.updateUsersGeneralInfoTotalTrial()
//
//        self.df_SaveGoalInfo(goal)
//        self.df_saveDaysInfo(daysInfo)
//    }
//
//MARK: - Save

    
//    
//
//    
//    
//    
//    func df_SaveGoalInfo(_ goal: GoalModel){
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(goal) {
//            defaults.set(encoded, forKey: KeyForDf.crrGoal)
//        } else {
//            print("--->>> encode failed \(KeyForDf.crrGoal)")
//        }
//    }
//    
//    func df_saveDaysInfo(_ singleDayInfo: [DayModel]) {
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(singleDayInfo) {
//            defaults.set(encoded, forKey: KeyForDf.crrDaysArray)
//        } else {
//            print("--->>> encode failed: \(KeyForDf.crrDaysArray)")
//        }
//    }
//}
//
//
////MARK: - Load
//
//extension DataManager {
//    
//    func loadDefaultsCurrentGoalInfo(completion: (GoalModel)->())  {
//        if let savedData = defaults.data(forKey: KeyForDf.crrGoal) {
//            let decoder = JSONDecoder()
//            if let goal = try? decoder.decode(GoalModel.self, from: savedData) {
//                completion(goal)
//            }
//        }
//    }
//
//    func loadDefaultsCurrentDaysArrayInfo(completion: ([DayModel])->()){
//        if let savedData = defaults.object(forKey: KeyForDf.crrDaysArray) as? Data {
//            let decoder = JSONDecoder()
//            if let daysArray = try? decoder.decode([DayModel].self, from: savedData) {
//                completion(daysArray)
//            }
//        }
//    }
//
//
//}
//
//
////MARK: - Delete
//
//extension DataManager {
//    
//
//
//    
//    
//}
//
////MARK: - Update
//
//extension DataManager {
//    
//    func updateGeneralInfoTotalAchieve(goal: GoalModel) {
//        self.goalManager.loadGeneralInfo { info in
////            let updateTotalSuccess = info.totalSuccess + goal.numOfSuccess
//            var updateTotalAchievement : Int {
//                if goal.goalAchieved {
//                    return info.totalAchievement + 1
//                } else {
//                    return info.totalAchievement
//                }
//            }
//            
//            db.collection(K.FS_userGeneral).document(userID).setData([
//                FS.GI_generalInfo : [
//                    FS.GI_totalAchievement: updateTotalAchievement
//                ]
//            ], merge: true)
//        }
//        
//    }
//    
//    func updateGeneralInfoTotalSuccess(){
//        self.goalManager.loadGeneralInfo { info in
//            let oneMoreSuccess = info.totalSuccess + 1
//            print("GI_totalSuccess:  \(oneMoreSuccess)")
//            db.collection(K.FS_userGeneral).document(userID).setData([
//                FS.GI_generalInfo : [
//                    FS.GI_totalSuccess : oneMoreSuccess
//                ]
//            ], merge: true)
//            
//        }
//    }
//    
//    func updateGeneralInfoTotalFail(){
//        self.goalManager.loadGeneralInfo { info in
//            let oneMoreFail = info.totalFail + 1
//            print("GI_totalFail:  \(oneMoreFail)")
//            db.collection(K.FS_userGeneral).document(userID).setData([
//                FS.GI_generalInfo : [
//                    FS.GI_totalFail : oneMoreFail
//                ]
//            ], merge: true)
//        }
//    }
//}
