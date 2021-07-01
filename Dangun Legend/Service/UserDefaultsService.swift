//
//  UserDefaultsService.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/25.
//

import Foundation


struct UserDefaultService {
    
    func userInfo_oneMoreSuccess(){
        let update = defaults.integer(forKey: UDF.totalSuccess)+1
        defaults.set(update,forKey: UDF.totalSuccess)
    }
    
    func userInfo_oneMoreFail(){
        let update = defaults.integer(forKey: UDF.totalFail)+1
        defaults.set(update,forKey: UDF.totalFail)
    }
    
    func userInfo_oneMoreAchievement(){
        let update = defaults.integer(forKey: UDF.totalAchievements)+1
        defaults.set(update,forKey: UDF.totalAchievements)
    }
    
    func userInfo_oneMoreTrial(){
        let update = defaults.integer(forKey: UDF.totalTrial)+1
        defaults.set(update,forKey: UDF.totalTrial)
    }
    
    func goal_oneMoreSuccess(){
        let update = defaults.integer(forKey: UDF.successNumber)+1
        defaults.set(update,forKey: UDF.successNumber)
    }
    
    func goal_oneMoreFail(){
        let update = defaults.integer(forKey: UDF.failNumber)+1
        defaults.set(update,forKey: UDF.failNumber)
    }

    
    
    func userDefaultSettingForNewGoal(goal: GoalModel){
        self.userInfo_oneMoreTrial()
        defaults.set(false, forKey: UDF.needToSetViewModel)
        defaults.set(true, forKey: UDF.crrGoalExists)
        defaults.set(goal.goalID, forKey: UDF.goalID)
        defaults.set(goal.numOfSuccess, forKey: UDF.successNumber)
        defaults.set(goal.numOfFail, forKey: UDF.failNumber)
    }
    
    func goalEnded(){
        defaults.set(false, forKey: UDF.crrGoalExists)
        defaults.removeObject(forKey: UDF.successNumber)
        defaults.removeObject(forKey: UDF.failNumber)
        defaults.removeObject(forKey: UDF.goalID)
    }

}
