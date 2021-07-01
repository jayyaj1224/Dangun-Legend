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

class CaveViewController: UIViewController {
    
    private let fireStoreService = FireStoreService()
    private let userDefaultService = UserDefaultService()
    
    private let caveGoalAddVC = AddNewGoalViewController()
    
    let homeVC = HomeViewController()
    
    private var goalVM : GoalViewModel!
    private var daysVM : DaysViewModel!
    
    private let disposeBag = DisposeBag()
    
    
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
    
    private var needToSetViewModel : Bool {
        return defaults.bool(forKey: UDF.crrGoalExists)
    }
    
    private var goalExixtence : Bool {
        return defaults.bool(forKey: UDF.crrGoalExists)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkAlert(_:)), name: checkTheDateNoti, object: nil)
        if goalExixtence {
            self.goalViewModelSetting()
            self.daysViewModelSetting()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showGoalManageScrollView(self.goalExixtence)
        checkIfViewModelSettingIsNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        scrollToTop()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewGoalViewController" {
            let vc = segue.destination as! AddNewGoalViewController
            
            vc.newGoalSubjectObservable.subscribe(onNext: { totalGoalInfo in
                let newGoalVM = CaveViewModel.init(totalGoalInfo)
                self.goalVM = newGoalVM.goalVM
                self.daysVM = newGoalVM.collectionViewVM
                
                DispatchQueue.main.async {
                    self.goalBinding()
                    self.checkTodayButtonSetting()
                    self.collectionVw.reloadData()
                    self.scrollToTop()
                }
                self.showGoalManageScrollView(true)
            }).disposed(by: disposeBag)
        }
    }
    
    private func checkIfViewModelSettingIsNeeded(){
        print("checking if ViewModel needs to be set")
        
        if self.needToSetViewModel {
            print("bbbb")
            defaults.set(false, forKey: UDF.needToSetViewModel)
            self.goalViewModelSetting()
            self.daysViewModelSetting()
        }
    }
    
    
    private func goalViewModelSetting(){
        print("goalViewModelSetting")
        defaults.set(false, forKey: UDF.needToSetViewModel)
        
        self.fireStoreService.loadCurrentGoal { goalModel in
            let goalVM = GoalViewModel.init(goalModel)
            self.goalVM = goalVM
            defaults.set(goalModel.goalID, forKey: UDF.goalID)
            defaults.set(goalModel.numOfSuccess, forKey: UDF.successNumber)
            defaults.set(goalModel.numOfFail, forKey: UDF.failNumber)
            DispatchQueue.main.async {
                self.goalBinding()
            }
        }
    }
    
    private func daysViewModelSetting(){
        self.fireStoreService.loadCurrentDaysInfo { dayModelArray in
            let daysVM = DaysViewModel.init(dayModelArray)
            self.daysVM = daysVM
            DispatchQueue.main.async {
                self.collectionVw.reloadData()
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

        goalVM.leftFailAllowancd.asDriver(onErrorJustReturn: 1)
            .drive(onNext: { leftChance in
                if leftChance == 1 {
                    let string = "마지막 1번 추가 목표 불이행 시, 목표는 실패합니다."
                    self.leftFailAllowanceLabel.text = string
                    self.leftFailAllowanceLabel.textColor = .red
                } else {
                    let string = "잔여 목표 불이행 허용 횟수: \(leftChance)회"
                    self.leftFailAllowanceLabel.text = string
                    self.leftFailAllowanceLabel.textColor = .black
                }
            })
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
        let dateManager = DateCalculate()
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


}




//MARK: - Success And Fail Day Controll

extension CaveViewController {
    
    private func checkTodayAlertSentence(date: Date) -> String {
        let dateManager = DateCalculate()
        let now = Calendar.current.dateComponents(in:.current, from: date)
        let monthDate = dateManager.dateFormat(type: "M월d일", dateComponets: now)
        let whichDay = dateManager.dateFormat(type: "e", dateComponets: now)
        let asking = "\(monthDate)\(whichDay), 성공하셨나요?"
        return asking
    }
    
    @IBAction func checkTodayPressed(_ sender: UIButton) {
        let start = self.goalVM.goal.startDate
        let index = Calendar.current.dateComponents([.day], from: start, to: Date()).day! as Int
        let singleDayInfo = self.daysVM.daysInfoVM[index].singleDayInfo
        NotificationCenter.default.post(name: checkTheDateNoti, object: singleDayInfo, userInfo: nil)
    }
    
    
    @objc func checkAlert(_ noti: Notification) {
        guard let singleDayInfo = noti.object as? DayModel else { fatalError() }
         
        let dateManager = DateCalculate()
        let dateString = singleDayInfo.date
        let date = dateManager.yyMMddHHmmss_toDate(string: dateString)
        let asking = self.checkTodayAlertSentence(date: date)
        let checkTodayAlert = UIAlertController.init(title: "하루 잘 보내셨나요 :)", message: asking, preferredStyle: .actionSheet)
        
        checkTodayAlert.addAction(UIAlertAction(title: "실패", style: .default, handler: {
            (UIAlertAction) in
            self.setTodaysResult(bool: false, index: singleDayInfo.dayIndex-1)
        }))

        checkTodayAlert.addAction(UIAlertAction(title: "성공", style: .destructive, handler: { (UIAlertAction) in
            self.setTodaysResult(bool: true, index: singleDayInfo.dayIndex-1)
        }))
        present(checkTodayAlert, animated: true,completion: nil)
    }
    
    

    func setTodaysResult(bool: Bool, index: Int){
        
        self.updateGoalVM(success: bool)
        self.updateDaysVM(success: bool, index: index)
        
    }
    
    private func updateGoalVM(success: Bool){
        
        if success == true {
            self.goalVM.countSuccess(completion: { goalModel in
                let newGoalVM = GoalViewModel.init(goalModel)
                self.goalVM = newGoalVM
                updateFromResult(result: goalModel)
                DispatchQueue.main.async {
                    self.goalBinding()
                }
            })
            
            self.fireStoreService.goalInfoOneMoreSuccess()
            self.fireStoreService.userInfoOneMoreSuccess()
            self.userDefaultService.userInfo_oneMoreSuccess()
            self.userDefaultService.goal_oneMoreSuccess()
            
        } else {
            self.goalVM.countFail(completion: { goalModel in
                let newGoalVM = GoalViewModel.init(goalModel)
                self.goalVM = newGoalVM
                updateFromResult(result: goalModel)
                DispatchQueue.main.async {
                    self.goalBinding()
                }
            })
            self.fireStoreService.goalInfoOneMoreFail()
            self.fireStoreService.userInfoOneMoreFail()
            self.userDefaultService.userInfo_oneMoreFail()
            self.userDefaultService.goal_oneMoreFail()
        }
    }

    
    private func updateDaysVM(success: Bool, index: Int){
        if success == true {
            self.daysVM.updateSuccess(index: index) {
                // FireStore update
                self.fireStoreService.updateTheDay(index: index+1, successBool: true)
                
                DispatchQueue.main.async {
                    self.collectionVw.reloadData()
                    self.checkTodayButtonSetting()
                }
            }
        } else {
            self.daysVM.updateFail(index: index) { 
                // FireStore update
                self.fireStoreService.updateTheDay(index: index+1, successBool: false)
                
                DispatchQueue.main.async {
                    self.collectionVw.reloadData()
                    self.checkTodayButtonSetting()
                }
            }
        }
    }
    
    
    private func uncheckedDaysExistOnLastDayAlertPresent(){
        let alert = UIAlertController.init(title: "미확인 날짜 존재", message: "아직 확인하지 못한 날짜를 체크해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func overFailAllowance(newGoal: GoalModel) {
        let failedAlert = UIAlertController.init(title: "목표달성 실패", message: "허용가능한 불이행 횟수를 초과하여 목표달성에 실패하였습니다.", preferredStyle: .alert)
        failedAlert.addAction(UIAlertAction(title: "확인", style: . destructive, handler: { (UIAlertAction) in
            defaults.set(false, forKey: UDF.crrGoalExists)
            self.quitCurrentGoal()
            self.showGoalManageScrollView(false)
        }))
        present(failedAlert, animated: true, completion: nil)
    }
    
    
    
    private func updateFromResult(result: GoalModel){

        let dateManager = DateCalculate()
        let today = dateManager.dateFormat(type: "yyyyMMdd", date: Date())
        let lastDay = dateManager.dateFormat(type: "yyyyMMdd", date: result.endDate)
        
        if result.failAllowance + 1 == result.numOfFail {
            self.overFailAllowance(newGoal: result)
            
        } else if result.numOfFail + result.numOfSuccess >= 100 {
            
            performSegue(withIdentifier: "ResultViewController", sender: self)
            self.showGoalManageScrollView(false)
            
            self.fireStoreService.saveGoalAtHistory(result, status: Status.success)
            
            self.fireStoreService.removeCurrentGoal()
            self.fireStoreService.removeCurrentDaysInfo()
            
            self.fireStoreService.userInfoOneMoreAchieve()
            self.userDefaultService.userInfo_oneMoreAchievement()
            
        } else {
            if today == lastDay {
                uncheckedDaysExistOnLastDayAlertPresent()
            }
        }
    }
    
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
        self.showGoalManageScrollView(false)
        
        // FireStore 삭제
        self.fireStoreService.saveGoalAtHistory(self.goalVM.goal, status: Status.fail)
        self.fireStoreService.removeCurrentGoal()
        self.fireStoreService.removeCurrentDaysInfo()
        
        // Defaults 삭제 및 업데이트
        self.userDefaultService.goalEnded()
    }
    
    func scrollToTop(){
        self.goalManageScrollView.setContentOffset(.zero, animated: true)
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
            let dateManager = DateCalculate()
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





