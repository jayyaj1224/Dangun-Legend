//
//  CaveViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//
/*
 
 Cave View에서
 
 진행중인 Project가 있는지?     Yes -> 진행중인 프로젝트 화면
                            No -> 시작하기Button        -> AddVC
 
 
 서버에는: 현재 진행중인 목표 / 성공한 목표 2가지 -> 아이디헤더로 저장
 로컬에는: 현재 진행중인 목표만 저장
 
 
 [ToDoList]
 - 히스토리: 모든 Goal생성 기록 TableView
 - 보드: 성공한 Goal 표시
 - 성공한 셀에 DayNum 표시
 */


import UIKit
import Firebase

let checkTheDateNoti : Notification.Name = Notification.Name("CheckTheDateNotification")
let colorNoti: Notification.Name = Notification.Name("colorNotification")

class CaveViewController: UIViewController {
    
    let dateManager = DateManager()
    var caveGoalAddVC = CaveAddViewController()
    var goalManager = GoalManager()
    var currentGoal : GoalStruct?
    var currentDaysArray : [SingleDayInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CaveAddViewController.delegate = self
        checkTodayButtonUIChange()
        showGoalManageScrollView(defaults.bool(forKey: K.goalExistence))
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkAlert(_:)), name: checkTheDateNoti, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateDescription()  // currentGoal currentArray Update
        updateCollectionView()
    }

    @IBOutlet var caveView: UIView!
    @IBOutlet weak var startYour100DaysView: UIView!
    @IBOutlet weak var goalManageScrollView: UIScrollView!
    
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var failAllowanceLabel: UILabel!
    @IBOutlet weak var trialNumLabel: UILabel!
    @IBOutlet weak var squareCollectionView: UICollectionView!
    
    @IBOutlet weak var checkToday: UIButton!
    
    
    func showGoalManageScrollView(_ bool: Bool) {
        if bool {
            startYour100DaysView.isHidden = true
            goalManageScrollView.isHidden = false
        } else {
            startYour100DaysView.isHidden = false
            goalManageScrollView.isHidden = true
        }
    }

    
    @IBAction func checkTodayPressed(_ sender: UIButton) {
        let start = currentGoal!.startDate
        let 기준일 = DateComponents(year: start.year, month: start.month, day: start.day!+(7))///<---추후삭제
        let 기준일Date = Calendar.current.date(from: 기준일)!
        
        let asking = todayAskString()
        let startDate = Calendar.current.date(from: currentGoal!.startDate)!
        let dayToDay = Calendar.current.dateComponents([.day], from: startDate, to: 기준일Date).day! as Int
        let dayNum = dayToDay + 1
        print("--->>> \(dayNum)")

        let checkTodayAlert = UIAlertController.init(title: "오늘하루 어떠셨나요 :)", message: asking, preferredStyle: .alert)
        checkTodayAlert.addAction(UIAlertAction(title: "실패", style: .default, handler: { (UIAlertAction) in
            self.userCheckSuccess(bool: false, dayNum: dayNum)
        }))
        checkTodayAlert.addAction(UIAlertAction(title: "성공", style: .destructive, handler: { (UIAlertAction) in
            self.userCheckSuccess(bool: true, dayNum: dayNum)
        }))
        present(checkTodayAlert, animated: true, completion: nil)
        checkTodayButtonUIChange()
    }
    
    
    @objc func checkAlert(_ noti: Notification) {
        let checkTheDayPressed = UIAlertController.init(title: "미확인 날짜 체크", message: "이날 목표는 성공하셨나요?", preferredStyle: .alert)
        
        checkTheDayPressed.addAction(UIAlertAction(title: "실패", style: .default, handler: { (UIAlertAction) in
            if let dayNumber = noti.userInfo?[K.cellDayNum] as? Int {
                self.userCheckSuccess(bool: false, dayNum: dayNumber)
            }
        }))
        checkTheDayPressed.addAction(UIAlertAction(title: "성공", style: .destructive, handler: { (UIAlertAction) in
            if let dayNumber = noti.userInfo?[K.cellDayNum] as? Int {
                self.userCheckSuccess(bool: true, dayNum: dayNumber)
            }
        }))
        present(checkTheDayPressed, animated: true, completion: nil)
    }
    
    
    
    func userCheckSuccess(bool: Bool,dayNum: Int){
        // dayNum(index) -> singleDayInfo  updateSquares(info: SingleDayInfo)
        if var theArray = currentDaysArray {
            let index = dayNum - 1
            theArray[index].success = bool
            theArray[index].userChecked = true
            self.currentDaysArray = theArray
            DispatchQueue.main.async {
                self.squareCollectionView.reloadData()
            }
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(theArray) {
                defaults.set(encoded, forKey: K.currentDaysArray)
            }
        }
    }
    
    func updateCollectionView() {
        let decoder = JSONDecoder()
        if let savedData = defaults.data(forKey: K.currentDaysArray) as Data?
        {
            if let decodedArrray = try? decoder.decode([SingleDayInfo].self, from: savedData) {
                self.currentDaysArray = decodedArrray
                DispatchQueue.main.async {
                    self.squareCollectionView.reloadData()
                }
            }
        }
    }
    
    func updateDescription() {
        if let savedData = defaults.object(forKey: K.currentGoal) as? Data {
            let decoder = JSONDecoder()
            if let data = try? decoder.decode(GoalStruct.self, from: savedData) {
                self.currentGoal = data
                let start = dateManager.dateFormat(type: "yyyy년M월d일", dateComponets: data.startDate)
                let end = dateManager.dateFormat(type: "yyyy년M월d일", dateComponets: data.endDate)
                DispatchQueue.main.async {
                    self.goalDescriptionLabel.text = data.description
                    self.dateLabel.text = "기간: \(start) - \(end)"
                    self.failAllowanceLabel.text = "잔여 실패허용횟수: \(data.failAllowance)회 / \(data.failAllowance)회"
                    self.trialNumLabel.text = "\(data.trialNumber)"
                }
            }
        }
    }
    
}

