//
//  HistoryViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/07.
//


import UIKit
import Firebase
import IQKeyboardManagerSwift
import RxCocoa
import RxSwift

let shareSuccessNoti : Notification.Name = Notification.Name("shareSuccessNoti")
let reloadTableViewNoti: Notification.Name = Notification.Name("reloadTableViewNoti")

class HistoryViewController: UIViewController {
    
    private let firestoreService = FireStoreService()
    private let serialQueue = DispatchQueue.init(label: "serialQueue")
    private var historyListVM: HistoryListViewModel!
    private var upperBoxGeneralInfoVM: UpperBoxGeneralInfoViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var successPerAttemptLabel: UILabel!
    @IBOutlet weak var averageSuccessDayLabel: UILabel!
    @IBOutlet weak var commitAbilityPercentageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingLabel: UIView!
    @IBOutlet weak var historyIsEmptyLabel: UIView!
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var nickNameInputTextField: UITextField!
    @IBOutlet weak var nickNameSaveAndClearButton: UIButton!
    @IBAction func nickNameButtonPressed(_ sender: UIButton) {
        self.nickNameButtonPressed()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "historyCell")
        NotificationCenter.default.addObserver(self, selector: #selector(self.shareSuccess(_:)), name: shareSuccessNoti, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadHistory(_:)), name: reloadTableViewNoti, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadUsersGeneralInfo()
        self.loadHistory()
        self.setNickName()
        //self.printStatus()
    }

    
    private func loadHistory(){
        var goalArray = [GoalModel]()
        self.firestoreService.loadHistory(completion: { goal in
            self.serialQueue.async {
                goalArray.append(goal)
                goalArray.sort { $0.goalID > $1.goalID }
            }
            self.serialQueue.async {
                var i = 0
                for goal in goalArray {
                    if goal.status == Status.success {
                        let g = goal
                        goalArray.remove(at:i)
                        goalArray.insert(g, at: 0)
                    }
                    i+=1
                }
            }
            self.serialQueue.async {
                var i = 0
                for goal in goalArray {
                    if goal.status == Status.none {
                        let g = goal
                        goalArray.remove(at:i)
                        goalArray.insert(g, at: 0)
                    }
                    i+=1
                }
            }
            self.serialQueue.async {
                let history = HistoryListViewModel.init(goalArray)
                self.historyListVM = history
                self.loadingLabelBinding()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, completionerror: {
            let history = HistoryListViewModel.init(goalArray)
            self.historyListVM = history
            self.loadingLabelBinding()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
       
    }
    
    
    private func loadingLabelBinding(){
        self.historyListVM.historyEmpty()
            .bind(onNext: { bool in
                if bool {
                    DispatchQueue.main.async {
                        self.loadingLabel.alpha = 0
                        self.historyIsEmptyLabel.alpha = 1
                    }
                } else {
                    DispatchQueue.main.async {
                        self.loadingLabel.alpha = 0
                        self.historyIsEmptyLabel.alpha = 0
                    }
                }
            }).disposed(by: disposeBag)
    }

    
    @objc
    func shareSuccess(_ noti: Notification) {
        let nickName = defaults.string(forKey: UDF.nickName) ?? "닉네임 없음"
        
        let alert = UIAlertController.init(title: "Share to Board", message: "\(nickName) 이름으로 업적을 Board 페이지에 공유하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "네", style: .default, handler: { (UIAlertAction) in
            let goalID = noti.object as! String
            self.firestoreService.shareSuccess(goalID, nickName: nickName)
        }))
        alert.addAction(UIAlertAction(title: "아니오", style: .destructive, handler:nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    func loadHistory(_ noti: Notification){
        self.loadHistory()
    }
    
    
    @IBAction func cleanHistoryPressed(_ sender: UIButton) {
        let alert = UIAlertController.init(title: "Clear History", message: "사용자의 정보를 초기화합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "초기화", style: .destructive, handler: { (UIAlertAction) in
            self.clearHistory()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    private func clearHistory(){
        self.historyListVM.clearHistory()
        
        serialQueue.async {
            self.firestoreService.resetHistoryData()
        }
        serialQueue.async {
            self.loadUsersGeneralInfo()
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    //MARK: - Upper Description Box Controll
    
    private func loadUsersGeneralInfo(){
        self.firestoreService.loadGeneralInfo { info in
            let generalInfo = UpperBoxGeneralInfoViewModel.init(info)
            self.upperBoxGeneralInfoVM = generalInfo
            self.usersGeneralInfoBinding()
        }
    }
    
    private func usersGeneralInfoBinding(){
        
        self.upperBoxGeneralInfoVM.successPerTrial.asDriver(onErrorJustReturn: "")
            .drive(self.successPerAttemptLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.upperBoxGeneralInfoVM.averageSuccessPerGoal.asDriver(onErrorJustReturn: "")
            .drive(self.averageSuccessDayLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.upperBoxGeneralInfoVM.successPerctage.asDriver(onErrorJustReturn: "")
            .drive(self.commitAbilityPercentageLabel.rx.text)
            .disposed(by: self.disposeBag)
    }

}




//MARK: - NickNameControll
    

extension HistoryViewController {
    
    private func setNickName(){
        if let nickName = defaults.string(forKey: UDF.nickName) {
            self.nickNameLabel.text = nickName
            self.nickNameIsOnTheScreen()
        } else {
            self.noNickNameSaveModeUIChange()
        }
    }
    
    private func noNickNameSaveModeUIChange(){
        self.nickNameLabel.isHidden = true
        self.nickNameInputTextField.isHidden = false
        self.nickNameSaveAndClearButton.setTitle("Save", for: .normal)
    }
    
    private func nickNameIsOnTheScreen(){
        nickNameLabel.isHidden = false
        nickNameInputTextField.isHidden = true
        nickNameSaveAndClearButton.setTitle("Clear", for: .normal)
    }
    
    private func nickNameButtonPressed() {
        if nickNameSaveAndClearButton.titleLabel?.text == "Clear" {
            noNickNameSaveModeUIChange()
            defaults.removeObject(forKey: UDF.nickName)
        } else if nickNameSaveAndClearButton.titleLabel?.text == "Save" {
            if let nickName = self.nickNameInputTextField.text {
                self.nickNameInputTextField.text = ""
                self.nickNameLabel.text = nickName
                nickNameIsOnTheScreen()
                defaults.set(nickName, forKey: UDF.nickName)
            }
        }
        
    }
    
}



//MARK: - TableViewController

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyListVM == nil ? 0 : historyListVM.historyList.count
    }
    
    func sharedButtonControll(_ tableView: UITableView, cellForRowAt indexPath: IndexPath){
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? HistoryTableViewCell else { return }
        
        cell.shareOutlet.tintColor = .darkGray
        cell.shareOutlet.isEnabled = false
        cell.shareOutlet.isHidden = true
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
    
        let historyVM = historyListVM.historyAt(indexPath.row)
        cell.index = indexPath.row
        
        historyVM.goalDescription.asDriver(onErrorJustReturn: "")
            .drive(cell.goalDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        historyVM.progressLabel.asDriver(onErrorJustReturn: Status.none)
            .drive(onNext: { status in
                let numOfSuc = historyVM.history.numOfSuccess
                switch status {
                case Status.success:
                    cell.goalResultLabel.text = "100일 중 \(numOfSuc)일의 실행으로 목표 달성 성공!"
                    cell.progressLabel.text = "성공"
                    cell.progressLabel.textColor = .systemBlue
                case Status.fail:
                    cell.goalResultLabel.text = "100일 중 \(numOfSuc)일의 실행으로 목표 달성 실패"
                    cell.progressLabel.text = "실패"
                    cell.progressLabel.textColor = .systemRed
                default:
                    cell.goalResultLabel.text = "100일 중 \(numOfSuc)일의 실행으로 목표 달성 진행중!"
                    cell.progressLabel.text = "진행중"
                    cell.progressLabel.textColor = .systemGreen
                }
            }).disposed(by:disposeBag)
        
        
        historyVM.goalID.asDriver(onErrorJustReturn: "")
            .drive(cell.rx.goalID)
            .disposed(by: disposeBag)
        
        historyVM.dateDescription.asDriver(onErrorJustReturn: "")
            .drive(cell.dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        historyVM.shareBoardButtonAppearance
            .asDriver(onErrorJustReturn: ShareButtonAppearance.invisible)
            .drive(onNext: { shareButtonAppearance in
                switch shareButtonAppearance {
                case ShareButtonAppearance.enabled:
                    cell.shareOutlet.tintColor = .systemBlue
                    cell.shareOutlet.isEnabled = true
                    cell.shareOutlet.isHidden = false
                case ShareButtonAppearance.unabled:
                    cell.shareOutlet.tintColor = .darkGray
                    cell.shareOutlet.isEnabled = false
                    cell.shareOutlet.isHidden = false
                case ShareButtonAppearance.invisible:
                    cell.shareOutlet.isHidden = true
                }
            }).disposed(by: disposeBag)
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let historyToRemove = self.historyListVM.historyList[indexPath.row].history
        let info = self.upperBoxGeneralInfoVM.generalInfo
        if historyToRemove.status != Status.none && historyToRemove.shared == false {
            let action = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completion) in
                self.firestoreService.removeSingleHistory(goalID: historyToRemove.goalID)
                self.firestoreService.singleHistoryRemovedUpdateUserInfo(theHistory: historyToRemove,userInfo: info)
                self.loadHistory()
                self.loadUsersGeneralInfo()
            }
            return UISwipeActionsConfiguration(actions: [action])
        } else if historyToRemove.shared == true  {
            let action3 = UIContextualAction(style: .normal, title: "Board에 공유중") { (action, view, completion) in
            }
            return UISwipeActionsConfiguration(actions: [action3])
            
        } else {
            let action2 = UIContextualAction(style: .normal, title: "진행중") { (action, view, completion) in
            }
            return UISwipeActionsConfiguration(actions: [action2])
        }
    }
//
//    func printStatus(){
//        print("-------- userID : \(defaults.string(forKey: KeyForDf.userID)!)")
//        print("-------- crrGoalExists : \(defaults.bool(forKey: KeyForDf.crrGoalExists))")
//        print("")
//        print("<<<User Info>>>")
//        print("-------- totalAchievements : \(defaults.integer(forKey: KeyForDf.totalAchievements))")
//        print("-------- totalFail : \(defaults.integer(forKey: KeyForDf.totalFail))")
//        print("-------- totalSuccess : \(defaults.integer(forKey: KeyForDf.totalSuccess))")
//        print("-------- totalTrial : \(defaults.integer(forKey: KeyForDf.totalTrial))")
//        print("")
//        print("<<<Crr Goal>>>")
//        print("-------- failNumber : \(defaults.integer(forKey: KeyForDf.failNumber))")
//        print("-------- successNumber : \(defaults.integer(forKey: KeyForDf.successNumber))")
//    }
//
}

