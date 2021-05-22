//
//  RegisterEmailVC.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    
    private let loginAndRegisterService = LoginAndRegisterService()
    private let registerVM = RegisterViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordOne: UITextField!
    @IBOutlet weak var passwordTwo: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var pwConfirmed: UILabel!

    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindingRegisterInfo()
    }

    private func bindingRegisterInfo() {
        
        emailInput.rx.text
            .orEmpty
            .bind(to: registerVM.emailTextRelay)
            .disposed(by: disposeBag)
        
        passwordOne.rx.text
            .orEmpty
            .bind(to: registerVM.pwOneTextRelay)
            .disposed(by: disposeBag)
        
        passwordTwo.rx.text
            .orEmpty
            .bind(to: registerVM.pwTwoTextRelay)
            .disposed(by: disposeBag)
        
        registerVM.registerReday()
            .map { $0 ? 1 : 0.5}
            .bind(to: registerButton.rx.alpha)
            .disposed(by: disposeBag)
        
        registerVM.registerReday()
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        registerVM.pwConfirmed()
            .bind(onNext: { status in
                self.pwConfirmLabelControl(status)
            })
            .disposed(by: disposeBag)
    }
    
    func pwConfirmLabelControl(_ status: ValidStatus) {
        switch status {
        case ValidStatus.valid:
            self.pwConfirmed.text = "Valid"
            self.pwConfirmed.textColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        case ValidStatus.invalid:
            self.pwConfirmed.text = "Invalid"
            self.pwConfirmed.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case ValidStatus.none:
            self.pwConfirmed.text = "Valid"
            self.pwConfirmed.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
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
                    self.loginAndRegisterService.setDefaultValues(userID: email)
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func loginErrorOcurred(){
        let loginErrorAlert = UIAlertController.init(title: "아이디와 비밀번호를 확인해주세요.", message: nil, preferredStyle: .alert)
        loginErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(loginErrorAlert, animated: true, completion: nil)
    }

}



