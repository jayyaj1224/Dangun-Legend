//
//  Contants.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//

import Foundation

struct K {
    
    

    static let goals = "goals"
    static let loginStatus = "loginStatus"
    static let currentUser = "currentUser"
    static let userID = "userID"
}


struct NewGoal {
    let userID: String
    let goalID: String
    let trialNumber : Int
    
    let description: String

    let startDate : String
}
