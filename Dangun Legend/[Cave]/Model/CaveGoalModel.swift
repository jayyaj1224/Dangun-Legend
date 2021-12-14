//
//  CaveGoalModel.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/12/14.
//

import Foundation

struct UserInfo: Codable {
    var totalTrialCount: Int
    var totalGoalAchievementsCount: Int
    var totalSuccessCount: Int
    var totalFailCount: Int
    var usersGoalData: [GoalModel]
}

struct GoalModel: Codable {
    let title: String
    let goalDescription: String
    let goalIdentifier: String
    var goalStatus: GoalStatus
    
    let userId: String
    let startDate: String
    let endDate: String
    var isForShare: Bool
    
    var successCount: Int
    var failCount: Int
    let failLimit: Int

    var daysArray: [DaysModel]
}

struct DaysModel: Codable {
    let date: String
    let dayIndex: Int
    var status: DailyStatus = .unchecked
}

enum DailyStatus: Codable {
    case success
    case fail
    case unchecked
}

enum GoalStatus: Codable {
    case success
    case fail
    case onGoing
}
