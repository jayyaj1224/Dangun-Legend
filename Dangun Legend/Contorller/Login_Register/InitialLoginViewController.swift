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

class InitialLoginViewController: UIViewController, GIDSignInDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.clientID = "1095031001681-4jc92ro7etesrr4inrms1dskmb41q9f2.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var pwTextfield: UITextField!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = pwTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    defaults.set(email, forKey: K.currentUser)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    

    @IBOutlet var signInButton: GIDSignInButton!
    
    @IBAction func googleSignInPressed(_ sender: UIButton) {
        signInButton.sendActions(for: .touchUpInside)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let userID = String(user.userID)
            defaults.set(userID, forKey: K.currentUser)
            presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            dismiss(animated: true, completion: nil)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
}
