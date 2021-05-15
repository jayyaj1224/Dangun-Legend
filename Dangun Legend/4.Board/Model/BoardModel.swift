//
//  BoardModel.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/15.
//

import Foundation

struct AchievementList {
    let achievementList : [Achievement]
}

struct Achievement {
    let title: String
    let goal: String
    let numOfSuccess: Int
    let date: String
    let userID: String
    let goalID: String
}

struct BoardData: Codable {
    let userID: String
    let goalID: String
    let nickName: String
    let startDate : Date
    let endDate: Date
    let description: String
    var numOfSuccess : Int
}
