//
//  CaveViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//



import UIKit
import Firebase

let checkTheDateNoti : Notification.Name = Notification.Name("CheckTheDateNotification")
let failedNoti: Notification.Name = Notification.Name("failedNotification")

class CaveViewController: UIViewController {
    
    let dateManager = DateManager()
    var caveGoalAddVC = CaveAddViewController()
    var goalManager = GoalManager()
    var currentGoal : GoalStruct?
    var currentDaysArray : [SingleDayInfo]?
    @IBOutlet weak var collectionVw: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CaveAddViewController.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkAlert(_:)), name: checkTheDateNoti, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goalFailed(_:)), name: failedNoti, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateDescription()  // currentGoal currentArray Update
        updateCollectionView()
        checkTodayButtonUIChange()
        collectionVw.reloadData()
        showGoalManageScrollView(defaults.bool(forKey: keyForDf.goalExistence))
    }
    
    
    

    @IBOutlet var caveView: UIView!
    @IBOutlet weak var startYour100DaysView: UIView!
    @IBOutlet weak var goalManageScrollView: UIScrollView!
    
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var squareCollectionView: UICollectionView!
    
    @IBOutlet weak var desFirstLine: UILabel!
    @IBOutlet weak var desSecondLine: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    
    
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
        let asking = todayAskString()
        let dayToDay = Calendar.current.dateComponents([.day], from: start, to: Date()).day! as Int
        let dayNum = dayToDay + 1

        let checkTodayAlert = UIAlertController.init(title: "오늘하루 어떠셨나요 :)", message: asking, preferredStyle: .actionSheet)
        checkTodayAlert.addAction(UIAlertAction(title: "실패", style: .default, handler: {
            (UIAlertAction) in
            self.checkToday(successed: false, dayNum: dayNum)
        }))
        
        checkTodayAlert.addAction(UIAlertAction(title: "성공", style: .destructive, handler: { (UIAlertAction) in
            self.checkToday(successed: true, dayNum: dayNum)
        }))
        
        present(checkTodayAlert, animated: true, completion: nil)
        let now = dateManager.dateFormat(type: "M월d일", date: Date())
        let date = dateManager.dateFormat(type: "e", date: Date())
        defaults.set(now, forKey: keyForDf.pressedMoment)
        checkToday.isEnabled = false
        checkToday.setTitle("\(now) \(date) 확인 완료", for: .normal)
    }
    
    @objc func checkAlert(_ noti: Notification) {
        let checkTheDayPressed = UIAlertController.init(title: "미확인 날짜 체크", message: "이날 목표는 성공하셨나요?", preferredStyle: .alert)
        
        checkTheDayPressed.addAction(UIAlertAction(title: "실패", style: .default, handler: { (UIAlertAction) in
            if let dayNumber = noti.userInfo?[K.cellDayNum] as? Int {
                self.checkToday(successed: false, dayNum: dayNumber)
            }}))
        
        checkTheDayPressed.addAction(UIAlertAction(title: "성공", style: .destructive, handler: { (UIAlertAction) in
            if let dayNumber = noti.userInfo?[K.cellDayNum] as? Int {
                self.checkToday(successed: true, dayNum: dayNumber)
            }}))
        
        present(checkTheDayPressed, animated: true, completion: nil)
    }
    
    @objc func goalFailed(_ noti: Notification) {
        let failedAlert = UIAlertController.init(title: "목표달성 실패", message: "허용가능한 불이행 횟수를 초과하여 목표달성에 실패하였습니다.", preferredStyle: .alert)
        failedAlert.addAction(UIAlertAction(title: "확인", style: . destructive, handler: { (UIAlertAction) in
            defaults.set(false, forKey: keyForDf.goalExistence)
            self.goalManager.quitTheGoal()
            self.showGoalManageScrollView(false)
        }))
        present(failedAlert, animated: true, completion: nil)
    }
    
    
    func checkToday(successed: Bool, dayNum: Int){
        let numOfsuccess = defaults.integer(forKey: keyForDf.crrNumOfSucc)
        let numOfFail = defaults.integer(forKey: keyForDf.crrNumOfFail)
        let decoder = JSONDecoder()
        let coded = defaults.data(forKey: keyForDf.crrGoal)!
        if let goal = try? decoder.decode(GoalStruct.self, from: coded){
            let today = dateManager.dateFormat(type: "yyyyMMdd", date: Date())
            let lastDay = dateManager.dateFormat(type: "yyyyMMdd", date: goal.endDate)
            
            if numOfsuccess+numOfFail == 99 {
                ///Goal끝나는 경우
                goalManager.lastDayControl(successed: successed, goal: goal)
                performSegue(withIdentifier: "acc", sender: self)
            } else {
                ArrayLocalAndDBupdate(bool: successed, dayNum: dayNum)
                successed ? goalManager.successCount() : goalManager.failCount()
                
                if today == lastDay {
                    let alert = UIAlertController.init(title: "미확인 날짜 존재", message: "아직 확인하지 못한 날짜를 체크해주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                    present(alert, animated: true, completion: nil)
                }
                
            }
        }
        
    }
    
    
    
    func ArrayLocalAndDBupdate(bool: Bool,dayNum: Int){
        ///numOfSuccess, numOfFail db update
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        if var theArray = currentDaysArray {
            let index = dayNum - 1
            theArray[index].success = bool
            theArray[index].userChecked = true
            self.currentDaysArray = theArray
            DispatchQueue.main.async {
                self.squareCollectionView.reloadData()
                self.updateDescription()
            }
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(theArray) {
                defaults.set(encoded, forKey: keyForDf.crrDaysArray)
            }
        }
        
        ///currentGoal Array 에 저장
        db.collection(K.FS_userCurrentArr).document(userID).setData(
            ["day \(dayNum)": [
                sd.success: bool,
                sd.userChecked: true
            ]], merge: true)
    }
    

    func updateCollectionView() {
        let decoder = JSONDecoder()
        if let savedData = defaults.data(forKey: keyForDf.crrDaysArray) as Data?
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
        if let savedData = defaults.object(forKey: keyForDf.crrGoal) as? Data {
            let numOfSuccess = defaults.integer(forKey: keyForDf.crrNumOfSucc)
            let numOfFail = defaults.integer(forKey: keyForDf.crrNumOfFail)
            let decoder = JSONDecoder()
            if let data = try? decoder.decode(GoalStruct.self, from: savedData) {
                self.currentGoal = data
                let leftChance = data.failAllowance - numOfFail
                let daysPast = Calendar.current.dateComponents([.day], from: data.startDate, to: Date()).day! as Int
                let start = dateManager.dateFormat(type: "yyyy년M월d일", date: data.startDate)
                let end = dateManager.dateFormat(type: "yyyy년M월d일", date: data.endDate)
                let failAllowed = data.failAllowance
                DispatchQueue.main.async {
                    self.desFirstLine.text = "실행 성공: \(numOfSuccess)일   / 실패: \(numOfFail)일"
                    self.resetWarningText(leftChance:leftChance, chance: failAllowed)
                    print(leftChance)
                    self.daysLeftLabel.text = "\(100-daysPast-1)일"
                    self.goalDescriptionLabel.text = data.description
                    self.dateLabel.text = "기간: \(start) - \(end)"                    
                }
            }
        }
    }
    
    
    func resetWarningText(leftChance:Int, chance: Int){
        if leftChance == 0 {
            let warning = "한번 더 목표 불이행 시 목표는 리셋됩니다."
            desSecondLine.text = warning
            desSecondLine.textColor = .systemRed
        } else {
            let warning = "잔여 실패허용 횟수: \(leftChance)/\(chance)번"
            desSecondLine.text = warning
            desSecondLine.textColor = .black
        }
    }
    
}




