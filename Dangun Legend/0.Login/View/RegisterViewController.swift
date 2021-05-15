//
//  RegisterEmailVC.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase

class RegisterViewController: UIViewController {
    
    let InitialVC = LoginViewController()
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordOne: UITextField!
    @IBOutlet weak var passwordTwo: UITextField!
    @IBOutlet weak var pwConfirmed: UILabel!

    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pw1Edit(_ sender: UITextField) {

        let pw1 = passwordOne.text
        let pw2 = passwordTwo.text
        if pw1 == pw2 {
            pwConfirmed.text = "일치"
            pwConfirmed.textColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        } else {
            pwConfirmed.text = "불일치"
            pwConfirmed.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }

    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailInput.text, let password = passwordOne.text {
            print("--->>>\(email)-->>>\(password)")
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let e = error {
                    print(e.localizedDescription)
                    self.loginErrorOcurred()
                } else {
                    ///Defaults Clear하기
                    self.InitialVC.setDefaultValues(userID: email)
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func loginErrorOcurred(){
        let loginErrorAlert = UIAlertController.init(title: "아이디와 비밀번호를 확인해주세요.", message: nil, preferredStyle: .alert)
        loginErrorAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        present(loginErrorAlert, animated: true, completion: nil)
    }

}



