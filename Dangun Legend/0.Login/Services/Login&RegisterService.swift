//
//  LoginService.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/15.

/// 첫 로그인        첫사용자                   A: Initial Setting
///           기존 사용자               B: Load User Info

/// 재 로그인        첫 사용자                   A: Initial Setting      -> 둘 다 id     previousUser != id
///           기존 사용자              B: Load User Info

import Foundation


struct LoginAndRegisterService {
    
    private let dateManager = DateManager()
    
    func checkWhichSetIsNeeded(userID: String) {
        let idList = db.collection(K.FS_userIdList).document(userID)
        idList.getDocument { (document, error) in
            if let doc = document {
                if doc.exists {
                    ///아이디가 있으면(기존회원)
                    self.checkIfGoalExists(userID: userID)
                    print("........")
                    print(".............")
                    print(".....ID Found................")
                    print(".....................................")
                    print("........... checking if goal exists")
                    print(".....................................")
                } else {
                    ///아이디가 없으면(신규가입자)
                    self.setDefaultValues(userID: userID)
                    print("****>>>> default value set")
                }
            }
        }
    }
    
    func checkIfGoalExists(userID: String) {
        let idList = db.collection(K.FS_userCurrentGID).document(userID)
        idList.getDocument { (document, error) in
            if let doc = document {
                if doc.exists {
                    print("*** goalID exists >>>  setting current goal and goal Arr")
                    self.setCurrentGoal(userID: userID)
                } else {
                    print("*** goalID doesn't exists >>>  setting goal existence: false")
                    defaults.set(false, forKey: keyForDf.goalExistence)
                }
            }
        }
    }
    

    ///아이디가 없으면(신규가입자)
    func setDefaultValues(userID: String){
        let date = dateManager.dateFormat(type: "yyyy년M월d일", date: Date())
        db.collection(K.FS_userGeneral).document(userID).setData([
            fb.GI_generalInfo : [
                fb.GI_totalTrial : 0,
                fb.GI_totalDaysBeenThrough : 0,
                fb.GI_totalSuccess : 0,
                fb.GI_totalAchievement : 0,
                fb.GI_successPerHundred : 0
            ]
        ], merge: true)
        
        db.collection(K.FS_userIdList).document(userID).setData([
            "date" : date
        ], merge: true)
        defaults.set(userID, forKey: keyForDf.crrUser)
        defaults.set(true, forKey: keyForDf.loginStatus)
        defaults.set(false, forKey: keyForDf.goalExistence)
        defaults.set(K.none, forKey: keyForDf.nickName)
    }
    
    
    
    ///아이디가 있는 currentGoal도 있고.
    func setCurrentGoal(userID: String){
        defaults.set(true, forKey: keyForDf.goalExistence)
        let doc = db.collection(K.FS_userCurrentGoal).document(userID)
        let encoder = JSONEncoder()
        doc.getDocument { (querySnapshot, error) in
            if let e = error {
                print("load doc failed: \(e.localizedDescription)")
            } else {
                if let usersHistory = querySnapshot?.data() {
                    for history in usersHistory {
                        if let aGoal = history.value as? [String:Any] {
                            if let compl = aGoal[G.completed] as? Bool,
                               let des = aGoal[G.description] as? String,
                               let end = aGoal[G.endDate] as? String,
                               let failAllw = aGoal[G.failAllowance] as? Int,
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
                                let crrHistory = Goal(userID: uID, goalID: gID, startDate: startDate, endDate: endDate, failAllowance: failAllw, description: des, numOfDays: daysNum, completed: compl, goalAchieved: goalAch, numOfSuccess: numOfSuc, numOfFail: numOfFail, shared: shared)
                                defaults.set(true, forKey: keyForDf.goalExistence)
                                defaults.set(gID, forKey: keyForDf.crrGoalID)
//                                defaults.set(numOfSuc, forKey: keyForDf.crrNumOfSucc)
//                                defaults.set(numOfFail, forKey: keyForDf.crrNumOfFail)
                                defaults.set(failAllw, forKey: keyForDf.crrFailAllowance)
                                if let encoded = try? encoder.encode(crrHistory) {
                                    defaults.set(encoded, forKey: keyForDf.crrGoal)
                                } else {
                                    print("--->>> encode failed \(keyForDf.crrGoal)")
                                }
                                
                            }}}}}}
        
        let serialQueue = DispatchQueue.init(label: "serialQueue")
        let arrDoc = db.collection(K.FS_userCurrentArr).document(userID)
        arrDoc.getDocument { (querySnapshot, error) in
            if let e = error {
                print("load doc failed: \(e.localizedDescription)")
            } else {
                if let daysArray = querySnapshot?.data() {
                    var arr : [SingleDayInfo] = []
                    serialQueue.async {
                        var i = 1
                        for day in daysArray {
                            if let singleday = day.value as? [String:Any] {
                                let raw = singleday[FS_daysInfo.status] as! String
                                let dayNum = singleday[FS_daysInfo.dayNum] as! Int
                                let date = singleday[FS_daysInfo.date] as! String
                                let dayStatus = DayStatus.init(rawValue: raw)!
                                let aday = SingleDayInfo(dayNum: dayNum, status:dayStatus, date: date)
                                arr.append(aday)
                                arr.sort(by: { $0.dayNum < $1.dayNum })
                            }
                            i += 1
                        }
                    }
                    serialQueue.async {
                        print("@@@ \(arr)")
                        let encoder = JSONEncoder()
                        if let encoded = try? encoder.encode(arr) {
                            defaults.set(encoded, forKey: keyForDf.crrDaysArray)
                        } else {
                            print("--->>> encode failed: \(keyForDf.crrDaysArray)")
                        }
                    }}}}
    }

    func logOutRemoveDefaults(){
        print("------logged out------")
        defaults.set(false, forKey: keyForDf.loginStatus)
        defaults.removeObject(forKey: keyForDf.crrUser)
        defaults.set(K.none, forKey: keyForDf.nickName)
        
        defaults.removeObject(forKey: keyForDf.crrDaysArray)
        defaults.removeObject(forKey: keyForDf.crrGoal)
        defaults.removeObject(forKey: keyForDf.crrGoalID)
        
//        defaults.removeObject(forKey: keyForDf.crrNumOfSucc)
//        defaults.removeObject(forKey: keyForDf.crrNumOfFail)
        
        defaults.removeObject(forKey: keyForDf.crrFailAllowance)
        defaults.removeObject(forKey: keyForDf.goalExistence)
    }

    
}