extension CaveViewController: GoalUIManagerDelegate {
    
    func newGoalAddedUpdateView(_ caveAddVC: CaveAddViewController,_ data: GoalStruct) {
        showGoalManageScrollView(true)
        let array = goalManager.daysArray(newGoal: data)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(array) {
            defaults.set(encoded, forKey: K.currentDaysArray)
        } else {
            print("--->>> encode failed: \(K.currentDaysArray)")
        }
        updateDescription()
        updateCollectionView()
    }
    
    func didFailwithError(error: Error) {
        print("")
    }

}



extension CaveViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    ///userDefaults에서 newGoal불러와서 collectionViewupdate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numOfItems = currentDaysArray?.count ?? 100
        return numOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Square", for: indexPath) as? SquareCell
        else {
            return UICollectionViewCell()
        }
        if let singleDayInfo = currentDaysArray?[indexPath.item] {
            cell.updateSquares(info: singleDayInfo)
        }
        return cell
    }



//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    }
}



class SquareCell : UICollectionViewCell {

    var singleDayInfo : SingleDayInfo?
    let dateManager = DateManager()
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var squareImage: UIImageView!
    
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let singleInfo = singleDayInfo {
            let dayNum = ["cellDayNum":singleInfo.dayNum]
            NotificationCenter.default.post(name: checkTheDateNoti, object: nil, userInfo: dayNum)
        }
    }

    func updateSquares(info: SingleDayInfo){
        self.singleDayInfo = info
        let now = Calendar.current.dateComponents(in:.current, from: Date()) //<<--- 추후 삭제
        let 기준일 = DateComponents(year: now.year, month: now.month, day: now.day!+(7))//<<--- 추후 삭제

        let today = dateManager.dateFormat(type: "yyyyMMdd", dateComponets: 기준일)
        let cellsDay = dateManager.dateFormat(type: "yyyyMMdd", dateComponets: info.date)
        
        
        
        if cellsDay > today {
            squareImage.image = #imageLiteral(resourceName: "EmptySquare")
            buttonOutlet.isEnabled = false
        } else if cellsDay < today {
            
            if info.userChecked {
                buttonOutlet.isEnabled = false
                if info.success {
                    squareImage.image = #imageLiteral(resourceName: "SuccessSquare")
                } else {
                    squareImage.image = #imageLiteral(resourceName: "FailSquare")
                }
            } else {
                    squareImage.image = #imageLiteral(resourceName: "WarningSquare")
                    buttonOutlet.isEnabled = true
                
            }
        }
        
        if cellsDay == today {
            todayLabel.alpha = 1
            if info.userChecked {
                if info.success {
                    squareImage.image = #imageLiteral(resourceName: "todaySuccess")
                } else {
                    squareImage.image = #imageLiteral(resourceName: "todayFail")
                }
            } else {
                squareImage.image = #imageLiteral(resourceName: "todayEmpty")
            }
        } else {
            todayLabel.alpha = 0
        }
        
    }
}
    

extension CaveViewController {
    
    @IBAction func quitPressed(_ sender: UIButton) {
        let alertQuitPressed = UIAlertController.init(title: "그만두기", message: "진행중인 목표를 중단합니다.", preferredStyle: .alert)
        alertQuitPressed.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        alertQuitPressed.addAction(UIAlertAction(title: "그만두기", style: .destructive, handler: { (UIAlertAction) in
            defaults.set(false, forKey: K.goalExistence)
            defaults.removeObject(forKey: K.currentGoal)
            self.showGoalManageScrollView(false)
        }))
        present(alertQuitPressed, animated: true, completion: nil)
    }
    
    
    @IBAction func resetPressed(_ sender: UIButton) {
        let trialNum = Int(trialNumLabel.text!) ?? 1
        let nextTry = trialNum + 1
        let alertResetPressed = UIAlertController.init(title: "Reset", message: "진행중인 목표를 \(nextTry)회차로 다시 시작합니다.", preferredStyle: .alert)
        alertResetPressed.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        alertResetPressed.addAction(UIAlertAction(title: "다시시작", style: .destructive, handler: { [self] (UIAlertAction) in
            updateDescription()
            updateCollectionView()
            DispatchQueue.main.async {
                self.trialNumLabel.text = "\(nextTry)"
            }
        }))
        present(alertResetPressed, animated: true, completion: nil)
    }
    
    
    func todayAskString() -> String {
        let now = Calendar.current.dateComponents(in:.current, from: Date())
        let monthDate = dateManager.dateFormat(type: "M월d일", dateComponets: now)
        let whichDay = dateManager.dateFormat(type: "e", dateComponets: now)
        let asking = "\(monthDate)\(whichDay), 성공하셨나요?"
        return asking
    }
    
    func checkTodayButtonUIChange(){
        let today = dateManager.dateFormat(type: "M월d일", date: Date())
        let date = dateManager.dateFormat(type: "e", date: Date())
        checkToday.setTitle("\(today) \(date) 오늘 체크하기", for: .normal)
        
    }
    
}
