//
//  CaveViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//



import UIKit
import Firebase
import RxSwift
import RxCocoa

let checkTheDateNoti : Notification.Name = Notification.Name("CheckTheDateNotification")
let failedNoti: Notification.Name = Notification.Name("failedNotification")

class CaveViewController: UIViewController {
    
    private let dateManager = DateManager()
    private let goalManager = GoalManager()
    private let dataManager = DataManager()
    
    private let caveGoalAddVC = AddNewGoalViewController()
    
    private var goalVM : GoalViewModel!
    private var daysVM : DaysViewModel!
    
    private let disposeBag = DisposeBag()
    
    private var goalExixtence : Bool {
        return defaults.bool(forKey: keyForDf.goalExistence)
    }
    
    @IBOutlet var caveView: UIView!
    @IBOutlet weak var startYour100DaysView: UIView!
    @IBOutlet weak var goalManageScrollView: UIScrollView!
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var datePeriodLabel: UILabel!
    @IBOutlet weak var squareCollectionView: UICollectionView!
    @IBOutlet weak var numbersOfSuccessAndFailLabel: UILabel!
    @IBOutlet weak var leftFailAllowanceLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var checkToday: UIButton!
    @IBOutlet weak var collectionVw: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkAlert(_:)), name: checkTheDateNoti, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goalFailed(_:)), name: failedNoti, object: nil)
        self.viewModelSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showGoalManageScrollView(goalExixtence)
        self.collectionVw.reloadData()
       
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewGoalViewController" {
            let vc = segue.destination as! AddNewGoalViewController
            vc.newGoalSubjectObservable.subscribe(onNext: { totalGoalInfo in
                let newGoalVM = CaveViewModel.init(totalGoalInfo)
                self.goalVM = newGoalVM.goalVM
                self.daysVM = newGoalVM.collectionViewVM
                self.goalBinding()
                self.checkTodayButtonSetting()
                self.collectionVw.reloadData()
                self.showGoalManageScrollView(true)
            }).disposed(by: disposeBag)
        }
    }
    
    private func viewModelSetting(){
        if goalExixtence == true {
            self.dataManager.loadDefaultsCurrentGoalInfo { goal in
                let goalVM = GoalViewModel.init(goal)
                self.goalVM = goalVM
                self.goalBinding()
            }
            self.dataManager.loadDefaultsCurrentDaysArrayInfo { daysArr in
                let collectionViewVM = DaysViewModel.init(daysArr)
                self.daysVM = collectionViewVM
                self.checkTodayButtonSetting()
            }
        }
    }
    
    private func goalBinding(){
        goalVM.description.asDriver(onErrorJustReturn: "")
            .drive(self.goalDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
    
        goalVM.datePeriod.asDriver(onErrorJustReturn: "")
            .drive(self.datePeriodLabel.rx.text)
            .disposed(by: disposeBag)

        goalVM.numbersOfSuccessAndFail.asDriver(onErrorJustReturn: "")
            .drive(self.numbersOfSuccessAndFailLabel.rx.text)
            .disposed(by: disposeBag)

        goalVM.leftFailAllowancd.asDriver(onErrorJustReturn: "")
            .drive(self.leftFailAllowanceLabel.rx.text)
            .disposed(by: disposeBag)

        goalVM.leftDays.asDriver(onErrorJustReturn: "")
            .drive(self.daysLeftLabel.rx.text)
            .disposed(by: disposeBag)
    }
    

    private func checkTodayButtonSetting(){
        daysVM.todayIsCheckedBool.asDriver(onErrorJustReturn: false)
            .drive(onNext: { bool in
                self.checkTodayButtonUIChange(checked: bool)
            }).disposed(by: disposeBag)
    }
    

    
    private func checkTodayButtonUIChange(checked: Bool){
        let today = dateManager.dateFormat(type: "M월d일", date: Date())
        let date = dateManager.dateFormat(type: "e", date: Date())
        if checked == false {
            checkToday.isHidden = false
            checkToday.setTitle("\(today) \(date) 오늘 체크하기", for: .normal)
        } else if checked == true {
            checkToday.isHidden = true
        }
    }
    
    private func showGoalManageScrollView(_ bool: Bool) {
        if bool {
            startYour100DaysView.isHidden = true
            goalManageScrollView.isHidden = false
        } else {
            startYour100DaysView.isHidden = false
            goalManageScrollView.isHidden = true
        }
    }
//    
//    private func checkTodayButtonClose(){
//        let today = dateManager.dateFormat(type: "M월d일", date: Date())
//        let date = dateManager.dateFormat(type: "e", date: Date())
//        checkToday.isEnabled = false
//        checkToday.setTitle("\(today) \(date) 확인 완료", for: .normal)
//    }

}

