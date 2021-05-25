//
//  LoginViewModel.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/16.
//

import Foundation
import RxSwift
import RxCocoa


struct LoginViewModel {
    
    let emailTextRelay = BehaviorRelay<String>(value: "")
    let pwTextRelay = BehaviorRelay<String>(value: "")
    
    func validConfirmed() -> Observable<Bool> {
        return Observable.combineLatest(emailTextRelay, pwTextRelay)
            .map { email, password in
                return email.count > 3 && email.contains("@") && email.contains(".") && password.count > 5
            }
    }
    
}


struct RegisterViewModel {
    
    let emailTextRelay = BehaviorRelay<String>(value: "")
    let pwOneTextRelay = BehaviorRelay<String>(value: "")
    let pwTwoTextRelay = BehaviorRelay<String>(value: "")
    
    func registerReday() -> Observable<Bool> {
        return Observable.combineLatest(emailTextRelay, pwOneTextRelay, pwTwoTextRelay)
            .map { email, pwOne, pwTwo in
                return email.count > 3
                    && email.contains("@")
                    && email.contains(".")
                    && pwOne.count > 5
                    && pwOne == pwTwo
            }
    }
    
    func pwConfirmed() -> Observable<ValidStatus> {
        return Observable.combineLatest(pwOneTextRelay, pwTwoTextRelay)
            .map { pwOne, pwTwo in
                if pwOne == pwTwo && pwOne.count > 5{
                    return ValidStatus.valid
                } else if pwTwo.count < 6 { 
                    return ValidStatus.none
                } else {
                    return ValidStatus.invalid
                }
            }
    }
    
}
