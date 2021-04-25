//
//  HistoryViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/07.
//


 ///1. viewDidLoad:
 ///2. Cave Added:
 ///3. Cave Quit:


import UIKit
import Firebase
import IQKeyboardManagerSwift

let labelControlNoti : Notification.Name = Notification.Name("labelControlNoti")
let shareSuccessNoti : Notification.Name = Notification.Name("shareSuccessNoti")

protocol HistoryUpdateDelegate {
    func loadHistory(_ goalManager: GoalManager, history: GoalStruct)
    func setUpperBoxDescription(_ goalManager: GoalManager, info: UsersGeneralInfo)
    func reloadTableView(_ goalManager: GoalManager)
}

class HistoryViewController: UIViewController {
    
    var goalHistory : [GoalStruct] = []
    let dateManager = DateManager()
    let goalManager = GoalManager()
    let dgQueue = DispatchQueue.init(label: "dgQueue")
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        goalManager.delegate = self
        self.userIDLabel.isHidden = true
        self.loadingLabel.alpha = 1
        self.historyIsEmptyLabel.alpha = 0
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "historyCell")
        NotificationCenter.default.addObserver(self, selector: #selector(self.labelControl(_:)), name: labelControlNoti, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.shareSuccess(_:)), name: shareSuccessNoti, object: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        idControl()
        self.goalManager.loadGeneralInfo(forDelegate: true, { (UsersGeneralInfo) in })
        goalHistory = []
        self.goalManager.loadHistory()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //        self.loadingLabelControl(array: self.goalHistory)
    }
    
    
    @objc func labelControl(_ noti: Notification) {
        loadingLabelControl()
    }
    
    @objc func shareSuccess(_ noti: Notification) {
        let load = defaults.string(forKey: keyForDf.nickName) ?? "닉네임 없음"
        var nickName : String {
            return load == K.none ? "닉네임 없음" : load
        }
        
        let alert = UIAlertController.init(title: "Share to Board", message: "\(nickName) 이름으로 업적을 Board 페이지에 공유하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "네", style: .default, handler: { (UIAlertAction) in
            let goalID = noti.object as! String
            self.shareSuccess(goalID: goalID)
        }))
        alert.addAction(UIAlertAction(title: "아니오", style: .destructive, handler:nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func cleanHistoryPressed(_ sender: UIButton) {
        let alert = UIAlertController.init(title: "Clean History", message: "사용자의 정보를 초기화합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "초기화", style: .destructive, handler: { (UIAlertAction) in
            self.resetHitoryData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func resetHitoryData(){
        self.goalHistory = []
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        let crrNumberOfSuccess = defaults.integer(forKey: keyForDf.crrNumOfSucc)
        let crrNumberOfFail = defaults.integer(forKey: keyForDf.crrNumOfFail)
        let goalExists = defaults.bool(forKey: keyForDf.goalExistence )
        var currentlyRunning : Int { return goalExists ?  1 : 0 }
//        print("crrNumberOfSuccess: \(crrNumberOfSuccess)")
//        print("crrNumberOfFail: \(crrNumberOfFail)")
//        print("goalExists: \(goalExists)")
//        print("currentlyRunning: \(currentlyRunning)")
        db.collection(K.FS_userGeneral).document(userID).setData([
            fb.GI_generalInfo : [
                fb.GI_totalTrial : 0+currentlyRunning,
                fb.GI_totalDaysBeenThrough : 0 + crrNumberOfSuccess + crrNumberOfFail,
                fb.GI_totalSuccess : 0+crrNumberOfSuccess,
                fb.GI_totalAchievement : 0,
                fb.GI_successPerHundred : 0
            ]
        ], merge: true)
        db.collection(K.FS_userHistory).document(userID).delete()
        dgQueue.async {
            self.goalManager.loadHistory()
        }
        self.goalManager.loadGeneralInfo(forDelegate: true, { (UsersGeneralInfo) in })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    

    
    func savePressed(){

        if idInput.isHidden {
            ///reset눌렀을때
            idInput.isHidden = false
            idSaveButtonOutlet.setTitle("Save", for: .normal)
            userIDLabel.isHidden = true
            defaults.set(K.none, forKey: keyForDf.nickName)
        } else {
            ///닉네임 save눌렀을때
            if idInput.text == "" {
                
            } else {
                idInput.resignFirstResponder()
                let name = idInput.text!
                idInput.text = ""
                userIDLabel.isHidden = false
                defaults.set(name, forKey: keyForDf.nickName)
                saveNickNameOnDB(name)
                userIDLabel.text = name
                idInput.isHidden = true
                idSaveButtonOutlet.setTitle("Clear", for: .normal)
            }
            
        }
    }
    
    func saveNickNameOnDB(_ nickName: String){
        if let userID = defaults.string(forKey: keyForDf.crrUser) {
            db.collection(K.FS_userNickName).document(userID).setData(["nickName":nickName])
        }
    }
    
    func idControl() {
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        if defaults.string(forKey: keyForDf.nickName) == K.none {
            let nickNameDocument = db.collection(K.FS_userNickName).document(userID)
            nickNameDocument.getDocument { (document, error) in
                if let doc = document {
                    if doc.exists {
                        if let data = doc.data() {
                            if let nickName = data["nickName"] as? String {
                                self.userIDLabel.isHidden = false
                                self.idInput.isHidden = true
                                self.userIDLabel.text = nickName
                                self.idSaveButtonOutlet.setTitle("Clear", for: .normal)
                            }
                        }
                    } else {
                        self.userIDLabel.isHidden = true
                        self.idInput.isHidden = false
                        self.idSaveButtonOutlet.setTitle("Save", for: .normal)
                    }
                }
            }
        } else {
            userIDLabel.isHidden = false
            idInput.isHidden = true
            userIDLabel.text = defaults.string(forKey: keyForDf.nickName)
            idSaveButtonOutlet.setTitle("Clear", for: .normal)
        }
    }
    
    func shareSuccess(goalID: String) {
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        let idDocument = db.collection(K.FS_userHistory).document(userID)
        let load = defaults.string(forKey: keyForDf.nickName) ?? "닉네임 없음"
        var nickName : String {
            return load == K.none ? "닉네임 없음" : load
        }
        
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
                        }
                        DispatchQueue.main.async {
                            self.goalHistory = []
                            self.goalManager.loadHistory()

                        }
                    }}}}}
    
}


