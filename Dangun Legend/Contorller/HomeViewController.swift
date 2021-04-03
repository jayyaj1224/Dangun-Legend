//
//  ViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/02.
//

import UIKit

let defaults = UserDefaults.standard

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print(defaults.bool(forKey: K.loginStatus))
        if defaults.bool(forKey: K.loginStatus) == false {
            performSegue(withIdentifier: "InitialVC", sender: self)
        }
    }

    @IBAction func logoutPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "InitialVC", sender: self)
        defaults.set(false, forKey: K.loginStatus)
    }
    
}

