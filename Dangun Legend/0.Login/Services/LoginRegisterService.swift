
//  LoginService.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/15.


import Foundation


struct LoginAndRegisterService {
    
    private let userDefaultService = UserDefaultService()
    
    private let fireStoreService = FireStoreService()
    
    private let coreDataService = CoreDataService()
    
    func checkWhichSetIsNeeded(userID: String) {
        let idList = db.collection(K.FS_userIdList).document(userID)
        idList.getDocument { (document, error) in
            if let doc = document {
                if doc.exists {
                    
                    print("........... Found ID ........... ")
                    print("........... Checking if goal exists ........... ")
                    self.checkIfGoalExists(userID: userID)
                    
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
                    print("*** goal exists >>>  setting current goal and goal Arr")
                    defaults.set(true, forKey: KeyForDf.crrGoalExists)
                    self.setCurrentGoal(userID: userID)
                } else {
                    ///1. 기존 유저 - 진행하고 있는 골이 없을 때
                    print("*** goal doesn't exists >>>  setting goal existence: false")
                    defaults.set(false, forKey: KeyForDf.crrGoalExists)
                }
            }
        }
    }
    

    
    
    
    ///2. 기존 유저 - 진행하고 있는 골이 있을 때
    func setCurrentGoal(userID: String){
        
        
        DispatchQueue.global(qos: .utility).async {
            self.fireStoreService.loadCurrentGoal { goalModel in
                //save at Core data

            }
            self.fireStoreService.loadUserInfo { userInfo in
                //save at User default
                defaults.set(userInfo.totalFail,forKey: UserInfoKey.totalFail)
                defaults.set(userInfo.totalSuccess,forKey: UserInfoKey.totalSuccess)
                defaults.set(userInfo.totalAchievements,forKey: UserInfoKey.totalAchievements)
                defaults.set(userInfo.totalTrial,forKey: UserInfoKey.totalTrial)
            }
        }
    }


    ///3. 신규 유저일 때
    func setDefaultValues(userID: String){
        
        let defaultUserInfo = UserInfoModel(totalTrial: 0, totalAchievements: 0, totalSuccess: 0, totalFail: 0)
        self.fireStoreService.saveUserInfo(info: defaultUserInfo)
        self.fireStoreService.saveUserID(userID)
        
        defaults.integer(forKey: UserInfoKey.totalFail)
        defaults.integer(forKey: UserInfoKey.totalSuccess)
        defaults.integer(forKey: UserInfoKey.totalAchievements)
        defaults.integer(forKey: UserInfoKey.totalTrial)
        
        defaults.set(userID, forKey: KeyForDf.userID)
        defaults.set(true, forKey: KeyForDf.loginStatus)
        defaults.set(false, forKey: KeyForDf.crrGoalExists)
    }
    
    
    func logOutRemoveDefaults(){
        print("------logged out------")
        
        //CoreData goal, days 지우기
        coreDataService.deletData(EntityName.dayData)
        coreDataService.deletData(EntityName.goalData)
        
        defaults.set(false, forKey: KeyForDf.loginStatus)
        
        defaults.removeObject(forKey: UserInfoKey.totalAchievements)
        defaults.removeObject(forKey: UserInfoKey.totalSuccess)
        defaults.removeObject(forKey: UserInfoKey.totalFail)
        defaults.removeObject(forKey: UserInfoKey.totalTrial)
        
        defaults.removeObject(forKey: KeyForDf.userID)
        
        defaults.removeObject(forKey: KeyForDf.crrGoalExists)
    }

}
