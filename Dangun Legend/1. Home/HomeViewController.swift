//
//  ViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/02.
//



import UIKit
import Firebase
import Foundation
import RxCocoa
import RxSwift


let defaults = UserDefaults.standard
let db = Firestore.firestore()

class HomeViewController: UIViewController {
    
    private let initialSettingManager = InitialSettingManager()
    private let fireStoreService = FireStoreService()
    
    
    @IBOutlet weak var typoLogoImage: UIImageView!
    @IBOutlet weak var text: UIImageView!
    @IBOutlet weak var caveImage: UIImageView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.checkLoginStatus()
    }
    

    
    @IBAction func logoutPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "InitialVC", sender: self)
        self.initialSettingManager.logOutRemoveDefaults()
        defaults.set(true, forKey: KeyForDf.needToSetViewModel)
        defaults.removeObject(forKey: KeyForDf.nickName)
    }
    
    private func checkLoginStatus() {
        let loggedIn = defaults.bool(forKey: KeyForDf.loginStatus)
        let userID = defaults.string(forKey: KeyForDf.userID)
        
        if loggedIn == true && userID != nil{
            self.welcomeAnimation()
            self.initialSettingManager.checkWhichSetIsNeeded(userID: userID!)
            
        } else {
            performSegue(withIdentifier: "InitialVC", sender: self)
        }
    }
    
    func welcomeAnimation() {
        DispatchQueue.main.async {
            for n in 1...100 {
                Timer.scheduledTimer(withTimeInterval: 0.015*Double(n), repeats: false) { (timer) in
                    self.typoLogoImage.alpha = CGFloat(n)*0.01
                    self.caveImage.alpha = CGFloat(n)*0.01
                    self.text.alpha = CGFloat(n)*0.01
                }
            }
        }
    }
    
//    func printUserDefaultKeys(){
//        for key in UserDefaults.standard.dictionaryRepresentation().keys {
//            if key.localizedStandardContains("Default.Key") {
//
//                print("-->>UserDefaults Keys: \(key)")
//                print("-->>  \(defaults.value(forKey: key))")
//            }}}
//
//
//    func printStatus(){
//        print("-------- userID : \(defaults.string(forKey: KeyForDf.userID))")
//        print("-------- crrGoalExists : \(defaults.string(forKey: KeyForDf.crrGoalExists))")
//        print("-------- goalID : \(defaults.string(forKey: KeyForDf.goalID))")
//        print("-------- failNumber : \(defaults.string(forKey: KeyForDf.failNumber))")
//        print("-------- successNumber : \(defaults.string(forKey: KeyForDf.successNumber))")
//        print("-------- userID : \(defaults.string(forKey: KeyForDf.userID))")
//        print("")
//
//    }

}
