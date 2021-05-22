//
//  LoginViewModel.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/16.
//

import Foundation
import RxSwift
import RxCocoa

///     * Input
///      - emailTextField: BehaviorRelay
///      - pwTextField: BehaviorRelay
///
///     * Output
///      - emailText 값과 pwText값의 유효성에 따른 결과값: Observable

///         결과에 따라서 Login버튼의 Alpha값과 isEnabled 컨트롤

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
