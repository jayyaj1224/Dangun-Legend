//
//  CaveAddViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase


class CaveAddViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var goalUserInput: UITextView!
    
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        
        if let newGoal = goalUserInput.text {
            print("save \(newGoal)")
        }
        
    }
    
}
