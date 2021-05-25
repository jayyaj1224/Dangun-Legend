//
//  UserDefaultsService.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/25.
//

import Foundation


struct UserDefaultService {
    
    func userInfo_oneMoreSuccess(){
        let update = defaults.integer(forKey: KeyForDf.totalSuccess)+1
        defaults.set(update,forKey: KeyForDf.totalSuccess)
    }
    
    func userInfo_oneMoreFail(){
        let update = defaults.integer(forKey: KeyForDf.totalFail)+1
        defaults.set(update,forKey: KeyForDf.totalFail)
    }
    
    func userInfo_oneMoreAchievement(){
        let update = defaults.integer(forKey: KeyForDf.totalAchievements)+1
        defaults.set(update,forKey: KeyForDf.totalAchievements)
    }
    
    func userInfo_oneMoreTrial(){
        let update = defaults.integer(forKey: KeyForDf.totalTrial)+1
        defaults.set(update,forKey: KeyForDf.totalTrial)
    }
    
    func goal_oneMoreSuccess(){
        let update = defaults.integer(forKey: KeyForDf.successNumber)+1
        defaults.set(update,forKey: KeyForDf.successNumber)
    }
    
    func goal_oneMoreFail(){
        let update = defaults.integer(forKey: KeyForDf.failNumber)+1
        defaults.set(update,forKey: KeyForDf.failNumber)
    }

    

}