extension CaveViewController: GoalUIManagerDelegate {
    
    func newGoalAddedUpdateView(_ data: GoalStruct) {
        showGoalManageScrollView(true)
        let array = goalManager.daysArray(newGoal: data)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(array) {
            defaults.set(encoded, forKey: keyForDf.crrDaysArray)
        } else {
            print("--->>> encode failed: \(keyForDf.crrDaysArray)")
        }
        updateDescription()
        updateCollectionView()
    }
    
    func didFailwithError(error: Error) {
        print("")
    }
    


}


extension CaveViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 0
        
        let textAreaHeight: CGFloat = 0

        let width: CGFloat = (collectionView.bounds.width - itemSpacing)/10
        let height: CGFloat = width * 1 + textAreaHeight

        return CGSize(width: width, height: height)
    }
    

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
        let today = dateManager.dateFormat(type: "yyyyMMdd", date: Date())
        
        if info.date > today {
            squareImage.image = #imageLiteral(resourceName: "EmptySquare")
            buttonOutlet.isEnabled = false
            
            todayLabel.alpha = 1
            todayLabel.text = String(info.dayNum)
            todayLabel.textColor = .systemGray5
            
        } else if info.date < today {
            if info.userChecked {
                todayLabel.alpha = 0
                buttonOutlet.isEnabled = false
                squareImage.image = info.success ? #imageLiteral(resourceName: "SuccessSquare") : #imageLiteral(resourceName: "FailSquare")
                
            } else {
                squareImage.image = #imageLiteral(resourceName: "WarningSquare")
                buttonOutlet.isEnabled = true
                todayLabel.alpha = 0
            }
        } else {
            todayLabel.alpha = 1
            todayLabel.text = "오늘"
            todayLabel.textColor = .black
            if info.userChecked {
                squareImage.image = info.success ? #imageLiteral(resourceName: "todaySuccess") : #imageLiteral(resourceName: "todaySuccess")
            } else {
                squareImage.image = #imageLiteral(resourceName: "todayEmpty")
            }
        }
        
        
    }
}
    

extension CaveViewController {
    
    @IBAction func quitPressed(_ sender: UIButton) {
        let alertQuitPressed = UIAlertController.init(title: "그만두기", message: "진행중인 목표를 중단합니다.", preferredStyle: .alert)
        alertQuitPressed.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        alertQuitPressed.addAction(UIAlertAction(title: "그만두기", style: .destructive, handler: { (UIAlertAction) in
            defaults.set(false, forKey: keyForDf.goalExistence)
            self.goalManager.quitTheGoal()
            self.showGoalManageScrollView(false)
        }))
        present(alertQuitPressed, animated: true, completion: nil)
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
        let pressedMoment = defaults.string(forKey: keyForDf.pressedMoment)
        if today == pressedMoment {
            checkToday.isEnabled = false
            checkToday.setTitle("\(today) \(date) 확인 완료", for: .normal)
        } else {
            checkToday.isEnabled = true
            checkToday.setTitle("\(today) \(date) 오늘 체크하기", for: .normal)
        }
    }

    
    
}
