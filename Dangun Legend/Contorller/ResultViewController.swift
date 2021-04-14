//
//  ResultViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/14.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase


class ResultViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDescription()
        hideAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        showResult()
    }
    
    
    @IBOutlet weak var resultBox: UIImageView!
    @IBOutlet weak var firstCongrats: UIImageView!
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var accomplishedLabel: UILabel!
    @IBOutlet weak var howWasItLabel: UILabel!
    
    @IBOutlet weak var ifWeEndureLabel: UILabel!
    @IBOutlet weak var weCanDoItLabel: UILabel!
    @IBOutlet weak var typoLabelImage: UIImageView!
    @IBOutlet weak var caveIlluImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    func showResult(){
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
            for n in 1...50 {
                Timer.scheduledTimer(withTimeInterval: 0.001*Double(n), repeats: false) { (timer) in
                    self.firstCongrats.alpha = CGFloat(n)*0.02
                }
            }
        }///>>>>>>1초
        
        
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { (timer) in
            self.firstCongrats.alpha = 0
        }///>>>>>2.5초
        
        Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { (timer) in
            for n in 1...100 {
                Timer.scheduledTimer(withTimeInterval: 0.01*Double(n), repeats: false) { (timer) in
                    self.goalDescriptionLabel.alpha = CGFloat(n)*0.01
                    self.resultBox.alpha = CGFloat(n)*0.01
                }
            }
        }///->>>>> 3.2 초
        
        Timer.scheduledTimer(withTimeInterval: 8.5, repeats: false) { (timer) in
            for n in 1...100 {
                Timer.scheduledTimer(withTimeInterval: 0.0005*Double(n), repeats: false) { (timer) in
                    self.accomplishedLabel.alpha = CGFloat(n)*0.01
                }
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 10.7, repeats: false) { (timer) in
            for n in 1...100 {
                Timer.scheduledTimer(withTimeInterval: 0.02*Double(n), repeats: false) { (timer) in
                    self.howWasItLabel.alpha = CGFloat(n)*0.01
                }
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 13.7, repeats: false) { (timer) in
            for n in 1...100 {
                Timer.scheduledTimer(withTimeInterval: 0.02*Double(n), repeats: false) { (timer) in
                    self.ifWeEndureLabel.alpha = CGFloat(n)*0.01
                }
            }
        }
        Timer.scheduledTimer(withTimeInterval: 13.0, repeats: false) { (timer) in
            for n in 1...100 {
                Timer.scheduledTimer(withTimeInterval: 0.01*Double(n), repeats: false) { (timer) in
                    self.howWasItLabel.alpha = CGFloat(100-n)*0.01
                }
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 16.5, repeats: false) { (timer) in
            for n in 1...100 {
                Timer.scheduledTimer(withTimeInterval: 0.02*Double(n), repeats: false) { (timer) in
                    self.weCanDoItLabel.alpha = CGFloat(n)*0.01
                }
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 19.5, repeats: false) { (timer) in
            
            self.caveIlluImage.alpha = 1
        }
        
        Timer.scheduledTimer(withTimeInterval: 20.2, repeats: false) { (timer) in
            for n in 1...100 {
                Timer.scheduledTimer(withTimeInterval: 0.02*Double(n), repeats: false) { (timer) in
                    self.typoLabelImage.alpha = CGFloat(n)*0.01
                }
            }
        }
        
        
        Timer.scheduledTimer(withTimeInterval: 21.5, repeats: false) { (timer) in
            self.backButton.alpha = 1
        }
        
        
    }
    
    
    
    func setDescription(){
        let decoder = JSONDecoder()
        if let savedData = defaults.data(forKey: keyForDf.crrGoal) as Data? {
            if let crrGoal = try? decoder.decode(GoalStruct.self, from: savedData) {
                let goalDescription = crrGoal.description
                DispatchQueue.main.async {
                    self.goalDescriptionLabel.text! = goalDescription
                }}}}
    
    
    func hideAll(){
        backButton.alpha = 0
        ifWeEndureLabel.alpha = 0
        firstCongrats.alpha = 0
        goalDescriptionLabel.alpha = 0
        accomplishedLabel.alpha = 0
        howWasItLabel.alpha = 0
        weCanDoItLabel.alpha = 0
        typoLabelImage.alpha = 0
        caveIlluImage.alpha = 0
        resultBox.alpha = 0
    }
    
    
    
    
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}


/*
 
 
 for n in 1...40 {
     Timer.scheduledTimer(withTimeInterval: 0.03*Double(n), repeats: false) { (timer) in
         self.titleLabel.alpha = CGFloat(n)*0.025
     }
 }
 
 Timer.scheduledTimer(withTimeInterval: 1.4, repeats: false) { (timer) in
     for n in 0...10 {
         Timer.scheduledTimer(withTimeInterval: 0.08*Double(n), repeats: false) { (timer) in
             self.titleLabel.alpha = (10.0-CGFloat(n))*0.1
         }
     }
 }
 
 Timer.scheduledTimer(withTimeInterval: 2.3, repeats: false) { (timer) in
     for n in 0...10 {
         Timer.scheduledTimer(withTimeInterval: 0.08*Double(n), repeats: false) { (timer) in
             self.titleLabel2.alpha = CGFloat(n)*0.1
         }
     }
 }
 
 */
