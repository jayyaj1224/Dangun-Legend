//
//  ViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/02.
//
/*
 func printingData(){
     for key in UserDefaults.standard.dictionaryRepresentation().keys {
         var arr : [String] = []
         arr.append(key)
         print("-->>UserDefaults Keys: \(arr)")
     }
 }
 
 
 firstLaunch: true or false
 currentUser: 사용자 ID or NoOne
 
 goalExistence: true or false
 currentGoal: encoded goal data
 currentDaysArray : encoded days Array
 
 
                    <삭제>
                 currentRunning
                 runningGoal
                 loginStatus
                 usedBefore?
                 goalIndex
                 goalExisitence
 */

import UIKit
import Firebase
import Foundation


let defaults = UserDefaults.standard

class HomeViewController: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImage.alpha = 0
        //defaults.set(false, forKey: "goalExisitence")
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("-->> User Logged In: \(defaults.string(forKey: K.currentUser)!)")
        if defaults.string(forKey: K.currentUser) == K.NoOne {
            performSegue(withIdentifier: "InitialVC", sender: self)
        } else {
            welcome()
        }
        
    }

    @IBAction func logoutPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "InitialVC", sender: self)
        defaults.set(K.NoOne, forKey: K.currentUser)
    }
    
    func welcome() {
        for n in 1...100 {
            Timer.scheduledTimer(withTimeInterval: 0.015*Double(n), repeats: false) { (timer) in
                self.mainImage.alpha = CGFloat(n)*0.01
            }
        }
        
        
    }
    


}

