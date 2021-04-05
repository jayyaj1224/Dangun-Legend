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


protocol goalUIManagerDelegate {
    func updateView(_ newGoal: NewGoal)
    func errorOccurred()
}

class CaveAddViewController: UIViewController {
    
    var delegate : goalUIManagerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(db)
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

    @IBOutlet weak var goalUserInput: UITextView!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //처음 저장
    @IBAction func startPressed(_ sender: UIButton) {
        
        if let description = goalUserInput.text,
           let userID = defaults.value(forKey: K.currentUser) as? String,
           let goalIndex = defaults.value(forKey: "goalIndex") as? Int          
        {
            let goalID = "\(userID)-\(goalIndex+1)"
            let newGoal = NewGoal(userID: userID, goalID: goalID, trialNumber: 1, description: description, startDate: startDate.text!)
            //로컬에 저장
//            defaults.set(newGoal, forKey: "currentRunning")
            defaults.set(true, forKey: "goalExisitence")
            db.collection(K.goals).document(userID).setData([
                "userID": userID,
                "goalID": goalID,
                "startDate": startDate.text!,
                "trialNumber": 1
            ])
            {(error) in
                if let e = error {
                    print("There was an issue saving user's info: \(e)")
                } else {
                    print("New goal saved successfully")
                }}
            //delegate.updateView(newGoal)
            dismiss(animated: true, completion: nil)
        }
    }
    
}