//MARK: - Quit Current Goal

extension CaveViewController {
    
    @IBAction func quitPressed(_ sender: UIButton) {
        let alertQuitPressed = UIAlertController.init(title: "그만두기", message: "진행중인 목표를 중단합니다.", preferredStyle: .alert)
        alertQuitPressed.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        alertQuitPressed.addAction(UIAlertAction(title: "그만두기", style: .destructive, handler: { (UIAlertAction) in
            self.quitCurrentGoal()
        }))
        present(alertQuitPressed, animated: true, completion: nil)
    }
    
    private func quitCurrentGoal(){
        defaults.set(false, forKey: keyForDf.goalExistence)
        self.dataManager.removeCurrentGoal(self.goalVM.goal)
        self.showGoalManageScrollView(false)
    }
    
}


//MARK: - Success And Fail Day Controll

extension CaveViewController {
    

    
    @IBAction func checkTodayPressed(_ sender: UIButton) {
        let start = self.goalVM.goal.startDate
        let asking = self.checkTodayAlertSentence()
        
        let dayToDay = Calendar.current.dateComponents([.day], from: start, to: Date()).day! as Int
        let dayNum = dayToDay + 1

        let checkTodayAlert = UIAlertController.init(title: "오늘하루 어떠셨나요 :)", message: asking, preferredStyle: .actionSheet)
        
        checkTodayAlert.addAction(UIAlertAction(title: "실패", style: .default, handler: {
            (UIAlertAction) in
            self.setTodaysResult(bool: false, dayNum: dayNum)
        }))

        checkTodayAlert.addAction(UIAlertAction(title: "성공", style: .destructive, handler: { (UIAlertAction) in
            self.setTodaysResult(bool: true, dayNum: dayNum)
        }))

        present(checkTodayAlert, animated: true,completion: nil)
        
    }
    

    
    private func checkTodayAlertSentence() -> String {
        let now = Calendar.current.dateComponents(in:.current, from: Date())
        let monthDate = dateManager.dateFormat(type: "M월d일", dateComponets: now)
        let whichDay = dateManager.dateFormat(type: "e", dateComponets: now)
        let asking = "\(monthDate)\(whichDay), 성공하셨나요?"
        return asking
    }
    

    @objc func checkAlert(_ noti: Notification) {
        let checkTheDayPressed = UIAlertController.init(title: "미확인 날짜 체크", message: "이날 목표는 성공하셨나요?", preferredStyle: .alert)
        
        checkTheDayPressed.addAction(UIAlertAction(title: "실패", style: .default, handler: { (UIAlertAction) in
            if let dayNumber = noti.object as? Int {
                self.setTodaysResult(bool: false, dayNum: dayNumber)
            }}))
        
        checkTheDayPressed.addAction(UIAlertAction(title: "성공", style: .destructive, handler: { (UIAlertAction) in
            if let dayNumber = noti.object as? Int {
                self.setTodaysResult(bool: true, dayNum: dayNumber)
            }}))
        
        present(checkTheDayPressed, animated: true, completion: nil)
    }
    
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    @objc func goalFailed(_ noti: Notification) {
        let failedAlert = UIAlertController.init(title: "목표달성 실패", message: "허용가능한 불이행 횟수를 초과하여 목표달성에 실패하였습니다.", preferredStyle: .alert)
        failedAlert.addAction(UIAlertAction(title: "확인", style: . destructive, handler: { (UIAlertAction) in
            defaults.set(false, forKey: keyForDf.goalExistence)
            //self.dataManager.quitTheGoal()
            self.showGoalManageScrollView(false)
        }))
        present(failedAlert, animated: true, completion: nil)
    }
    
    
    func setTodaysResult(bool: Bool, dayNum: Int){
        let goal = goalVM.goal!
        let today = dateManager.dateFormat(type: "yyyyMMdd", date: Date())
        let lastDay = dateManager.dateFormat(type: "yyyyMMdd", date: self.goalVM.goal.endDate)
        
        if goal.numOfSuccess + goal.numOfFail == 99 {
            ///Goal끝나는 경우 lastDayControl
            self.goalManager.lastDayControl(successed: bool, goal: goal)
            performSegue(withIdentifier: "acc", sender: self)
            
        } else {
            self.updateGoalVM(bool: bool)
            self.updateDaysVM(bool: bool, index: dayNum-1)
            self.goalBinding()
            self.checkTodayButtonSetting()
            if today == lastDay {
                uncheckedDaysExistOnLastDayAlertPresent()
            }
        }
    }
    
