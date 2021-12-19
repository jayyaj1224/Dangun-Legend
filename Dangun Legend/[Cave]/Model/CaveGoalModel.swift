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
    
    init() {
        self.totalTrialCount = 0
        self.totalGoalAchievementsCount = 0
        self.totalSuccessCount = 0
        self.totalFailCount = 0
        self.usersGoalData = []
    }
}

struct GoalModel: Codable {
    let goalDescription: String
    let identifier: String
    var goalStatus: GoalStatus

    let startDate: String
    let endDate: String
    var isForShare: Bool

    var successCount: Int
    var failCount: Int
    let failCap: Int

    var daysArray: [DaysModel]

    init(goal: String, failCap: Int) {
        let startDate = Date()
        self.goalDescription = goal
        self.identifier = Date().asString.identifier
        self.goalStatus = .na
        
        self.startDate = startDate.asString.yyyy_MM_dd
        self.endDate = startDate.add(99).asString.yyyy_MM_dd
        self.isForShare = false
        
        self.successCount = 0
        self.failCount = 0
        self.failCap = failCap
        
        self.daysArray = Array(1...100)
            .map { num in
                DaysModel.init(
                    date: startDate.add(num-1).asString.yyyy_MM_dd,
                    dayIndex: num,
                    status: .unchecked
                )
            }
    }
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
    case na
}
