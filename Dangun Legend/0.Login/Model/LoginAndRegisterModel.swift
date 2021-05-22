//
//  LoginAndRegisterModel.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/16.
//

import Foundation

struct LoginModel {
    let email: String
    let pw: String
}

struct RegisterModel {
    let email: String
    let pwOne: String
    let pwTwo: String
}

enum ValidStatus {
    case valid
    case invalid
    case none
}

