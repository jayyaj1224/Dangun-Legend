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
    func newGoalAddedUpdateView(_ caveAddVC: CaveAddViewController,_ data: NewGoal)
    func didFailwithError(error: Error)
}


class CaveAddViewController: UIViewController{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalTextView.delegate = self
        getDate()
        print(type(of: self),#function)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(type(of: self),#function)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print(type(of: self),#function)
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
            let usersFailAllowInput = failAllowOutput.selectedSegmentIndex
            let newGoal = NewGoal(userID: userID, goalID: "\(userID)_\(now)", trialNumber: 1, description: description, startDate: todaysDate, endDate: lastDay, failAllowance: usersFailAllowInput, numOfDays: 100)
            if let encoded = try? encoder.encode(newGoal) {
                defaults.set(encoded, forKey: K.currentGoal)
            }
            defaults.set(true, forKey: K.goalExistence)
            //서버에 저장
            //                db.collection(K.goals).document(userID).setData([
            //                    "userID": userID,
            //                    "goalID": "\(userID)_\(goalIndex+1)",
            //                    "startDate": startDate.text!,
            //                ])
            //                {(error) in
            //                    if let e = error {
            //                        print("There was an issue saving user's info: \(e)")
            //                    } else {
            //                        print("New goal saved successfully")
            //                    }}
            //print("--->>> delegate: \(delegate!)")
            dismiss(animated: true, completion: nil)
            CaveAddViewController.delegate?.newGoalAddedUpdateView(self,newGoal)
        }
    }
 
    
    func getDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        let hundredInterval = DateInterval(start: Date(), duration: 86400*99)
        let lastDay = hundredInterval.end
        let lastDate = formatter.string(from: lastDay)
        
        DispatchQueue.main.async {
            self.startDate.text = today
            self.endDate.text = lastDate
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
