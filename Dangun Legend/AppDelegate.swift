//
//  AppDelegate.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/02.
//

import UIKit
import Firebase
import FirebaseMessaging
import NotificationCenter
import UserNotifications
import GoogleSignIn
import SnapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        
        self.setupMessageing()
        
//        self.setupLaunchScreenTime(for: 0.8)
        
        application.registerForRemoteNotifications()
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
    
    
    private func setupLaunchScreenTime(for time: Double) {
        Thread.sleep(forTimeInterval: time)//Launch Screen time
    }
    
    private func setupMessageing() {
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let error = error {
                print("ERROR|FCM 등록토큰 가져오기: \(error) ")
            } else if let token = token {
                print("FCM 등록토큰: \(token)")
            }
        }
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
}

@available(iOS 14.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
//
//    @available(iOS 14.0.0, *)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
//        return [.banner, .badge, .list, .sound]
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("FCM 등록토큰 갱신: \(fcmToken)")
    }
}
