//
//  HomeViewInitialSetting.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/25.
//

import Foundation


struct InitialSettingManager {
    
    private let userDefaultService = UserDefaultService()
    private let fireStoreService = FireStoreService()
    
    func checkWhichSetIsNeeded(userID: String) {
        let idList = db.collection(K.FS_userIdList).document(userID)
        idList.getDocument { (document, error) in
            if let doc = document {
                if doc.exists {
                    
                   // print("........... Found ID ........... ")
                   // print("........... Checking if goal exists ........... ")
                    self.checkIfGoalExists(userID: userID)
                    self.setUserInfo(userID: userID)
                    
                } else {
                    
                    //print("........... New ID ........... ")
                    //print("........... Will set default value ........... ")
                    
                    self.setDefaultValues(userID: userID)
                }
            }
        }
    }
    
    func checkIfGoalExists(userID: String) {
        let idList = db.collection(K.FS_userCurrentGID).document(userID)
        idList.getDocument { (document, error) in
            if let doc = document {
                if doc.exists {
                    ///1. 기존 유저 - 진행하고 있는 Goal 이 있을 때
                    defaults.set(true, forKey: UDF.crrGoalExists)
                } else {
                    ///1. 기존 유저 - 진행하고 있는 Goal 이 없을 때
                    defaults.set(false, forKey: UDF.crrGoalExists)
                }
            }
        }
    }
    

    
    ///2. 기존 유저 -UserINfo Setting
    func setUserInfo(userID: String){
        self.fireStoreService.loadUserInfo { userInfo in
                defaults.set(userInfo.totalFail,forKey: UDF.totalFail)
                defaults.set(userInfo.totalSuccess,forKey: UDF.totalSuccess)
                defaults.set(userInfo.totalAchievements,forKey: UDF.totalAchievements)
                defaults.set(userInfo.totalTrial,forKey: UDF.totalTrial)
        }
    }


    ///3. 신규 유저일 때
    func setDefaultValues(userID: String){
        
        let defaultUserInfo = UserInfoModel(totalTrial: 0, totalAchievements: 0, totalSuccess: 0, totalFail: 0)
        self.fireStoreService.saveUserInfo(info: defaultUserInfo)
        self.fireStoreService.saveUserID(userID)
        
        defaults.set(defaultUserInfo.totalTrial, forKey: UDF.totalFail)
        defaults.set(defaultUserInfo.totalSuccess, forKey: UDF.totalSuccess)
        defaults.set(defaultUserInfo.totalAchievements, forKey: UDF.totalAchievements)
        defaults.set(defaultUserInfo.totalFail, forKey: UDF.totalTrial)
        
        defaults.set(false, forKey: UDF.crrGoalExists)
    }
    
    
    func logOutRemoveDefaults(){
        defaults.set(false, forKey: UDF.loginStatus)
        
        defaults.removeObject(forKey: UDF.totalAchievements)
        defaults.removeObject(forKey: UDF.totalSuccess)
        defaults.removeObject(forKey: UDF.totalFail)
        defaults.removeObject(forKey: UDF.totalTrial)
        
        defaults.removeObject(forKey: UDF.successNumber)
        defaults.removeObject(forKey: UDF.failNumber)
        defaults.removeObject(forKey: UDF.goalID)
        
        
        defaults.removeObject(forKey: UDF.userID)
        defaults.removeObject(forKey: UDF.crrGoalExists)
    }
}
