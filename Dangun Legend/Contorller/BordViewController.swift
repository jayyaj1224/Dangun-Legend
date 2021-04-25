//
//  BordViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/16.
//

import UIKit
import Firebase

let boardDeleteNoti : Notification.Name = Notification.Name("boardDeleteNoti")


class BoardViewController: UIViewController {
    
    var boardGoals : [GoalStructForBoard] = []
    let dateManager = DateManager()
    let goalManager = GoalManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boardTableView.register(UINib(nibName: "BoardShareCell", bundle: nil), forCellReuseIdentifier: "boardShareCell")
        NotificationCenter.default.addObserver(self, selector: #selector(deleteBoard(_:)), name: boardDeleteNoti, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadBoardGoals()
    }
    
    @IBOutlet weak var boardTableView: UITableView!
    
    
    @objc func deleteBoard(_ noti: Notification){
        let goalID = noti.object as! String
        let alert = UIAlertController.init(title: "Delete", message: "업적을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (UIAlertAction) in
            self.deleteFromBoard(goalID: goalID)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func loadBoardGoals(){
        let serialQueue = DispatchQueue.init(label: "serialQueue")
        var newboardGoals : [GoalStructForBoard] = []
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        db.collection(K.FS_board).getDocuments() { (querySnapshot, err) in
            if let e = err {
                print("load doc failed: \(e.localizedDescription)")
            } else {
                serialQueue.async {
                    for document in querySnapshot!.documents {
                        let board = document.data()
                        if let des = board[G.description] as? String,
                           let end = board[G.endDate] as? String,
                           let gID = board[G.goalID] as? String,
                           let start = board[G.startDate] as? String,
                           let numOfSuc = board[G.numOfSuccess] as? Int,
                           let uID = board[G.userID] as? String,
                           let nickName = board[G.nickName] as? String
                        {
                            let startDate = self.dateManager.dateFromString(string: start)
                            let endDate = self.dateManager.dateFromString(string: end)
                            let bordInfo = GoalStructForBoard(userID: uID, goalID: gID, nickName: nickName, startDate: startDate, endDate: endDate, description: des, numOfSuccess: numOfSuc)
                            newboardGoals.append(bordInfo)
                            newboardGoals.sort(by: { $0.numOfSuccess > $1.numOfSuccess} )
                            print("*** crruserID :\(userID)")
                            print("*** board userID :\(uID)")
                        }
                    }
                     
                }
                serialQueue.async {
                    var i = 0
                    for goal in newboardGoals {
                        if goal.userID == userID {
                            let g = goal
                            newboardGoals.remove(at:i)
                            newboardGoals.insert(g, at: 0)
                            self.boardGoals = newboardGoals
                        }
                        i+=1
                    }
                }
                DispatchQueue.main.async {
                    self.boardTableView.reloadData()
                }
            }
        }
        
    }
    
    func deleteFromBoard(goalID:String){
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        if goalID != "" {
            db.collection(K.FS_board).document(goalID).delete()
            db.collection(K.FS_userHistory).document(userID).setData([
                goalID : [
                    G.shared: false
                ]
            ], merge: true)
            DispatchQueue.main.async {
                self.loadBoardGoals()
            }
        }
    }
    
    
}


extension BoardViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardGoals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "boardShareCell", for: indexPath) as? BoardShareCell else {
            return UITableViewCell()
        }
        
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        let goal = boardGoals[indexPath.row]
        let startDate = dateManager.dateFormat(type: "yyyy년M월d일", date: goal.startDate)
        let endDate = dateManager.dateFormat(type: "yyyy년M월d일", date: goal.endDate)

        if userID == goal.userID {
            cell.deleteOutlet.isHidden = false
        } else {
            cell.deleteOutlet.isHidden = true
        }
       
        switch goal.numOfSuccess {
        case 100:
            cell.terrificOutlet.isHidden = true
            cell.superOutlet.isHidden = false
           
        case 97...99:
            cell.terrificOutlet.isHidden = false
            cell.superOutlet.isHidden = true

        default:
            cell.terrificOutlet.isHidden = true
            cell.superOutlet.isHidden = true

        }
        
        cell.goalID = goal.goalID
        cell.nameLabel.text = "\(goal.nickName) 님의 업적"
        cell.goalLabel.text = goal.description
        cell.achieveLabel.text = "\(goal.numOfSuccess)일"
        cell.dateLabel.text = "\(startDate) - \(endDate)"
        
        return cell
    }
    
    
    
}
