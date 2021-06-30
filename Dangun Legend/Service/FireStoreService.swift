//
//  FireBaseService.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/25.
//

import Foundation
import FirebaseFirestore

struct FireStoreService {
    
    var userID : String {
        return defaults.string(forKey: UDF.userID)!
    }
    
    private let dateManager = DateCalculate()
    
    func loadCurrentGoal(completion: @escaping (GoalModel)->()){
        let doc = db.collection(K.FS_userCurrentGoal).document(userID)
        doc.getDocument { (querySnapshot, error) in
            if let e = error {
                print("load doc failed: \(e.localizedDescription)")
            } else {
                if let usersHistory = querySnapshot?.data() {
                    for history in usersHistory {
                        if let aGoal = history.value as? [String:Any] {
                            if let status = aGoal[K.status] as? String,
                               let des = aGoal[K.description] as? String,
                               let end = aGoal[K.endDate] as? String,
                               let failAllw = aGoal[K.failAllowance] as? Int,
                               let gID = aGoal[K.goalID] as? String,
                               let start = aGoal[K.startDate] as? String,
                               let numOfFail = aGoal[K.numOfFail] as? Int,
                               let numOfSuc = aGoal[K.numOfSuccess] as? Int,
                               let uID = aGoal[K.userID] as? String,
                               let shared = aGoal[K.shared] as? Bool
                            {
                                print("4444")
                                let startDate = self.dateManager.yyMMddHHmmss_toDate(string: start)
                                let endDate = self.dateManager.yyMMddHHmmss_toDate(string: end)
                                
                                let crrGoal = GoalModel(userID: uID, goalID: gID, startDate: startDate, endDate: endDate, failAllowance: failAllw, description: des, status: Status(rawValue: status)!, numOfSuccess: numOfSuc, numOfFail: numOfFail, shared: shared)
                                completion(crrGoal)
                            }}}}}}
    }
    
    
    
    func loadCurrentDaysInfo(completion: @escaping ([DayModel])->()){
        let serialQueue = DispatchQueue.init(label: "serialQueue")
        let arrDoc = db.collection(K.FS_userCurrentArr).document(userID)
        arrDoc.getDocument { (querySnapshot, error) in
            if let e = error {
                print("load doc failed: \(e.localizedDescription)")
            } else {
                if let daysArray = querySnapshot?.data() {
                    var arr : [DayModel] = []
                    serialQueue.async {
                        var i = 1
                        for day in daysArray {
                            if let singleday = day.value as? [String:Any] {
                                let raw = singleday[K.status] as! String
                                let dayNum = singleday[K.dayNum] as! Int
                                let date = singleday[K.date] as! String
                                let dayStatus = Status.init(rawValue: raw)!
                                let aday = DayModel(dayIndex: dayNum, status:dayStatus, date: date)
                                arr.append(aday)
                                arr.sort(by: { $0.dayIndex < $1.dayIndex })
                            }
                            i += 1
                        }
                    }
                    serialQueue.async {
                        completion(arr)
                    }}}}
    }
    
    
    func loadUserInfo(_ completion: @escaping (UserInfoModel)->Void) {
        let idDocument = db.collection(K.FS_userGeneral).document(userID)
        idDocument.getDocument { (querySnapshot, error) in
            if let e = error {
                print("load doc failed: \(e.localizedDescription)")
            } else {
                if let idDoc = querySnapshot?.data() {
                    if let idGeneralData = idDoc[K.GI_generalInfo] as? [String:Any] {
                        let totalTrial = idGeneralData[K.GI_totalTrial] as! Int
                        let numOfAchieve = idGeneralData[K.GI_totalAchievement] as! Int
                        let totalSuc = idGeneralData[K.GI_totalSuccess] as! Int
                        let totalFail = idGeneralData[K.GI_totalFail] as! Int
                        let currentGeneralInfo = UserInfoModel(totalTrial: totalTrial, totalAchievements: numOfAchieve, totalSuccess: totalSuc, totalFail: totalFail)
                        completion(currentGeneralInfo)
                    }
                }
            }
        }
    }
    
