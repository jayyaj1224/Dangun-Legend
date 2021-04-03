//
//  GoogleSignInVC.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//

import UIKit
import GoogleSignIn
import Firebase
import IQKeyboardManagerSwift


class GoogleSignInVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
}

