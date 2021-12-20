//
//  Constants.swift
//  Dangun Legend
//
//  Created by Lee Jong Yun on 2021/12/17.
//

import Foundation
import UIKit


enum CS {

    // MARK: - UI
    static let screenWidth = UIScreen.main.bounds.width
    
    
    // MARK: - UserInfo
    static func saveUserInfo(info: UserInfo) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(info), forKey: UDKEY_USERINFO)
    }
    
    static var userInfo: UserInfo? {
        guard let data = UserDefaults.standard.data(forKey: UDKEY_USERINFO),
              let userInfo = try? PropertyListDecoder().decode(UserInfo.self, from: data) else {
                  return nil
              }
        return userInfo
    }
    
    static var isFirstLaunch: Bool {
        if UserDefaults.standard.value(forKey: UDKEY_FIRST_LAUNCH) == nil {
            return true
        } else {
            return false
        }
    }
    
    static var dummyGoal: GoalModel = .init(goal: "설정된 목표가 아직 없습니다.\n오른쪽 아래 +버튼을 눌러 추가해주세요.", failCap: 0)
    
    // MARK: - Keys  static var UDKEY_00000 = "UDKEY_00000"
    
    static var UDKEY_USERINFO: String = "UDKEY_USERINFO"
    
    static let UDKEY_FIRST_LAUNCH: String = "UDKEY_FIRST_LAUNCH"

}