extension HistoryViewController: HistoryUpdateDelegate {
    
    func setUpperBoxDescription(_ goalManager: GoalManager, info: UsersGeneralInfo) {
        self.averageSuccessDayLabel.text = "목표한 100일 중 평균 \(info.successPerHundred)일 성공"
        if info.totalSuccess == 0 {
            self.commitAbilityPercentageLabel.text = "실행 능력 확률 0.0%"
        } else {
            let ability = (Double(info.totalSuccess)/Double(info.totalDaysBeenThrough))*100
            let abilityString = String(format: "%.1f", ability)
            self.commitAbilityPercentageLabel.text = "나의 성공확률 \(abilityString)%"
        }
        self.successPerAttemptLabel.text = "총 \(info.totalTrial)번의 시도, \(info.totalAchievement)번의 목표달성에 성공"
    }
    
    func loadHistory(_ goalManager: GoalManager, history: GoalStruct) {
        self.goalHistory.append(history)
        self.goalHistory.sort(by: { $0.goalID > $1.goalID} )
        DispatchQueue.main.async {
            self.loadingLabelControl()
            self.tableView.reloadData()
        }
    }
    
    func reloadTableView(_ goalManager: GoalManager) {
        tableView.reloadData()
    }
    
    
    func loadingLabelControl() {
        if self.goalHistory.isEmpty {
            loadingLabel.alpha = 0
            historyIsEmptyLabel.alpha = 1
        } else {
            loadingLabel.alpha = 0
            historyIsEmptyLabel.alpha = 0
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
        let startDate = dateManager.dateFormat(type: "yyyy년M월d일", date: goal.startDate)
        let endDate = dateManager.dateFormat(type: "yyyy년M월d일", date: goal.endDate)
        let goalAnalysis = goalManager.historyGoalAnalysis(goal: goal)
        
        cell.goalID = goal.goalID
        
        cell.dateLabel.text = "\(startDate) - \(endDate)"
        
        if goal.shared {
            cell.shareOutlet.tintColor = .darkGray
            cell.shareOutlet.isEnabled = false
        } else {
            cell.shareOutlet.tintColor = .systemBlue
            cell.shareOutlet.isEnabled = true
        }
        
        switch goalAnalysis.type {
        case 1:
            cell.goalResultLabel.text = goalAnalysis.analysis
            cell.progressLabel.text = "성공"
            cell.progressLabel.textColor = .systemBlue
            cell.shareOutlet.isHidden = false
        case 2:
            cell.goalResultLabel.text = goalAnalysis.analysis
            cell.progressLabel.text = "실패"
            cell.progressLabel.textColor = .systemRed
            cell.shareOutlet.isHidden = true
        case 3:
            cell.goalResultLabel.text = goalAnalysis.analysis
            cell.progressLabel.text = "진행중"
            cell.progressLabel.textColor = .systemGreen
            cell.shareOutlet.isHidden = true
        default:
            cell.goalResultLabel.text = goalAnalysis.analysis
        }
        cell.goalDescriptionLabel.text = goal.description
        return cell
    }
    
  
    
}



//
//    func loadHistory(){
//        var newHistory : [GoalStruct] = []
//        let userID = defaults.string(forKey: keyForDf.crrUser)!
//        print("***********\(userID)")
//        loadingLabelControl()
//
//        let idDocument = db.collection(K.FS_userHistory).document(userID)
//        idDocument.getDocument { (querySnapshot, error) in
//            if let e = error {
//                print("load doc failed: \(e.localizedDescription)")
//                self.loadingLabelControl(array: newHistory)
//            } else {
//                if let usersHistory = querySnapshot?.data() {
//                    for history in usersHistory {
//                        if let aGoal = history.value as? [String:Any] {
//                            if let compl = aGoal[G.completed] as? Bool,
//                               let des = aGoal[G.description] as? String,
//                               let fail = aGoal[G.failAllowance] as? Int,
//                               let gID = aGoal[G.goalID] as? String,
//
//                               let start = aGoal[G.startDate] as? String,
//                               let end = aGoal[G.endDate] as? String,
//
//                               let goalAch = aGoal[G.goalAchieved] as? Bool,
//
//                               let uID = aGoal[G.userID] as? String,
//                               let daysNum = aGoal[G.numOfDays] as? Int,
//                               let numOfSuc = aGoal[G.numOfSuccess] as? Int,
//                               let numOfFail = aGoal[G.numOfFail] as? Int
//
//                            {
//                                let startDate = self.dateManager.dateFromString(string: start)
//                                let endDate = self.dateManager.dateFromString(string: end)
//                                let aHistory = GoalStruct(userID: uID, goalID: gID, startDate: startDate, endDate: endDate, failAllowance: fail, description: des, numOfDays: daysNum, completed: compl, goalAchieved: goalAch, numOfSuccess: numOfSuc, numOfFail: numOfFail)
//                                newHistory.append(aHistory)
//                                self.goalHistory = newHistory
//                                self.goalHistory.sort(by: { $0.goalID > $1.goalID} )
//                                DispatchQueue.main.async {
//                                    self.tableView.reloadData()
//                                    self.loadingLabelControl(array: newHistory)
//                                }
//                            }
//                        }
//                    }
//                }
//
//            }
//            self.loadingLabelControl(array: newHistory)
//        }
//    }
    