    func loadGeneralInfo(_ completion: @escaping (UserInfoModel)->Void) {
        let userID = defaults.string(forKey: UDF.userID)!
        let idDocument = db.collection(K.FS_userGeneral).document(userID)
        idDocument.getDocument { (querySnapshot, error) in
            if let e = error {
                print("load doc failed: \(e.localizedDescription)")
            } else {
                if let idDoc = querySnapshot?.data() {
                    if let idGeneralData = idDoc[K.GI_generalInfo] as? [String:Any] {
                        let totalTrial = idGeneralData[K.GI_totalTrial] as! Int
                        let numOfAchieve = idGeneralData[K.GI_totalAchievement] as! Int
                        let totalSuc = idGeneralData[K.GI_totalSuccess] as! Int
                        let totalFail = idGeneralData[K.GI_totalFail] as! Int
                        let currentGeneralInfo = UserInfoModel(totalTrial: totalTrial, totalAchievements: numOfAchieve, totalSuccess: totalSuc, totalFail: totalFail)
                        completion(currentGeneralInfo)
                    }
                }
            }
        }
    }
    
    func loadHistory(completion: @escaping (GoalModel)->(),completionerror: @escaping ()->()) {
        let userID = defaults.string(forKey: UDF.userID)!
        let historyDb = db.collection(K.FS_userHistory).document(userID)
        let crrGoalDb =  db.collection(K.FS_userCurrentGoal).document(userID)
        let documnetRefArray = [historyDb, crrGoalDb]
        for ref in documnetRefArray {
            ref.getDocument(){ (querySnapshot, error) in
                if let e = error {
                    print("load doc failed: \(e.localizedDescription)")
                    completionerror()
                } else {
                    if let usersHistory = querySnapshot?.data() {
                        for history in usersHistory {
                            if let aGoal = history.value as? [String:Any] {
                                if let des = aGoal[K.description] as? String,
                                   let end = aGoal[K.endDate] as? String,
                                   let fail = aGoal[K.failAllowance] as? Int,
                                   let gID = aGoal[K.goalID] as? String,
                                   let start = aGoal[K.startDate] as? String,
                                   let numOfFail = aGoal[K.numOfFail] as? Int,
                                   let numOfSuc = aGoal[K.numOfSuccess] as? Int,
                                   let uID = aGoal[K.userID] as? String,
                                   let shared = aGoal[K.shared] as? Bool,
                                   let status = aGoal[K.status] as? String
                                {
                                    let startDate = self.dateManager.yyMMddHHmmss_toDate(string: start)
                                    let endDate = self.dateManager.yyMMddHHmmss_toDate(string: end)
                                    let history = GoalModel(userID: uID, goalID: gID, startDate: startDate, endDate: endDate, failAllowance: fail, description: des, status: Status(rawValue: status)!, numOfSuccess: numOfSuc, numOfFail: numOfFail, shared: shared)
                                    completion(history)
                                }
                            }
                        }
                    } else {
                        completionerror()
                    }
                }
            }
        }
    }

    
}
    
//MARK: - Save

extension FireStoreService {
    
    func saveGoal(_ goal: GoalModel){
        let startDateForDB = DateCalculate().dateFormat(type: "yearToSeconds", date: goal.startDate)
        let lastDateForDB = DateCalculate().dateFormat(type: "yearToSeconds", date: goal.endDate)
        db.collection(K.FS_userCurrentGoal).document(goal.userID).setData([
            goal.goalID : [
                K.userID: goal.userID,
                K.goalID : goal.goalID,
                K.startDate: startDateForDB,
                K.endDate: lastDateForDB,
                K.failAllowance : goal.failAllowance,
                K.description : goal.description,
                K.status: goal.status.rawValue,
                K.numOfSuccess: goal.numOfSuccess,
                K.numOfFail: goal.numOfFail,
                K.shared: goal.shared
            ]
        ], merge: true)
        
        db.collection(K.FS_userCurrentGID).document(userID).setData([K.currentGoal: goal.goalID], merge: true)
    }
 
    
    func saveDaysInfo(_ daysInfo: [DayModel]){
        for i in 1...100 {
            let dayi = daysInfo[i-1]
            let index = String(format: "%03d", i)
            db.collection(K.FS_userCurrentArr).document(userID).setData(
                [ "Day\(index)" : [
                    K.status : dayi.status.rawValue,
                    K.dayNum : dayi.dayIndex,
                    K.date : dayi.date
                ]
                ], merge: true)
        }
    }
    
