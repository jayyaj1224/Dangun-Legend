//
//  AppDelegate.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/02.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import GoogleSignIn
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()
    
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 120.0

        if defaults.bool(forKey: UDF.firstLaunch) {
            defaults.set(false, forKey: UDF.firstLaunch)
            defaults.set(false, forKey: UDF.crrGoalExists)
            defaults.set(false, forKey: UDF.loginStatus)
            defaults.set(K.none, forKey: UDF.userID)
        }
        
        Thread.sleep(forTimeInterval: 0.8)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}
