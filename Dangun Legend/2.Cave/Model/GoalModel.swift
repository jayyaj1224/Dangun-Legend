//
//  GoalModel.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/17.
//

import Foundation

///Firebase & UserDefault

struct TotalGoalInfo {
    var goal: Goal
    var days: [SingleDayInfo]
}

struct Goal: Codable {
    let userID: String
    let goalID: String
    let startDate : Date
    let endDate: Date
    
    let failAllowance: Int
    let description: String

    let numOfDays: Int
    var completed: Bool
    var goalAchieved: Bool
    
    var numOfSuccess : Int
    var numOfFail : Int
    var shared: Bool
}


struct SingleDayInfo: Codable {
    let dayNum: Int
    var status: DayStatus
    let date: String
}

enum DayStatus: String, Codable  {
    case unchecked = "unchecked"
    case success = "success"
    case fail = "fail"

}

struct UsersGeneralInfo {
    var totalTrial: Int
    var totalAchievement: Int
    var totalSuccess: Int
    var totalFail: Int
}

struct UsersInputForNewGoal{
    var goalDescripteion: String
    var failAllowance: Int
}
