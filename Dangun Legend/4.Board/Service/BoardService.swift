//
//  Firestore + Board.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/15.
//

import Foundation
import FirebaseFirestore
import RxCocoa
import RxSwift


struct BoardService {
    
    func sortedBoardList(_ completion: @escaping ([BoardData])->()){
        let serialQueue = DispatchQueue.init(label: "serialQueue")
        let userID = defaults.string(forKey: UDF.userID)!
        loadBoardData { BoardList in
            var sortedBoardList = BoardList
            serialQueue.async {
                sortedBoardList.sort(by: { $0.numOfSuccess > $1.numOfSuccess } )
            }
            serialQueue.async {
                var i = 0
                for goal in sortedBoardList {
                    if goal.userID == userID {
                        let g = goal
                        sortedBoardList.remove(at:i)
                        sortedBoardList.insert(g, at: 0)
                    }
                    i+=1
                }
            }
            serialQueue.async {
                completion(sortedBoardList)
            }
        }
    }
    
    
    func loadBoardData(_ completion: @escaping ([BoardData])->()) {
        let serialQueue = DispatchQueue.init(label: "serialQueue")
        var newboardGoals : [BoardData] = []
        db.collection(K.FS_board).getDocuments() { (querySnapshot, err) in
            if let e = err {
                print("load doc failed: \(e.localizedDescription)")
            } else {
                serialQueue.async {
                    print("----1----")
                    for document in querySnapshot!.documents {
                        let board = document.data()
                        if let des = board[K.description] as? String,
                           let end = board[K.endDate] as? String,
                           let gID = board[K.goalID] as? String,
                           let start = board[K.startDate] as? String,
                           let numOfSuc = board[K.numOfSuccess] as? Int,
                           let uID = board[K.userID] as? String,
                           let nickName = board[K.nickName] as? String
                        {
                            let startDate = DateCalculate().yyMMddHHmmss_toDate(string: start)
                            let endDate = DateCalculate().yyMMddHHmmss_toDate(string: end)
                            let bordInfo = BoardData(userID: uID, goalID: gID, nickName: nickName, startDate: startDate, endDate: endDate, description: des, numOfSuccess: numOfSuc)
                            newboardGoals.append(bordInfo)
                            completion(newboardGoals)
                        }
                    }
                }
            }
        }
    }
    
    
    func deleteFromBoard(goalID:String){
        let userID = defaults.string(forKey: UDF.userID)!
        if goalID != "" {
            db.collection(K.FS_board).document(goalID).delete()
            db.collection(K.FS_userHistory).document(userID).setData([
                goalID : [
                    K.shared: false
                ]
            ], merge: true)
        }
    }
    
    
    
}
