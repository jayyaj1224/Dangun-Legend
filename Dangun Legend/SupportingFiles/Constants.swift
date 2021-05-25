//
//  Contants.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//

import Foundation

struct K {
    static let History = "History"

    static let goals = "goals"
    static let userID = "userID"
    static let cellDayNum = "cellDayNum"
    static let none = "none"
    static let success = "success"
    static let fail = "fail"
    static let daysPassed = "daysPassed"
    
    static let FS_userIdList = "userIdList"
    static let FS_userCurrentArr = "userCurrentArr"
    static let FS_userCurrentGID = "userCurrentGID"
    static let FS_userGeneral = "userGeneral"
    static let FS_userCurrentGoal = "userCurrentGoal"
    static let FS_userHistory = "userHistory"
    static let FS_board = "board"
    static let FS_userNickName = "userNickName"
    
    static let unchecked = "unchecked"
  
}


struct G {
    static let userID = "userID"
    static let goalID = "goalID"
    static let currentGoal = "currentGoal"
    
    static let startDate = "startDate"
    static let endDate = "endDate"
    
    static let trialNumber = "trialNumber"
    static let failAllowance = "failAllowance"
    static let description = "description"
    static let numOfSuccess = "numOfSuccess"
    static let numOfFail = "numOfFail"
    
    static let nickName = "nickName"
    static let shared = "shared"
    static let status = "status"
}

struct KeyForDf {
    static let goalID = "Default.Key: goalID"
    static let totalSuccess = "Default.Key: totalSuccess"
    static let totalFail = "Default.Key: totalFail"
    static let totalTrial = "Default.Key: totalTrial"
    static let totalAchievements = "Default.Key: totalAchievements"

    static let successNumber = "Default.Key: successNumber"
    static let failNumber = "Default.Key: failNumber"
    
    static let firstLaunch = "Default.Key: usedBefore"
    static let crrGoalExists = "Default.Key: crrGoalExists"
    static let loginStatus = "Default.Key: loginStatus"
    static let needToSetViewModel = "needToSetViewModel"

    static let crrGoal = "Default.Key: currentGoal"
    static let crrDaysArray = "Default.Key: currentDaysArray"
    static let userID = "Default.Key: currentUser"

    static let nickName = "Default.Key: nickName"
}

struct FS {
    static let GI_generalInfo = "GI_generalInfo"
    static let GI_totalTrial = "totalTrial"
    static let GI_totalAchievement = "totalAchievement"
    static let GI_totalFail = "totalFail"
    static let GI_totalSuccess = "totalSuccess"
}

struct FS_daysInfo {
    static let date = "date"
    static let dayNum = "dayNum"
    static let status = "status"
}


