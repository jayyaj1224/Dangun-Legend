//
//  ViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/02.
//

/*
 [ToDoList]

- 로그인 실패 시, Alert설정




 [Memo]
 

 

 
 [User Default Data]
 
 -->>UserDefaults Keys
// -->>> 초기 세팅값:currentUser  crrGoalID  goalExistence  crrFailAllowance  loginStatus
//                  currentGoal   nickName  crrNumOfFail  currentDaysArray  crrNumOfSucc


                    DB              Default
목표 추가 ->       generalInfo
                 goal한개Info       goal한개Info
                 최근GoalArray      최근GoalArray
 
 */

import UIKit
import Firebase
import Foundation


let defaults = UserDefaults.standard
let db = Firestore.firestore()

class HomeViewController: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    var goToLoginPage = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImage.alpha = 0

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if defaults.bool(forKey: keyForDf.loginStatus) == false {
            performSegue(withIdentifier: "InitialVC", sender: self)
            goToLoginPage = false
        } else {
            welcome()
            print("-->> User Logged In: \(defaults.string(forKey: keyForDf.crrUser)!)")
        }
//        printUserDefaultKeys()
    }
    
    // -->>> 초기 세팅값:    goalExistence  crrFailAllowance
    //
    @IBAction func logoutPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "InitialVC", sender: self)
        defaults.set(false, forKey: keyForDf.loginStatus)
        defaults.removeObject(forKey: keyForDf.crrUser)
        defaults.set(K.none, forKey: keyForDf.nickName)
        
        defaults.removeObject(forKey: keyForDf.crrDaysArray)
        defaults.removeObject(forKey: keyForDf.crrGoal)
        defaults.removeObject(forKey: keyForDf.crrGoalID)
        
        defaults.removeObject(forKey: keyForDf.crrNumOfSucc)
        defaults.removeObject(forKey: keyForDf.crrNumOfFail)
        
        defaults.removeObject(forKey: keyForDf.crrFailAllowance)
        defaults.removeObject(forKey: keyForDf.goalExistence)
    }
    
    func welcome() {
        for n in 1...100 {
            Timer.scheduledTimer(withTimeInterval: 0.015*Double(n), repeats: false) { (timer) in
                self.mainImage.alpha = CGFloat(n)*0.01
            }
        }
        
        
    }
    
    func printUserDefaultKeys(){
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.localizedStandardContains("Default.Key"){
                print("-->>UserDefaults Keys: \(key)")}}}
    
    
}


