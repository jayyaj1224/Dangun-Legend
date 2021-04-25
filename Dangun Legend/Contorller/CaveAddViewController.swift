//
//  CaveAddViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase


protocol GoalUIManagerDelegate : class {
    func newGoalAddedUpdateView(_ data: GoalStruct)
    func didFailwithError(error: Error)
}

class CaveAddViewController: UIViewController{

    let DangunQueue = DispatchQueue(label: "DG")
    let dateManager = DateManager()
    let goalManager = GoalManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalTextView.delegate = self
        getDate()
    }

    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    @IBOutlet weak var failAllowOutput: UISegmentedControl!
  
    
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    static var delegate : GoalUIManagerDelegate?
    
    //처음 저장
    @IBAction func startPressed(_ sender: UIButton) {
        if goalTextView.text != "" && goalTextView.text != "도전하고 싶은 목표를 적어주세요." {
            saveGoal()
        } else {
            let alert = UIAlertController.init(title: "목표 미입력", message: "목표를 입력해주세요 :-)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func saveGoal(){
        let startDate = Date()
        let lastDate = Calendar.current.date(byAdding: .day, value: 99, to: startDate)!
        let encoder = JSONEncoder()
        
        if let description = goalTextView.text,
           let userID = defaults.value(forKey: keyForDf.crrUser) as? String
        {
            let startDateForDB = dateManager.dateFormat(type: "yearToSeconds", date: startDate)
            let lastDateForDB = dateManager.dateFormat(type: "yearToSeconds", date: lastDate)
            
            let usersFailAllowInput = failAllowOutput.selectedSegmentIndex
            let newGoal = GoalStruct(userID: userID, goalID: startDateForDB, startDate: startDate, endDate: lastDate, failAllowance: usersFailAllowInput, description: description, numOfDays: 100, completed: false, goalAchieved: false, numOfSuccess: 0, numOfFail: 0, shared: false)
            
            if let encoded = try? encoder.encode(newGoal) {
                defaults.set(encoded, forKey: keyForDf.crrGoal)
            } else {
                print("--->>> encode failed \(keyForDf.crrGoal)")
            }
            
            defaults.set(true, forKey: keyForDf.goalExistence)
            defaults.set(startDateForDB, forKey: keyForDf.crrGoalID)
            defaults.set(0, forKey: keyForDf.crrNumOfSucc)
            defaults.set(0, forKey: keyForDf.crrNumOfFail)
            defaults.set(usersFailAllowInput, forKey: keyForDf.crrFailAllowance)
            
            db.collection(K.FS_userCurrentGID).document(userID).setData([G.currentGoal: startDateForDB], merge: true)
            
            db.collection(K.FS_userCurrentGoal).document(userID).setData([
                startDateForDB : [
                    G.userID: userID,
                    G.goalID : startDateForDB,
                    G.startDate: startDateForDB,
                    G.endDate: lastDateForDB,
                    G.failAllowance : usersFailAllowInput,
                    G.description : description,
                    G.numOfDays: 100,
                    G.completed : false,
                    G.goalAchieved: false,
                    G.numOfSuccess: 76,
                    G.numOfFail: 0,
                    G.shared: false
                ]
            ], merge: true)
            {(error) in
                if let e = error {
                    print("There was an issue saving user's info: \(e)")
                } else {
                    print("New goal saved successfully")
                }}
        
            CaveAddViewController.delegate?.newGoalAddedUpdateView(newGoal)

            goalManager.loadGeneralInfo(forDelegate: false) { (UsersGeneralInfo) in
                let update = UsersGeneralInfo.totalTrial + 1
                db.collection(K.FS_userGeneral).document(userID).setData([
                    fb.GI_generalInfo : [
                        fb.GI_totalTrial : update
                    ]
                ], merge: true)
            }
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    func getDate() {
        let hundredInterval = DateInterval(start: Date(), duration: 86400*99)
        let lastDay = hundredInterval.end
        let startDate = dateManager.dateFormat(type: "yyyy-MM-dd", date: Date())
        let endDate = dateManager.dateFormat(type: "yyyy-MM-dd", date: lastDay)
        DispatchQueue.main.async {
            self.startDate.text = startDate
            self.endDate.text = endDate
        }
    }
}

extension CaveAddViewController: UITextViewDelegate {
    
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "도전하고 싶은 목표를 적어주세요."
            textView.textColor = UIColor.systemGray
        }
    }
    
}

