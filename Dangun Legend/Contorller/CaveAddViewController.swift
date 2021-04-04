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

class CaveAddViewController: UIViewController {
    

    
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
    
    @IBAction func startPressed(_ sender: UIButton) {
        
        if let newGoalDescription = goalUserInput.text,
           let userID = defaults.value(forKey: K.currentUser) as? String {
            defaults.set(newGoalDescription, forKey: "currentGoal")
            db.collection(K.goals).document(userID).setData([
                "userID": userID,
                "date": startDate.text!,
                "currentStatus": true,
                "trialNumber": "1",
                "description": newGoalDescription
            ])
            {(error) in
                if let e = error {
                    print("There was an issue saving user's info: \(e)")
                } else {
                    print("New goal saved successfully")
                }
                
                
            }
        }
        dismiss(animated: true, completion: nil)
        
    }
    
}
