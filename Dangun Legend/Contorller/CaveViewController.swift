//
//  CaveViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//



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
        showGoalManageScrollView(defaults.bool(forKey: keyForDf.goalExistence))
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkAlert(_:)), name: checkTheDateNoti, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateDescription()  // currentGoal currentArray Update
        updateCollectionView()
        
        //printUserdefaults()
        
    }

    @IBOutlet var caveView: UIView!
    @IBOutlet weak var startYour100DaysView: UIView!
    @IBOutlet weak var goalManageScrollView: UIScrollView!
    
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var trialNumLabel: UILabel!
    @IBOutlet weak var squareCollectionView: UICollectionView!
    
    @IBOutlet weak var desFirstLine: UILabel!
    @IBOutlet weak var desSecondLine: UILabel!
    @IBOutlet weak var executePercentageLabel: UILabel!
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
        checkTodayAlert.addAction(UIAlertAction(title: "실패", style: .default, handler: { (UIAlertAction) in
            self.userCheckSuccess(bool: false, dayNum: dayNum)
            self.goalManager.failCount()
        }))
        
        checkTodayAlert.addAction(UIAlertAction(title: "성공", style: .destructive, handler: { (UIAlertAction) in
            self.userCheckSuccess(bool: true, dayNum: dayNum)
            self.goalManager.successCount()
        }))
        
        present(checkTodayAlert, animated: true, completion: nil)
        checkTodayButtonUIChange()
    }
    
    
    @objc func checkAlert(_ noti: Notification) {
        let checkTheDayPressed = UIAlertController.init(title: "미확인 날짜 체크", message: "이날 목표는 성공하셨나요?", preferredStyle: .alert)
        
        checkTheDayPressed.addAction(UIAlertAction(title: "실패", style: .default, handler: { (UIAlertAction) in
            if let dayNumber = noti.userInfo?[K.cellDayNum] as? Int {
                self.userCheckSuccess(bool: false, dayNum: dayNumber)
                self.goalManager.failCount()
            }}))
        
        checkTheDayPressed.addAction(UIAlertAction(title: "성공", style: .destructive, handler: { (UIAlertAction) in
            if let dayNumber = noti.userInfo?[K.cellDayNum] as? Int {
                self.userCheckSuccess(bool: true, dayNum: dayNumber)
                self.goalManager.successCount()
            }}))
        
        present(checkTheDayPressed, animated: true, completion: nil)
    }
    
//    db.collection(K.userData).document(userID).setData([
//        keyForDf.GI_generalInfo : [
//            keyForDf.GI_totalTrial : info.totalTrial,
//            keyForDf.GI_totalAchievement : info.totalAchievement,
//            keyForDf.GI_successPerHundred : info.successPerHundred,
//            keyForDf.GI_usersAbility : info.usersAbility
//        ]
//    ], merge: true)
    
    func userCheckSuccess(bool: Bool,dayNum: Int){
        ///numOfSuccess, numOfFail db update
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
                let executePercent = String(format: "%.1f", Double(numOfSuccess)/Double(daysPast-1)*100)
                let failAllowed = data.failAllowance
                DispatchQueue.main.async {
                    self.desFirstLine.text = "\(numOfSuccess)일 실행 성공  /  \(numOfFail)일 불이행"
                    self.resetWarningText(leftChance:leftChance, chance: failAllowed)
                    print(leftChance)
                    self.executePercentageLabel.text = "\(executePercent)%"
                    self.daysLeftLabel.text = "\(100-daysPast-1)일"
                    self.goalDescriptionLabel.text = data.description
                    self.dateLabel.text = "기간: \(start) - \(end)"
                    self.trialNumLabel.text = "\(data.trialNumber)"
                    
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
            let warning = "잔여 실패허용 횟수: \(leftChance + 1)/\(chance)번"
            desSecondLine.text = warning
            desSecondLine.textColor = .black
        }
    }
    
}

extension CaveViewController: GoalUIManagerDelegate {
    
    func newGoalAddedUpdateView(_ caveAddVC: CaveAddViewController,_ data: GoalStruct) {
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
    
    
//    func printUserdefaults(){
//        let decoder = JSONDecoder()
//        if let savedArray = defaults.data(forKey: K.currentDaysArray) as Data?,
//           let savedGoal = defaults.data(forKey: K.currentGoal) as Data?
//        {
//            if let decodedArrray = try? decoder.decode([SingleDayInfo].self, from: savedArray),
//               let decodedGoal = try? decoder.decode(GoalStruct.self, from: savedGoal){
//                print("--->>> startDate: \(decodedGoal.startDate)")
//                print("--->>> startDate: \(decodedGoal.endDate)")
//                for single in decodedArrray{
//                    print(single)
//                }
//            }
//        }
//    }

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
        let cellsDay = dateManager.dateFormat(type: "yyyyMMdd", date: info.date)
        
        
        if cellsDay > today {
            squareImage.image = #imageLiteral(resourceName: "EmptySquare")
            buttonOutlet.isEnabled = false
            
            todayLabel.alpha = 1
            todayLabel.text = String(info.dayNum)
            todayLabel.textColor = .systemGray5
            
        } else if cellsDay < today {
            if info.userChecked {
                todayLabel.alpha = 0
                buttonOutlet.isEnabled = false
                if info.success {
                    squareImage.image = #imageLiteral(resourceName: "SuccessSquare")
                } else {
                    squareImage.image = #imageLiteral(resourceName: "FailSquare")
                }
                
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
                if info.success {
                    squareImage.image = #imageLiteral(resourceName: "todaySuccess")
                } else {
                    squareImage.image = #imageLiteral(resourceName: "todayFail")
                }
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
            self.goalManager.resetCurrent()
            self.showGoalManageScrollView(false)
        }))
        present(alertQuitPressed, animated: true, completion: nil)
    }
    
    
    @IBAction func resetPressed(_ sender: UIButton) {
        ///trial Number Update
        let trialNum = Int(trialNumLabel.text!) ?? 1
        let tryOneMore = trialNum + 1
        let alertResetPressed = UIAlertController.init(title: "Reset", message: "진행중인 목표를 \(tryOneMore)회차로 다시 시작합니다.", preferredStyle: .alert)
        
        alertResetPressed.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        
        alertResetPressed.addAction(UIAlertAction(title: "다시시작", style: .destructive, handler: { [self] (UIAlertAction) in
            updateDescription()
            updateCollectionView()
            self.goalManager.resetCurrent()
            DispatchQueue.main.async {
                self.trialNumLabel.text = "\(tryOneMore)"
            }}))
        
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
