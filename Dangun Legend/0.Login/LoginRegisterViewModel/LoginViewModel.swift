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
