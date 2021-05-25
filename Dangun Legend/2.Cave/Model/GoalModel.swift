//
//  GoalModel.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/17.
//

import Foundation

///Firebase & UserDefault

struct TotalGoalInfoModel {
    var goal: GoalModel
    var days: [DayModel]
}

struct GoalModel: Codable {
    let userID: String
    let goalID: String
    let startDate : Date
    let endDate: Date
    let failAllowance: Int
    let description: String
    var status: Status
    var numOfSuccess : Int
    var numOfFail : Int
    var shared: Bool
}


struct DayModel: Codable {
    let dayIndex: Int
    var status: Status
    let date: String
}

enum Status: String, Codable  {
    case success = "success"
    case fail = "fail"
    case none = "none"
}

struct UserInfoModel: Codable {
    var totalTrial: Int
    var totalAchievement: Int
    var totalSuccess: Int
    var totalFail: Int
}

struct UsersInputForNewGoal{
    var goalDescripteion: String
    var failAllowance: Int
}
