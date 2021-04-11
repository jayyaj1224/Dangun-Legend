//
//  HistoryViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/07.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

let goalAddedHistoryUpdateNoti : Notification.Name = Notification.Name("goalAddedHistoryUpdateNoti")

class HistoryViewController: UIViewController {
    
    var goalHistory : [GoalStruct] = []
    let dateManager = DateManager()
    let goalManager = GoalManager()
    
    @IBOutlet weak var successPerAttemptLabel: UILabel!
    @IBOutlet weak var averageSuccessDayLabel: UILabel!
    @IBOutlet weak var commitAbilityPercentageLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingLabel: UIView!
    @IBOutlet weak var historyIsEmptyLabel: UIView!
    
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var idInput: UITextField!
    @IBOutlet weak var idSaveButtonOutlet: UIButton!
    @IBAction func idSaveButton(_ sender: Any) {
        savePressed()
    }
    
    //1. 새로 목표 추가되어 바로, 히스토리가 무조건 있는 경우 --> Clear
    //2. 추가안하고 바로 -> 히스토리가 비어있는경우 -->
    //3. 추가안하고 바로 -> 히스토리가 있어서 로딩되는경우 --> Clear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingLabel.alpha = 1
        self.historyIsEmptyLabel.alpha = 0
        idControl()
        setGeneralInfo()
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "historyCell")
        NotificationCenter.default.addObserver(self, selector: #selector(self.goalAddedHistoryUpdate(_:)), name: goalAddedHistoryUpdateNoti, object: nil)
        loadHistory()
    }
    
    
    @objc func goalAddedHistoryUpdate(_ noti: Notification) {
        print("noti")
        loadHistory()
    }
    
    
    func loadHistory(){
        var newHistory : [GoalStruct] = []
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        loadingLabelControl()
        
        let idDocument = db.collection(K.userData).document(userID)
        idDocument.getDocument { (querySnapshot, error) in
            if let e = error {
                print("load doc failed: \(e.localizedDescription)")
                self.loadingLabelControl(array: newHistory)
            } else {
                if let usersHistory = querySnapshot?.data() {
                    print(usersHistory.count)
                    for history in usersHistory {
                        if let aGoal = history.value as? [String:Any] {
                            if let compl = aGoal[G.completed] as? Bool,
                               let des = aGoal[G.description] as? String,
                               let fail = aGoal[G.failAllowance] as? Int,
                               let gID = aGoal[G.goalID] as? String,
                               
                               let start = aGoal[G.startDate] as? String,
                               let end = aGoal[G.endDate] as? String,
                               
                               let goalAch = aGoal[G.goalAchieved] as? Bool,
                               let tri = aGoal[G.trialNumber] as? Int,
                               let uID = aGoal[G.userID] as? String,
                               let daysNum = aGoal[G.numOfDays] as? Int,
                               let numOfSuc = aGoal[G.numOfSuccess] as? Int,
                               let numOfFail = aGoal[G.numOfFail] as? Int,
                               let progress = aGoal[G.progress] as? Int
                            {
                                let startDate = self.dateManager.dateFromString(string: start)
                                let endDate = self.dateManager.dateFromString(string: end)
                                print("------\(startDate)---\(endDate)---")
                                let aHistory = GoalStruct(userID: uID, goalID: gID, startDate: startDate, endDate: endDate, failAllowance: fail, trialNumber: tri, description: des, numOfDays: daysNum, completed: compl, goalAchieved: goalAch, numOfSuccess: numOfSuc, numOfFail: numOfFail, progress: progress)
                                newHistory.append(aHistory)
                                self.goalHistory = newHistory
                                self.goalHistory.sort(by: { $0.goalID > $1.goalID} )
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    self.loadingLabelControl(array: newHistory)
                                }
                            }
                        }
                    }
                }
                
            }
            self.loadingLabelControl(array: newHistory)
        }
    }
    
    
    func savePressed(){
        if idInput.isHidden {
            idInput.isHidden = false
            idSaveButtonOutlet.setTitle("Save", for: .normal)
            userIDLabel.isHidden = true
            defaults.set(K.none, forKey: keyForDf.nickName)
        } else {
            idInput.resignFirstResponder()
            let name = idInput.text!
            idInput.text = ""
            userIDLabel.isHidden = false
            defaults.set(name, forKey: keyForDf.nickName)
            userIDLabel.text = name
            idInput.isHidden = true
            idSaveButtonOutlet.setTitle("Clear", for: .normal)
        }
    }
    
    func idControl() {
        if defaults.string(forKey: keyForDf.nickName) == K.none {
            userIDLabel.isHidden = true
            idInput.isHidden = false
            idSaveButtonOutlet.setTitle("Save", for: .normal)
        } else {
            userIDLabel.isHidden = false
            idInput.isHidden = true
            userIDLabel.text = defaults.string(forKey: keyForDf.nickName)
            idSaveButtonOutlet.setTitle("Clear", for: .normal)
        }
    }
    
    func loadingLabelControl(array: Array<Any>){
        if array.isEmpty {
            print("array.isEmpty")
            loadingLabel.alpha = 0
            historyIsEmptyLabel.alpha = 1
        } else {
            print("array.Not Empty")
            loadingLabel.alpha = 0
            historyIsEmptyLabel.alpha = 0
        }
    }
    
    func loadingLabelControl() {
        loadingLabel.alpha = 0
        historyIsEmptyLabel.alpha = 0
    }
    
    
    func setGeneralInfo(){
        let info = goalManager.loadGeneralInfo()
        let ability = String(format: "%.1f", info.usersAbility)
        DispatchQueue.main.async {
            self.successPerAttemptLabel.text = "총 \(info.totalTrial)번의 시도, \(info.totalAchievement)번의 목표달성에 성공"
            self.averageSuccessDayLabel.text = "100일 중 평균 \(info.successPerHundred)일 성공"
            self.commitAbilityPercentageLabel.text = "실행 능력 확률 \(ability)%"
        }
    }
    
    
    
        
//        db.collection(K.userData).document(userID).setData([
//            keyForDf.GI_generalInfo : [
//                keyForDf.GI_totalTrial : info.totalTrial,
//                keyForDf.GI_totalAchievement : info.totalAchievement,
//                keyForDf.GI_successPerHundred : info.successPerHundred,
//                keyForDf.GI_usersAbility : info.usersAbility
//            ]
//        ], merge: true)
   
    
    
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
        let startDate = dateManager.dateFormat(type: "yyyy년M월d일", date: goal.startDate)
        let endDate = dateManager.dateFormat(type: "yyyy년M월d일", date: goal.endDate)
        let goalAnalysis = goalManager.historyGoalAnalysis(goal: goal)
        
        cell.dateLabel.text = "\(startDate) - \(endDate)"
        cell.goalDescriptionLabel.text = goal.description
        //3번의 시도 후, 100일 중 98일의 실행으로 목표 달성 성공
        cell.goalResultLabel.text = goalAnalysis

        return cell
    }
    
  
    
}

