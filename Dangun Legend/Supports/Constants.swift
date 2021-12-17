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
    static var userInfo: UserInfo? {
        guard let userId = self.userId(),
              let data = UserDefaults.standard.data(forKey: "USERINFO_\(userId)"),
              let userInfo = try? PropertyListDecoder().decode(UserInfo.self, from: data) else {
                  return nil
              }
        return userInfo
    }
    
    static func userHasLoggedIn() -> Bool {
        return true
    }
    
    static func userId() -> String? {
        if userHasLoggedIn() {
            return ""
        }
        return ""
    }
    
    // MARK: - Keys  static var UDKEY_00000 = "UDKEY_00000"
    
    static var UDKEY_USERINFO: String {
        if self.userHasLoggedIn(), let id = self.userId() {
            return "UDKEY_USERINFO_" + id
        } else {
            return "UDKEY_USERINFO_GUEST"
        }
    }
}
