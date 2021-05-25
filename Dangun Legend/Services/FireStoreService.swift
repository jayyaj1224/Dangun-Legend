//
//  FireBaseService.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/25.
//

import Foundation

struct FireStoreService {
    
    var userID : String {
        return defaults.string(forKey: KeyForDf.userID)!
    }
    
    private let dateManager = DateManager()
    
    func loadCurrentGoal(completion: @escaping (GoalModel)->()){
        let doc = db.collection(K.FS_userCurrentGoal).document(userID)
        doc.getDocument { (querySnapshot, error) in
            if let e = error {
                print("load doc failed: \(e.localizedDescription)")
            } else {
                if let usersHistory = querySnapshot?.data() {
                    for history in usersHistory {
                        if let aGoal = history.value as? [String:Any] {
                            if let status = aGoal[G.status] as? String,
                               let des = aGoal[G.description] as? String,
                               let end = aGoal[G.endDate] as? String,
                               let failAllw = aGoal[G.failAllowance] as? Int,
                               let gID = aGoal[G.goalID] as? String,
                               let start = aGoal[G.startDate] as? String,
                               let numOfFail = aGoal[G.numOfFail] as? Int,
                               let numOfSuc = aGoal[G.numOfSuccess] as? Int,
                               let uID = aGoal[G.userID] as? String,
                               let shared = aGoal[G.shared] as? Bool
                            {
                                let startDate = self.dateManager.dateFromString(string: start)
                                let endDate = self.dateManager.dateFromString(string: end)
                                let crrHistory = GoalModel(userID: uID, goalID: gID, startDate: startDate, endDate: endDate, failAllowance: failAllw, description: des, status: Status(rawValue: status)!, numOfSuccess: numOfSuc, numOfFail: numOfFail, shared: shared)
                                completion(crrHistory)
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
                                let raw = singleday[FS_daysInfo.status] as! String
                                let dayNum = singleday[FS_daysInfo.dayNum] as! Int
                                let date = singleday[FS_daysInfo.date] as! String
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
                    if let idGeneralData = idDoc[FS.GI_generalInfo] as? [String:Any] {
                        let totalTrial = idGeneralData[FS.GI_totalTrial] as! Int
                        let numOfAchieve = idGeneralData[FS.GI_totalAchievement] as! Int
                        let totalSuc = idGeneralData[FS.GI_totalSuccess] as! Int
                        let totalFail = idGeneralData[FS.GI_totalFail] as! Int
                        let currentGeneralInfo = UserInfoModel(totalTrial: totalTrial, totalAchievements: numOfAchieve, totalSuccess: totalSuc, totalFail: totalFail)
                        completion(currentGeneralInfo)
                    }
                }
            }
        }
    }
    
}
    
//MARK: - Save

extension FireStoreService {
    
    func saveGoal(_ goal: GoalModel){
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
                G.status: goal.status.rawValue,
                G.numOfSuccess: goal.numOfSuccess,
                G.numOfFail: goal.numOfFail,
                G.shared: goal.shared
            ]
        ], merge: true)
        
        db.collection(K.FS_userCurrentGID).document(userID).setData([G.currentGoal: goal.goalID], merge: true)
    }
 
    
    func saveDaysInfo(_ daysInfo: [DayModel]){
        for i in 1...100 {
            let dayi = daysInfo[i-1]
            let index = String(format: "%03d", i)
            db.collection(K.FS_userCurrentArr).document(userID).setData(
                [ "Day\(index)" : [
                    FS_daysInfo.status : dayi.status.rawValue,
                    FS_daysInfo.dayNum : dayi.dayIndex,
                    FS_daysInfo.date : dayi.date
                ]
                ], merge: true)
        }
    }
    

    
    func saveGoalAtHistory(_ goal: GoalModel) {
        let startDateForDB = dateManager.dateFormat(type: "yearToSeconds", date: goal.startDate)
        let lastDateForDB = dateManager.dateFormat(type: "yearToSeconds", date: goal.endDate)
        db.collection(K.FS_userHistory).document(userID).setData([
            goal.goalID : [
                G.userID: goal.userID,
                G.goalID : goal.goalID,
                G.startDate: startDateForDB,
                G.endDate: lastDateForDB,
                G.failAllowance : goal.failAllowance,
                G.description : goal.description,
                G.status : goal.status.rawValue,
                G.numOfSuccess: goal.numOfSuccess,
                G.numOfFail: goal.numOfFail,
                G.shared: false
            ]
        ], merge: true)
    }
    
    func saveUserInfo(info: UserInfoModel){
        db.collection(K.FS_userGeneral).document(userID).setData([
            FS.GI_generalInfo : [
                FS.GI_totalTrial : info.totalTrial,
                FS.GI_totalSuccess : info.totalSuccess,
                FS.GI_totalAchievement : info.totalAchievements,
                FS.GI_totalFail: info.totalFail
            ]
        ], merge: true)
    }
    
    func saveUserID(_ userID: String){
        let date = dateManager.dateFormat(type: "yyyy년M월d일", date: Date())
        db.collection(K.FS_userIdList).document(userID).setData([
            "date" : date
        ], merge: true)
    }

}


//MARK: - Update

extension FireStoreService {
    
    func userInfoOneMoreTrial(){
        let oneMore = defaults.integer(forKey: KeyForDf.totalTrial)+1
        db.collection(K.FS_userGeneral).document(userID).setData([
            FS.GI_generalInfo : [
                FS.GI_totalTrial : oneMore
            ]
        ], merge: true)
    }
    
    func userInfoOneMoreSuccess(){
        let oneMore = defaults.integer(forKey: KeyForDf.totalSuccess)+1
        db.collection(K.FS_userGeneral).document(userID).setData([
            FS.GI_generalInfo : [
                FS.GI_totalSuccess : oneMore
            ]
        ], merge: true)
    }
    
    func userInfoOneMoreFail(){
        let oneMore = defaults.integer(forKey: KeyForDf.totalFail)+1
        db.collection(K.FS_userGeneral).document(userID).setData([
            FS.GI_generalInfo : [
                FS.GI_totalFail : oneMore
            ]
        ], merge: true)
    }
    
    func userInfoOneMoreAchieve(){
        let oneMore = defaults.integer(forKey: KeyForDf.totalAchievements)+1
        db.collection(K.FS_userGeneral).document(userID).setData([
            FS.GI_generalInfo : [
                FS.GI_totalAchievement : oneMore
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
                FS_daysInfo.status : bool,
            ]
            ], merge: true)
    }
    
    
    func goalInfoOneMoreSuccess() {
        let update = defaults.integer(forKey: KeyForDf.successNumber)+1
        let goalID = defaults.string(forKey: KeyForDf.goalID)!
        db.collection(K.FS_userCurrentGoal).document(userID).setData([
            goalID : [
                G.numOfSuccess: update
            ]
        ], merge: true)
    }
    
    func goalInfoOneMoreFail() {
        let update = defaults.integer(forKey: KeyForDf.failNumber)+1
        let goalID = defaults.string(forKey: KeyForDf.goalID)!
        db.collection(K.FS_userCurrentGoal).document(userID).setData([
            goalID : [
                G.numOfFail: update
            ]
        ], merge: true)
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
    
}