    func saveGoalAtHistory(_ goal: GoalModel, status: Status) {
        let startDateForDB = dateManager.dateFormat(type: "yearToSeconds", date: goal.startDate)
        let lastDateForDB = dateManager.dateFormat(type: "yearToSeconds", date: goal.endDate)
        db.collection(K.FS_userHistory).document(userID).setData([
            goal.goalID : [
                K.userID: goal.userID,
                K.goalID : goal.goalID,
                K.startDate: startDateForDB,
                K.endDate: lastDateForDB,
                K.failAllowance : goal.failAllowance,
                K.description : goal.description,
                K.status : status.rawValue,
                K.numOfSuccess: goal.numOfSuccess,
                K.numOfFail: goal.numOfFail,
                K.shared: false
            ]
        ], merge: true)
    }
    
    func saveUserInfo(info: UserInfoModel){
        db.collection(K.FS_userGeneral).document(userID).setData([
            K.GI_generalInfo : [
                K.GI_totalTrial : info.totalTrial,
                K.GI_totalSuccess : info.totalSuccess,
                K.GI_totalAchievement : info.totalAchievements,
                K.GI_totalFail: info.totalFail
            ]
        ], merge: true)
    }
    
    func saveUserID(_ userID: String){
        let date = dateManager.dateFormat(type: "yyyy년M월d일", date: Date())
        db.collection(K.FS_userIdList).document(userID).setData([
            "date" : date
        ], merge: true)
    }

    
    func shareSuccess(_ goalID: String, nickName: String) {
        let userID = defaults.string(forKey: UDF.userID)!
        let idDocument = db.collection(K.FS_userHistory).document(userID)

        idDocument.getDocument { (querySnapshot, error) in
            if let e = error {
                print("load doc failed: \(e.localizedDescription)")
            } else {
                if let idDoc = querySnapshot?.data() {
                    if let aGoal = idDoc[goalID] as? [String:Any] {
                        if let des = aGoal[K.description] as? String,
                           let end = aGoal[K.endDate] as? String,
                           let start = aGoal[K.startDate] as? String,
                           let numOfSuc = aGoal[K.numOfSuccess] as? Int {
                            db.collection(K.FS_board).document(goalID).setData([
                                K.userID: userID,
                                K.goalID : goalID,
                                K.startDate: start,
                                K.endDate: end,
                                K.description : des,
                                K.status : Status.success.rawValue,
                                K.numOfSuccess: numOfSuc,
                                K.nickName:  nickName
                            ], merge: true)
                            
                            db.collection(K.FS_userHistory).document(userID).setData([
                                goalID : [
                                    K.shared: true
                                ]
                            ], merge: true)
                            NotificationCenter.default.post(name: reloadTableViewNoti, object: nil)
                        }
                    }}}}}


}


//MARK: - Update

extension FireStoreService {
    
    func userInfoOneMoreTrial(){
        let oneMore = defaults.integer(forKey: UDF.totalTrial)+1
        db.collection(K.FS_userGeneral).document(userID).setData([
            K.GI_generalInfo : [
                K.GI_totalTrial : oneMore
            ]
        ], merge: true)
    }
    
    func userInfoOneMoreSuccess(){
        let oneMore = defaults.integer(forKey: UDF.totalSuccess)+1
        db.collection(K.FS_userGeneral).document(userID).setData([
            K.GI_generalInfo : [
                K.GI_totalSuccess : oneMore
            ]
        ], merge: true)
    }
    
    func userInfoOneMoreFail(){
        let oneMore = defaults.integer(forKey: UDF.totalFail)+1
        db.collection(K.FS_userGeneral).document(userID).setData([
            K.GI_generalInfo : [
                K.GI_totalFail : oneMore
            ]
        ], merge: true)
    }
    
