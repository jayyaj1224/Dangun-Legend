//
//  CaveAddViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase

let db = Firestore.firestore()

protocol GoalUIManagerDelegate : class {
    func newGoalAddedUpdateView(_ caveAddVC: CaveAddViewController,_ data: GoalStruct)
    func didFailwithError(error: Error)
}


class CaveAddViewController: UIViewController{

    let dateManager = DateManager()
    
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
        let now = Calendar.current.dateComponents(in:.current, from: Date())
        let todaysDate = DateComponents(year: now.year, month: now.month, day: now.day!)
        let lastDay = DateComponents(year: now.year, month: now.month, day: now.day!+(99))
        
        let encoder = JSONEncoder()
        if let description = goalTextView.text,
           let userID = defaults.value(forKey: K.currentUser) as? String
        {
            let dateForDB = dateManager.dateFormat(type: "yyMMddHHmmss", date: Date())
            
            let usersFailAllowInput = failAllowOutput.selectedSegmentIndex
            let newGoal = GoalStruct(userID: userID, goalID: dateForDB, executedDays: 0, trialNumber: 1, description: description, startDate: todaysDate, endDate: lastDay, failAllowance: usersFailAllowInput, numOfDays: 100, completed: false, success: false)
            if let encoded = try? encoder.encode(newGoal) {
                defaults.set(encoded, forKey: K.currentGoal)
            } else {
                print("--->>> encode failed \(K.currentGoal)")
            }
            defaults.set(true, forKey: K.goalExistence)
            
            
            //서버에 저장
            db.collection(K.History).document(userID).setData([
                dateForDB : [
                    G.goalID : dateForDB,
                    G.completed : false,
                    G.success: false,
                    G.description : description,
                    G.userID: userID,
                    G.trialNumber : 1,
                    G.failAllowance : usersFailAllowInput,
                    G.startDate: Date(),
                    G.endDate: lastDay,
                    G.numOfDays: 100,
                    G.executedDays: 0
                ]
            ], merge: true)
            {(error) in
                if let e = error {
                    print("There was an issue saving user's info: \(e)")
                } else {
                    print("New goal saved successfully")
                }}
            CaveAddViewController.delegate?.newGoalAddedUpdateView(self,newGoal)
            NotificationCenter.default.post(name: goalAddNotifyHistoryViewNoti, object: nil, userInfo: nil)
            dismiss(animated: true, completion: nil)
        }
    }
 
    
    func getDate(){
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
