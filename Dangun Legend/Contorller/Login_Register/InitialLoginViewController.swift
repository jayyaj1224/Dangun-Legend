//
//  InitialVC.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//

import UIKit
import Firebase
import GoogleSignIn
import IQKeyboardManagerSwift

class InitialLoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleSignIn.GIDSignIn.sharedInstance()?.presentingViewController = self
        GoogleSignIn.GIDSignIn.sharedInstance().signIn()
    }
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var pwTextfield: UITextField!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = pwTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    self.dismiss(animated: true, completion: nil)
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                   
                }
            }
        }
        defaults.set(true, forKey: K.loginStatus)
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    

    
    
    
    
}
