//
//  AppDelegate.swift
//  wayUparty
//
//  Created by Jasty Saran  on 01/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import GooglePlaces
import GoogleMaps
import Mobilisten
var dobOfUser = String()
var signUpDOB = String()
var packagesDict: [String: Any] = [:]
var packagesUUIDict: [String:Any] = [:]
var packageMenuItems : String = ""
var lat = ""
var lng = ""
var cityname:String = ""
var userName = ""
var password = ""
var timezone = ""
var dealsAndOffersOn:Bool = false

         @main
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate, UNUserNotificationCenterDelegate,MessagingDelegate {
    var pushDeviceToken = String()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Window = window
        UIViewController.swizzle()
        Thread.sleep(forTimeInterval: 3.0)
        
//            GMSPlacesClient.provideAPIKey("AIzaSyDGo1BOkqCSDvi9-UK9u2jPQcxY-oVfhrU")
//            GMSServices.provideAPIKey("AIzaSyDGo1BOkqCSDvi9-UK9u2jPQcxY-oVfhrU")
        
        GMSPlacesClient.provideAPIKey("AIzaSyDGo1BOkqCSDvi9-UK9u2jPQcxY-oVfhrU")
        GMSServices.provideAPIKey("AIzaSyDGo1BOkqCSDvi9-UK9u2jPQcxY-oVfhrU")
        GMSServices.provideAPIKey("AIzaSyAfjQC-g9h7MzTmQytXfHwyLO45rkYdazw")
   
        
//        DispatchQueue.main.async {
//            self.initFreshchatSDK()
//        }
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instange ID: \(error)")
//            } else if let result = result {
//                print("Remote instance ID token: \(result.token)")
//                print("Remote InstanceID token: \(result.token)")
//            }
//        }
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
       
        application.registerForRemoteNotifications()
        ZohoSalesIQ.initWithAppKey( "skchS8U54hkGU06CfO%2BUw%2FzPo0Waz0eaqf8R0DaHv1rQEm6YWP%2Fthvua5C2e0p6e_in", accessKey:"p7QXJ3pkGcHLX51VBgIijQZz6qUUzCmezj%2BDHkHfQhy3zUIxbgC8tQSr8q0ao2nWbwm0hMNjr6SfAmH6AbHTJluK81dhJv6VCnvRThm5XEjr6D4NcQ%2BYtlznHGA9i%2FEpUCxe6e1%2BLTVmlEg0dbB1arho4EWb5B5S", completion:nil )

        return true
    }
//    func initFreshchatSDK() {
//        let fchatConfig = FreshchatConfig.init(appID: "cc8acfd7-e66f-4a11-b32c-3a1d37955268", andAppKey: "185f78dc-77cc-48b3-bd7b-9d38e9aed565") //Enter your AppID and AppKey here
//        fchatConfig.themeName = "CustomThemeFile"
//        fchatConfig.domain = "msdk.in.freshchat.com"
//        Freshchat.sharedInstance().initWith(fchatConfig)
//    }
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

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "No device token avaialble")")
        pushDeviceToken = fcmToken ?? "No token received from server"
        let dataDict:[String: String] = ["token": fcmToken!]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
       // pushDeviceToken = token
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let alertController = UIAlertController(title: "Alerts", message: userInfo["aps"] as? String, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(ok)
        window?.rootViewController?.present(alertController, animated: true)
    }


    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo["gcmMessageIDKey"] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
    }
    func interNetChecking( )   {
        let status = Reach().connectionStatus()
        
        
        switch status {
        case .unknown, .offline:
            
            let alert = UIAlertController(title: "Check", message: "Internet Connection is Required Turn On Your Network", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            
            DispatchQueue.main.async(execute: {
                //self.present(alert, animated: true, completion: nil)
                
            })
            print("Not connected")
        case .online(.wwan):
            print("Connected via WWAN")
        case .online(.wiFi):
            print("Connected via WiFi")
        }
    }

}

