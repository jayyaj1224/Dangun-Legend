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
    
    private let loginService = LoginAndRegisterService()
    
    @IBOutlet weak var typoLogoImage: UIImageView!
    @IBOutlet weak var text: UIImageView!
    @IBOutlet weak var caveImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.set(true, forKey: KeyForDf.needToSetViewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.checkLoginStatus()
//        print("------------------------------------------------")
//        print("------------------------------------------------")
//        print("loginStatus: \(defaults.bool(forKey: keyForDf.loginStatus))")
//        print("userID: \(String(describing: defaults.string(forKey: keyForDf.crrUser)))")
//        print("crrGoal: \(defaults.bool(forKey: keyForDf.crrGoal))")
//        print("goalExistence: \(defaults.bool(forKey: keyForDf.crrGoalExists))")
//        print("needToSetViewModel: \(defaults.bool(forKey: keyForDf.needToSetViewModel))")
//        print("userNickName: \(String(describing: defaults.string(forKey: keyForDf.nickName)))")
//        print("------------------------------------------------")
//        print("------------------------------------------------")
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "InitialVC", sender: self)
        self.loginService.logOutRemoveDefaults()
        defaults.set(true, forKey: KeyForDf.needToSetViewModel)
        defaults.removeObject(forKey: KeyForDf.nickName)
    }
    
    private func checkLoginStatus() {
        let status = defaults.bool(forKey: KeyForDf.loginStatus)
        print("loginStatus: \(status)")
        if status {
            self.welcomeAnimation()
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
//            if key.localizedStandardContains("Default.Key"){
//                print("-->>UserDefaults Keys: \(key)")}}}

}
