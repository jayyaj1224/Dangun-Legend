//
//  HistoryViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/07.
//

import UIKit
import Firebase

let goalAddNotifyHistoryViewNoti : Notification.Name = Notification.Name("goalAddNotifyHistoryViewNotification")

class HistoryViewController: UIViewController {
    
    var goalHistory : [GoalStruct] = []
    let dateManager = DateManager()
    let goalManager = GoalManager()
    
    @IBOutlet weak var successPerAttemptLabel: UILabel!
    @IBOutlet weak var averageSuccessDayLabel: UILabel!
    @IBOutlet weak var commitAbilityPercentageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHistory()  // #selector(self.checkAlert(_:))
        NotificationCenter.default.addObserver(self, selector: #selector(self.historyRenew(_:)), name: goalAddNotifyHistoryViewNoti, object: nil)
    }
    
    @objc func historyRenew(_ noti: Notification){
        loadHistory()
    }
    
    func loadHistory(){
        guard let userID = defaults.value(forKey: K.currentUser) as? String else {
            print("noIDsaved")
            return
        }
        
        let idDocument = db.collection(K.History).document(userID)
        idDocument.getDocument { (querySnapshot, error) in
            if let e = error {
                print("load doc failed: \(e.localizedDescription)")
            } else {
                if let usersHistory = querySnapshot?.data() {
                    for history in usersHistory {
                        if let aGoal = history.value as? [String:Any] {
                            
                            if let compl = aGoal[G.completed] as? Bool,
                               let des = aGoal[G.description] as? String,
                               let fail = aGoal[G.failAllowance] as? Int,
                               let gID = aGoal[G.goalID] as? String,
                               let start = aGoal[G.startDate] as? DateComponents,
                               let end = aGoal[G.endDate] as? DateComponents,
                               let suc = aGoal[G.success] as? Bool,
                               let tri = aGoal[G.trialNumber] as? Int,
                               let uID = aGoal[G.userID] as? String,
                               let daysNum = aGoal[G.numOfDays] as? Int,
                               let exDays = aGoal[G.executedDays] as? Int
                               {
                                let aHistory = GoalStruct(userID: uID, goalID: gID, executedDays: exDays, trialNumber: tri, description: des, startDate: start, endDate: end, failAllowance: fail, numOfDays: daysNum, completed: compl, success: suc)
                                self.goalHistory.append(aHistory)
                            }
                        }
                    }
                    self.goalHistory.sort(by: { $0.goalID > $1.goalID} )
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        let indexPath = IndexPath(row: self.goalHistory.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
                
            }
        }
        
        
    }
    
}


extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        let goal = goalHistory[indexPath.row]
        let startDate = dateManager.dateFormat(type: "yyyy년M월d일", dateComponets: goal.startDate)
        let endDate = dateManager.dateFormat(type: "yyyy년M월d일", dateComponets: goal.startDate)
        let goalAnalysis = goalManager.historyGoalAnalysis(goal: goal)
        
        cell.dateLabel.text = "\(startDate) - \(endDate)"
        cell.goalDescriptionLabel.text = goal.description
        //3번의 시도 후, 100일 중 98일의 실행으로 목표 달성 성공
        cell.goalResultLabel.text = goalAnalysis

        return cell
    }
    
  
    
}


extension HistoryViewController {
    
    
    
    
}
