//
//  ViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/02.
//



import UIKit
import FirebaseFirestore
import Foundation
import RxCocoa
import RxSwift


let defaults = UserDefaults.standard
let db = Firestore.firestore()

class HomeViewController: UIViewController {
    
    private let initialSettingManager = InitialSettingManager()
    private let fireStoreService = FireStoreService()
    
    private var needToSetInitialValue = true
    
    @IBOutlet weak var typoLogoImage: UIImageView!
    @IBOutlet weak var text: UIImageView!
    @IBOutlet weak var caveImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.welcomeAnimationZeroAlpha()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.checkLoginStatus()
    }


    private func checkLoginStatus() {
        let userLoggedIn = defaults.bool(forKey: KeyForDf.loginStatus)
        let userID = defaults.string(forKey: KeyForDf.userID) ?? "none"
        if userLoggedIn == false {
            performSegue(withIdentifier: "InitialVC", sender: self)
            
        } else {
            
            self.welcomeAnimation()
            if needToSetInitialValue {
                self.initialSettingManager.checkWhichSetIsNeeded(userID: userID)
                self.needToSetInitialValue = false
            }
        }
            
    }
    
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        self.needToSetInitialValue = true
        performSegue(withIdentifier: "InitialVC", sender: self)
        self.initialSettingManager.logOutRemoveDefaults()
        defaults.set(true, forKey: KeyForDf.needToSetViewModel)
        defaults.removeObject(forKey: KeyForDf.nickName)
    }
    
    
    func welcomeAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            for n in 1...100 {
                Timer.scheduledTimer(withTimeInterval: 0.015*Double(n), repeats: false) { (timer) in
                    self.typoLogoImage.alpha = CGFloat(n)*0.01
                    self.caveImage.alpha = CGFloat(n)*0.01
                    self.text.alpha = CGFloat(n)*0.01
                }
            }
        }
    }
    
    func welcomeAnimationZeroAlpha(){
        self.typoLogoImage.alpha = 0
        self.caveImage.alpha = 0
        self.text.alpha = 0
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


}
