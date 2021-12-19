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
    
    // MARK: - Keys  static var UDKEY_00000 = "UDKEY_00000"
    
    static var UDKEY_USERINFO: String = "UDKEY_USERINFO"
    
    static let UDKEY_FIRST_LAUNCH: String = "UDKEY_FIRST_LAUNCH"

}
