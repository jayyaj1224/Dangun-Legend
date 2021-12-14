//
//  DangunManager.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/12/14.
//

import Foundation
import UIKit

enum DangunManager {
    static var userInfo: UserInfo? {
        guard let userId = self.userId(),
              let data = UserDefaults.standard.data(forKey: "USERINFO_\(userId)"),
              let userInfo = try? PropertyListDecoder().decode(UserInfo.self, from: data) else {
                  return nil
              }
        return userInfo
    }
    
    static func userLoggedIn() -> Bool {
        return true
    }
    
    static func userId() -> String? {
        return ""
    }

}
