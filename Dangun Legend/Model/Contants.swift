//
//  Contants.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//

import Foundation

struct K {
    static let History = "History"
    static let userIdList = "userIdList"
    static let goals = "goals"
    static let userID = "userID"
    static let cellDayNum = "cellDayNum"
    static let none = "none"
    static let Loaded = "Loaded"
    static let auto = "auto"
    static let success = "success"
    static let fail = "fail"
    static let daysPassed = "daysPassed"
    
    
    static let FS_userCurrentArr = "userCurrentArr"
    static let FS_userCurrentGID = "userCurrentGID"
    static let FS_userGeneral = "userGeneral"
    static let FS_userCurrentGoal = "userCurrentGoal"
    static let FS_userHistory = "userHistory"

    
}


struct G {
    static let userID = "userID"
    static let goalID = "goalID"
    static let startDate = "startDate"
    static let endDate = "endDate"
    
    static let trialNumber = "trialNumber"
    static let failAllowance = "failAllowance"
    static let description = "description"
    
    static let numOfDays = "numOfDays"
    static let completed = "completed"
    static let goalAchieved = "goalAchieved"

    static let numOfSuccess = "numOfSuccess"
    static let numOfFail = "numOfFail"
    static let progress = "progress"
    
    static let currentGoal = "currentGoal"
}


struct keyForDf {
    static let usedBefore = "Default.Key: usedBefore"
    static let goalExistence = "Default.Key: goalExistence"
    static let loginStatus = "Default.Key: loginStatus"
    
    static let crrNumOfSucc = "Default.Key: crrNumOfSucc"
    static let crrNumOfFail = "Default.Key.crrNumOfFail"
    static let crrGoalID = "Default.Key: crrGoalID"
    static let crrGoal = "Default.Key: currentGoal"
    static let crrDaysArray = "Default.Key: currentDaysArray"
    static let crrUser = "Default.Key: currentUser"
    
    static let nickName = "Default.Key: nickName"
    

}

struct fb {
    static let GI_generalInfo = "GI_generalInfo"
    static let GI_totalTrial = "totalTrial"
    static let GI_totalDaysBeenThrough = "totalDaysBeenThrough"
    static let GI_totalAchievement = "totalAchievement"
    static let GI_successPerHundred = "successPerHundred"
    static let GI_usersAbility = "usersAbility"
    static let GI_totalSuccess = "totalSuccess"
}

struct sd {
    static let date = "date"
    static let dayNum = "dayNum"
    static let success = "success"
    static let userChecked = "userChecked"
}
