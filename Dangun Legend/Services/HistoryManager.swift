//
//  HistoryManager.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/17.
//

import Foundation
import FirebaseFirestore
import RxCocoa
import RxSwift

struct HistoryManager {
    
    private let dateManager = DateManager()
    private let disposeBag = DisposeBag()
    private var historyListVM: HistoryListViewModel!
    
    func load(completion: @escaping (GoalModel)->(),completionerror: @escaping ()->()) {
        let userID = defaults.string(forKey: KeyForDf.userID)!
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
                                    let history = GoalModel(userID: uID, goalID: gID, startDate: startDate, endDate: endDate, failAllowance: fail, description: des, numOfDays: daysNum, completed: compl, goalAchieved: goalAch, numOfSuccess: numOfSuc, numOfFail: numOfFail, shared: shared)
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
    
    
    
    
    

    
    func resetHitoryData(){
        let userID = defaults.string(forKey: KeyForDf.userID)!
        let goalExists = defaults.bool(forKey: KeyForDf.crrGoalExists )
        var currentlyRunning : Int { return goalExists ?  1 : 0 }
        let decoder = JSONDecoder()
        let dummyGoal = GoalModel(userID: userID, goalID: "", startDate: Date(), endDate: Date(), failAllowance: 0, description: "", numOfDays: 0, completed: false, goalAchieved: false, numOfSuccess: 0, numOfFail: 0, shared: false)
        var goal : GoalModel {
            if goalExists {
                let data = defaults.data(forKey: KeyForDf.crrGoal)!
                guard let goal = try? decoder.decode(GoalModel.self, from: data) else { return dummyGoal }
                return goal
            } else {
                return dummyGoal
            }
        }
        db.collection(K.FS_userGeneral).document(goal.userID).setData([
            FS.GI_generalInfo : [
                FS.GI_totalTrial : currentlyRunning,
                FS.GI_totalSuccess : goal.numOfSuccess,
                FS.GI_totalAchievement : 0,
                FS.GI_totalFail: goal.numOfFail
            ]
        ], merge: true)
        
        db.collection(K.FS_userHistory).document(userID).delete()
        
    }

    
    func shareSuccess(_ goalID: String, nickName: String) {
        let userID = defaults.string(forKey: KeyForDf.userID)!
        let idDocument = db.collection(K.FS_userHistory).document(userID)
        //let load = defaults.string(forKey: keyForDf.nickName) ?? "닉네임 없음"
//        var nickName : String {
//            return self.nic ? "닉네임 없음" : load
//        }
        
        idDocument.getDocument { (querySnapshot, error) in
            if let e = error {
                print("load doc failed: \(e.localizedDescription)")
            } else {
                if let idDoc = querySnapshot?.data() {
                    if let aGoal = idDoc[goalID] as? [String:Any] {
                        if let des = aGoal[G.description] as? String,
                           let end = aGoal[G.endDate] as? String,
                           let start = aGoal[G.startDate] as? String,
                           let numOfSuc = aGoal[G.numOfSuccess] as? Int {
                            db.collection(K.FS_board).document(goalID).setData([
                                G.userID: userID,
                                G.goalID : goalID,
                                G.startDate: start,
                                G.endDate: end,
                                G.description : des,
                                G.completed : true,
                                G.goalAchieved: true,
                                G.numOfSuccess: numOfSuc,
                                G.nickName:  nickName
                            ], merge: true)
                            
                            db.collection(K.FS_userHistory).document(userID).setData([
                                goalID : [
                                    G.shared: true
                                ]
                            ], merge: true)
                            NotificationCenter.default.post(name: reloadTableViewNoti, object: nil)
                        }
                    }}}}}
}

