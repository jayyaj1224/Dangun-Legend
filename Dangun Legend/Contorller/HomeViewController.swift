//
//  ViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/02.
//

/*
 [ToDoList]
 
- 히스토리 삭제 기능 추가
- DateManager, CaveAdd 테스트 가정들 전부 삭제

 
 
 
 
 
 [Memo]
 
 func printingData(){
     for key in UserDefaults.standard.dictionaryRepresentation().keys {
         var arr : [String] = []
         arr.append(key)
         print("-->>UserDefaults Keys: \(arr)")
     }
 }
 
 
 
 
 
 [User Default Data]
 
 -->>UserDefaults Keys: ["Default.Key: currentUser"]
 -->>UserDefaults Keys: ["Default.Key: nickName"]
 -->>UserDefaults Keys: ["Default.Key: usedBefore"]
 -->>UserDefaults Keys: ["Default.Key: goalExistence"]

 
 */

import UIKit
import Firebase
import Foundation


let defaults = UserDefaults.standard
let db = Firestore.firestore()

class HomeViewController: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImage.alpha = 0
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if defaults.string(forKey: keyForDf.crrUser) == K.none {
            performSegue(withIdentifier: "InitialVC", sender: self)
        } else {
            welcome()
            print("-->> User Logged In: \(defaults.string(forKey: keyForDf.crrUser)!)")
        }
        
        printUserDefaultKeys()
    }
    



    @IBAction func logoutPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "InitialVC", sender: self)
        defaults.set(K.none, forKey: keyForDf.crrUser)
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
            var arr : [String] = []
            arr.append(key)
            print("-->>UserDefaults Keys: \(arr)")
        }

    }
    


}

