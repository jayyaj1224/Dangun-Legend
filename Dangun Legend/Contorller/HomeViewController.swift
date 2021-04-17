//
//  ViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/02.
//



import UIKit
import Firebase
import Foundation


let defaults = UserDefaults.standard
let db = Firestore.firestore()

class HomeViewController: UIViewController {


    
    @IBOutlet weak var typoLogoImage: UIImageView!
    @IBOutlet weak var text: UIImageView!
    @IBOutlet weak var caveImage: UIImageView!
    
    var goToLoginPage = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typoLogoImage.alpha = 0
        text.alpha = 0
        caveImage.alpha = 0
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
                self.typoLogoImage.alpha = CGFloat(n)*0.01
                self.caveImage.alpha = CGFloat(n)*0.01
                self.text.alpha = CGFloat(n)*0.01
            }
        }
        
        
    }
    
    func printUserDefaultKeys(){
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.localizedStandardContains("Default.Key"){
                print("-->>UserDefaults Keys: \(key)")}}}
    
    
    
    
    @IBOutlet weak var logoutOutlet: UIButton!
    @IBAction func resetDB(_ sender: Any) {
        let userID = defaults.string(forKey: keyForDf.crrUser)!
        db.collection(K.FS_userCurrentGID).document(userID).delete()
        db.collection(K.FS_userCurrentArr).document(userID).delete()
        db.collection(K.FS_userCurrentGoal).document(userID).delete()
        db.collection(K.FS_userIdList).document(userID).delete()
        db.collection(K.FS_userNickName).document(userID).delete()
        db.collection(K.FS_userHistory).document(userID).delete()

        db.collection(K.FS_userGeneral).document(userID).setData([
            fb.GI_generalInfo : [
                fb.GI_totalTrial : 0,
                fb.GI_totalDaysBeenThrough : 0,
                fb.GI_totalSuccess : 0,
                fb.GI_totalAchievement : 0,
                fb.GI_successPerHundred : 0
            ]
        ], merge: true)
        logoutOutlet.sendActions(for: .touchUpInside)
    }
    
    
    
}


