//
//  InitialVC.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//

import UIKit
import Firebase
import GoogleSignIn
import AuthenticationServices
import IQKeyboardManagerSwift
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    private let loginAndRegisterService = LoginAndRegisterService()
    private let loginVM = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var pwTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        self.loginWithEmail()
    }
    
    var appleSIButton: ASAuthorizationAppleIDButton!
    @IBOutlet weak var appleSignInButton: UIStackView!
    @IBAction func appleSignInPressed(_ sender: UIButton) {
        self.appleSIButton.sendActions(for: .touchUpInside)
    }
    
    @IBOutlet var signInButton: GIDSignInButton!
    @IBAction func googleSignInPressed(_ sender: UIButton) {
        signInButton.sendActions(for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.clientID = "1095031001681-4jc92ro7etesrr4inrms1dskmb41q9f2.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        self.bindingLoginInfo()
        self.setupProviderLoginView()
    }
    
    private func bindingLoginInfo() {
        emailTextfield.rx.text
            .orEmpty
            .bind(to: loginVM.emailTextRelay)
            .disposed(by: disposeBag)
        
        pwTextfield.rx.text
            .orEmpty
            .bind(to: loginVM.pwTextRelay)
            .disposed(by: disposeBag)
        
        loginVM.validConfirmed()
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginVM.validConfirmed()
            .map { $0 ? 1 : 0.5}
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
    }
}
//MARK: - EMAIL SIGNIN
extension LoginViewController {
    
    func loginWithEmail(){
        let info = LoginModel(email: loginVM.emailTextRelay.value, pw: loginVM.pwTextRelay.value)
        Auth.auth().signIn(withEmail: info.email, password: info.pw) { authResult, error in
            if let e = error {
                self.loginErrorOcurred()
                print("error-->>>\(e.localizedDescription)")
            } else {
                defaults.set(true, forKey: keyForDf.loginStatus)
                defaults.set(info.email, forKey: keyForDf.crrUser)
                self.loginAndRegisterService.checkWhichSetIsNeeded(userID: info.email)
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func loginErrorOcurred(){
        let loginErrorAlert = UIAlertController.init(title: "로그인 오류", message: "아이디와 비밀번호를 확인해주세요.", preferredStyle: .alert)
        loginErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(loginErrorAlert, animated: true, completion: nil)
    }
    
}

//MARK: - GOOGLE SIGNIN
extension LoginViewController {
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let userID = String(user.userID)
            defaults.set(true, forKey: keyForDf.loginStatus)
            defaults.set(userID, forKey: keyForDf.crrUser)
            self.loginAndRegisterService.checkWhichSetIsNeeded(userID: userID)
            presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            dismiss(animated: true, completion: nil)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
}


//MARK: - APPLE SIGNIN

extension LoginViewController: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userID = appleIDCredential.user
            defaults.set(true, forKey: keyForDf.loginStatus)
            defaults.set(userID, forKey: keyForDf.crrUser)
            self.loginAndRegisterService.checkWhichSetIsNeeded(userID: userID)
            presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }

}

extension LoginViewController {

    func setupProviderLoginView() {
        self.appleSIButton = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
        self.appleSIButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        appleSignInButton.addArrangedSubview(self.appleSIButton)
    }
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    

}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension UIViewController {
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController {
            loginViewController.modalPresentationStyle = .formSheet
            loginViewController.isModalInPresentation = true
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
}