    private func updateGoalVM(bool: Bool){
        if bool {
            self.goalVM.countSuccess { newGoal in
                self.dataManager.fs_SaveGoalData(newGoal)
                self.dataManager.df_SaveGoalInfo(newGoal)
            }
        } else {
            self.goalVM.countFail { newGoal in
                self.dataManager.fs_SaveGoalData(newGoal)
                self.dataManager.df_SaveGoalInfo(newGoal)
            }
        }
    }

    
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private func overFailAllowanceCheck(newGoal: Goal) {
        if newGoal.failAllowance == newGoal.numOfFail {
            let failedAlert = UIAlertController.init(title: "목표달성 실패", message: "허용가능한 불이행 횟수를 초과하여 목표달성에 실패하였습니다.", preferredStyle: .alert)
            failedAlert.addAction(UIAlertAction(title: "확인", style: . destructive, handler: { (UIAlertAction) in
                defaults.set(false, forKey: keyForDf.goalExistence)
                //self.dataManager.quitTheGoal()
                self.showGoalManageScrollView(false)
            }))
            present(failedAlert, animated: true, completion: nil)
        }
    }
    
    private func updateDaysVM(bool: Bool, index: Int){
        if bool {
            self.daysVM.updateSuccess(index: index) { daysArr in
                self.dataManager.fs_SaveDaysInfo(daysArr)
                self.dataManager.df_saveDaysInfo(daysArr)
                DispatchQueue.main.async {
                    self.collectionVw.reloadData()
                }
            }
        } else {
            self.daysVM.updateFail(index: index) { daysArr in
                self.dataManager.fs_SaveDaysInfo(daysArr)
                self.dataManager.df_saveDaysInfo(daysArr)
                DispatchQueue.main.async {
                    self.collectionVw.reloadData()
                }
            }
        }
    }
    
    
    private func uncheckedDaysExistOnLastDayAlertPresent(){
        let alert = UIAlertController.init(title: "미확인 날짜 존재", message: "아직 확인하지 못한 날짜를 체크해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
    
}





//MARK: - Collection View

extension CaveViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Square", for: indexPath) as? SquareCell else { return UICollectionViewCell() }
        
        
        if let singleDayVM = daysVM?.singleDayAt(index: indexPath.row)  {
            
            cell.singleDayInfo = self.daysVM.singleDayAt(index: indexPath.row).singleDayInfo
            let dateManager = DateManager()
            let today = dateManager.dateFormat(type: "yyyyMMdd", date: Date())
            
            if singleDayVM.singleDayInfo.date == today {
                singleDayVM.todayStatus.asDriver(onErrorJustReturn: DaySquareStatus.Today.success)
                    .drive(onNext: { status in
                        cell.todayLabel.alpha = 1
                        cell.todayLabel.text = "오늘"
                        cell.todayLabel.textColor = .black
                        switch status {
                        case DaySquareStatus.Today.success:
                            cell.squareImage.image = #imageLiteral(resourceName: "todaySuccess")
                        case DaySquareStatus.Today.failed:
                            cell.squareImage.image = #imageLiteral(resourceName: "todayFail")
                        case DaySquareStatus.Today.unchecked:
                            cell.squareImage.image = #imageLiteral(resourceName: "todayEmpty")
                        }
                    }).disposed(by: disposeBag)
                
            } else if singleDayVM.singleDayInfo.date < today {
                singleDayVM.pastStatus.asDriver(onErrorJustReturn: DaySquareStatus.Past.success)
                    .drive(onNext: { status in
                        cell.todayLabel.alpha = 0
                        switch status {
                        case DaySquareStatus.Past.success:
                            cell.squareImage.image = #imageLiteral(resourceName: "SuccessSquare")
                            cell.buttonOutlet.isEnabled = false
                        case DaySquareStatus.Past.failed:
                            cell.squareImage.image = #imageLiteral(resourceName: "FailSquare")
                            cell.buttonOutlet.isEnabled = false
                        case DaySquareStatus.Past.unchecked:
                            cell.squareImage.image = #imageLiteral(resourceName: "WarningSquare")
                            cell.buttonOutlet.isEnabled = true
                        }
                    }).disposed(by: disposeBag)
                
            } else if singleDayVM.singleDayInfo.date > today {
                singleDayVM.pastStatus.asDriver(onErrorJustReturn: DaySquareStatus.Past.success)
                    .drive(onNext: { status in
                        cell.squareImage.image = #imageLiteral(resourceName: "EmptySquare")
                        cell.buttonOutlet.isEnabled = false
                        cell.todayLabel.alpha = 1
                        cell.todayLabel.text = String(indexPath.row+1)
                        cell.todayLabel.textColor = .systemGray5
                    }).disposed(by: disposeBag)
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 0
        let textAreaHeight: CGFloat = 0
        
        let width: CGFloat = (collectionView.bounds.width - itemSpacing)/10
        let height: CGFloat = width * 1 + textAreaHeight

        return CGSize(width: width, height: height)
    }

}





