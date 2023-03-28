//
//  PushNotificationManager.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 28/03/2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UserNotifications

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func registerForPushNotifications() {
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
                .init(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        updateFirestorePushTokenIfNeeded()
    }
    
    // Add token to firestore
    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            let usersRef = Firestore.firestore().collection("token").document("fcmToken")
            usersRef.setData(["fcmToken": token], merge: true)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        updateFirestorePushTokenIfNeeded()
        messaging.token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let fcmToken = token {
                print("FCM registration token: \(fcmToken)")
                let dataDict: [String: String] = ["fcmToken": fcmToken]
                NotificationCenter.default.post(name: Notification.Name(UserDefaultKey.fcmToken), object: fcmToken, userInfo: dataDict)
                // Save it to the user defaults
                UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
            }
        }
    }
        
    // UNUserNotificationCenterDelegate
    func userNotificationCenter(_: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [[.banner, .list, .sound]]
    }
    
    // Application
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    } 

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("APNs received with: \(userInfo)")
    }
    
    func application(_: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

}
