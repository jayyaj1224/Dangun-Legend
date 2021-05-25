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
                    
                    print("........... Found ID ........... ")
                    print("........... Checking if goal exists ........... ")
                    self.checkIfGoalExists(userID: userID)
                    self.setUserInfo(userID: userID)
                    
                } else {
                    
                    print("........... New ID ........... ")
                    print("........... Will set default value ........... ")
                    
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
                    defaults.set(true, forKey: KeyForDf.crrGoalExists)
                } else {
                    ///1. 기존 유저 - 진행하고 있는 골이 없을 때
                    defaults.set(false, forKey: KeyForDf.crrGoalExists)
                }
            }
        }
    }
    

    
    ///2. 기존 유저 - 진행하고 있는 골이 있을 때
    func setUserInfo(userID: String){
        self.fireStoreService.loadUserInfo { userInfo in
            //save at User default
            defaults.set(userInfo.totalFail,forKey: KeyForDf.totalFail)
            defaults.set(userInfo.totalSuccess,forKey: KeyForDf.totalSuccess)
            defaults.set(userInfo.totalAchievements,forKey: KeyForDf.totalAchievements)
            defaults.set(userInfo.totalTrial,forKey: KeyForDf.totalTrial)
        }
    }


    ///3. 신규 유저일 때
    func setDefaultValues(userID: String){
        
        let defaultUserInfo = UserInfoModel(totalTrial: 0, totalAchievements: 0, totalSuccess: 0, totalFail: 0)
        self.fireStoreService.saveUserInfo(info: defaultUserInfo)
        self.fireStoreService.saveUserID(userID)
        
        defaults.set(defaultUserInfo.totalTrial, forKey: KeyForDf.totalFail)
        defaults.set(defaultUserInfo.totalSuccess, forKey: KeyForDf.totalSuccess)
        defaults.set(defaultUserInfo.totalAchievements, forKey: KeyForDf.totalAchievements)
        defaults.set(defaultUserInfo.totalFail, forKey: KeyForDf.totalTrial)
        
        defaults.set(false, forKey: KeyForDf.crrGoalExists)
    }
    
    
    func logOutRemoveDefaults(){
        print("------logged out------")
        
        defaults.set(false, forKey: KeyForDf.loginStatus)
        
        defaults.removeObject(forKey: KeyForDf.totalAchievements)
        defaults.removeObject(forKey: KeyForDf.totalSuccess)
        defaults.removeObject(forKey: KeyForDf.totalFail)
        defaults.removeObject(forKey: KeyForDf.totalTrial)
        
        defaults.removeObject(forKey: KeyForDf.successNumber)
        defaults.removeObject(forKey: KeyForDf.failNumber)
        defaults.removeObject(forKey: KeyForDf.goalID)
        
        
        defaults.removeObject(forKey: KeyForDf.userID)
        defaults.removeObject(forKey: KeyForDf.crrGoalExists)
    }

}