    func userInfoOneMoreAchieve(){
        let oneMore = defaults.integer(forKey: UDF.totalAchievements)+1
        db.collection(K.FS_userGeneral).document(userID).setData([
            K.GI_generalInfo : [
                K.GI_totalAchievement : oneMore
            ]
        ], merge: true)
    }
    
    
    
    
    func updateTheDay(index: Int, successBool: Bool) {
        var bool : String {
            if successBool {
                return Status.success.rawValue
            } else {
                return Status.fail.rawValue
            }
        }
        let num = String(format: "%03d", index)
        db.collection(K.FS_userCurrentArr).document(userID).setData(
            [ "Day\(num)" : [
                K.status : bool,
            ]
            ], merge: true)
    }
    
    
    func goalInfoOneMoreSuccess() {
        let update = defaults.integer(forKey: UDF.successNumber)+1
        let goalID = defaults.string(forKey: UDF.goalID)!
        db.collection(K.FS_userCurrentGoal).document(userID).setData([
            goalID : [
                K.numOfSuccess: update
            ]
        ], merge: true)
    }
    
    func goalInfoOneMoreFail() {
        let update = defaults.integer(forKey: UDF.failNumber)+1
        let goalID = defaults.string(forKey: UDF.goalID)!
        db.collection(K.FS_userCurrentGoal).document(userID).setData([
            goalID : [
                K.numOfFail: update
            ]
        ], merge: true)
    }
    
    
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///↓     ↓     ↓     ↓     ↓     ↓     ↓     ↓     ↓     ↓     ↓     ↓     ↓     ↓     ↓     ↓     ↓     ↓     ↓     ↓
    func singleHistoryRemovedUpdateUserInfo(theHistory: GoalModel, userInfo: UserInfoModel){
        var achievements : Int {
            if theHistory.status == Status.success {
                return userInfo.totalAchievements-1
            } else {
                return userInfo.totalAchievements
            }
        }
        let sucNum = userInfo.totalSuccess - theHistory.numOfSuccess
        let failNum = userInfo.totalFail - theHistory.numOfFail
        
        let info = UserInfoModel(totalTrial: userInfo.totalTrial-1, totalAchievements: achievements, totalSuccess: sucNum, totalFail: failNum)
        
        db.collection(K.FS_userGeneral).document(userID).setData([
            K.GI_generalInfo : [
                K.GI_totalTrial : info.totalTrial,
                K.GI_totalSuccess : info.totalSuccess,
                K.GI_totalAchievement : info.totalAchievements,
                K.GI_totalFail: info.totalFail
            ]
        ], merge: true)
        
        defaults.set(info.totalSuccess,forKey: UDF.totalSuccess)
        defaults.set(info.totalFail,forKey: UDF.totalFail)
        defaults.set(info.totalTrial,forKey: UDF.totalTrial)
        defaults.set(info.totalAchievements,forKey: UDF.totalAchievements)
    }
    
}

//MARK: - Delete

extension FireStoreService {
    
    func removeCurrentGoal(){
        db.collection(K.FS_userCurrentGID).document(userID).delete()
        db.collection(K.FS_userCurrentGoal).document(userID).delete()
    }
    
    func removeCurrentDaysInfo(){
        db.collection(K.FS_userCurrentArr).document(userID).delete()
    }
    
    func removeSingleHistory(goalID: String){
        db.collection(K.FS_userHistory).document(userID).updateData([
            goalID : FieldValue.delete(),
        ]) { err in
            if let err = err {
                print("---->>>removeSingleHistory: Failed \(err.localizedDescription)")
            } else {
                print("removeSingleHistory: Complete")
            }
        }
        
    }
    
    func resetHistoryData(){
        let userID = defaults.string(forKey: UDF.userID)!
        let goalExists = defaults.bool(forKey: UDF.crrGoalExists )
        var totalTrial : Int { return goalExists ?  1 : 0 }
        let numSuc = defaults.integer(forKey: UDF.successNumber)
        let numFail = defaults.integer(forKey: UDF.failNumber)
        
        db.collection(K.FS_userGeneral).document(userID).setData([
            K.GI_generalInfo : [
                K.GI_totalTrial : totalTrial,
                K.GI_totalSuccess : numSuc,
                K.GI_totalAchievement : 0,
                K.GI_totalFail: numFail
            ]
        ], merge: true)
        
        db.collection(K.FS_userHistory).document(userID).delete()
        
        defaults.set(numSuc,forKey: UDF.totalSuccess)
        defaults.set(numFail,forKey: UDF.totalFail)
        defaults.set(totalTrial,forKey: UDF.totalTrial)
        defaults.set(0,forKey: UDF.totalAchievements)
    }

    
}
    
    
    
    
    
    
    
    

    

