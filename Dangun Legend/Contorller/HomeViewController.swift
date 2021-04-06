//
//  ViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/02.
//

import UIKit
import Firebase


let defaults = UserDefaults.standard

class HomeViewController: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImage.alpha = 0
        firstLaunch()
        //defaults.set(false, forKey: "goalExisitence")
        print("-->>>HomeViewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("-->> Login Status: \(defaults.bool(forKey: K.loginStatus))")
        if defaults.bool(forKey: K.loginStatus) == false {
            performSegue(withIdentifier: "InitialVC", sender: self)
        } else {
            welcome()
        }
        
    }

    @IBAction func logoutPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "InitialVC", sender: self)
        defaults.set(false, forKey: K.loginStatus)
    }
    
    func welcome() {
        for n in 1...100 {
            Timer.scheduledTimer(withTimeInterval: 0.015*Double(n), repeats: false) { (timer) in
                self.mainImage.alpha = CGFloat(n)*0.01
            }
        }
        
        
    }
    
    func firstLaunch() {
        if defaults.bool(forKey: "usedBefore?") == false {
            defaults.set(true, forKey: "usedBefore?")
            defaults.set(false, forKey: "goalExisitence")
            // show how to use
            // currentGoal, currentArray -> Dummy Item Set
        }
    }
    


}

