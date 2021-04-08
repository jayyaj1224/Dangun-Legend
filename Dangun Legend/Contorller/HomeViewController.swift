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


let defaults = UserDefaults.standard

class HomeViewController: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImage.alpha = 0
        //defaults.set(false, forKey: "goalExisitence")
        
        let now = Calendar.current.dateComponents(in:.current, from: Date())
        let hundredInterval = DateInterval(start: now, duration: 86400*99)

        
        print("--->>>\(todaysDate)")
        print("--->>>\(lastDay)")
 
    }
    
    /*
     calendar: gregorian (current) timeZone: Asia/Seoul (current) era: 1 year: 2021 month: 4 day: 8 hour: 18 minute: 27 second: 32 nanosecond: 389297962 weekday: 5 weekdayOrdinal: 2 quarter: 0 weekOfMonth: 2 weekOfYear: 15 yearForWeekOfYear: 2021 isLeapMonth: false
     -->> User Logged In: 1048
     */
    
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

