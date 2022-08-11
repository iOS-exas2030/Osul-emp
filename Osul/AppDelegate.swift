//
//  AppDelegate.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo && Aya Bahaa on 7/2/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import FirebaseMessaging
import FirebaseCore
import UserNotifications
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let gcMessagesID = "gcm.message_id"
    var window: UIWindow?
    static var LevelID:Int!
    static var token : String!
    static var chatAppdelegate :  ChatModelDatum?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        IQKeyboardManager.shared().isEnabled = true
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barTintColor =  #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        UINavigationBar.appearance().isTranslucent = false
        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            // If your app wasn’t running and the user launches it by tapping the push notification, the push notification is passed to your app in the launchOptions
            let aps = notification["aps"] as! [String: AnyObject]
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        registerForPushNotifications()
            return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if(UserDefaults.standard.value(forKeyPath: "rememberMe") as? Bool == true){
            print("true sayed")
        }else{
            print("false sayed")
            UserDefaults.standard.removeObject(forKey: "userId")
            UserDefaults.standard.removeObject(forKey: "rememberMe")
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate  {
    
func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
}
    
func getNotificationSettings() {

    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}

func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    print("Device Token: \(deviceToken)")
    Messaging.messaging().apnsToken = deviceToken
    //UserDefaults.standard.set(token, forKey: DEVICE_TOKEN)
}

func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register: \(error)")
}

func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {

   // If your app was running and in the foreground
   // Or
   // If your app was running or suspended in the background and the user brings it to the foreground by tapping the push notification

   // Print message ID.
   if let messageID = userInfo[gcMessagesID] {
     print("Message ID: \(messageID)")
   }
     // Print full message.
   print("didReceiveRemoteNotification \(userInfo)")
//   guard let dict = userInfo["aps"]  as? [String: Any], let msg = dict ["alert"] as? String else {
//       print("Notification Parsing Error")  
//       return
//   }

}

   func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
     // If you are receiving a notification message while your app is in the background,
     // this callback will not be fired till the user taps on the notification launching the application.
     // TODO: Handle data of notification

     // With swizzling disabled you must let Messaging know about the message, for Analytics
     // Messaging.messaging().appDidReceiveMessage(userInfo)

     // Print message ID.
     if let messageID = userInfo[gcMessagesID] {
       print("Message ID: \(messageID)")
     }

     // Print full message.
     print(userInfo)
     completionHandler(UIBackgroundFetchResult.newData)
   }
   func userNotificationCenter(_ center: UNUserNotificationCenter,
                               willPresent notification: UNNotification,
     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
     let userInfo = notification.request.content.userInfo

     // With swizzling disabled you must let Messaging know about the message, for Analytics
     // Messaging.messaging().appDidReceiveMessage(userInfo)

     // Print message ID.
     if let messageID = userInfo[gcMessagesID] {
       print("Message ID3: \(messageID)")
     }
     // Print full message.
    let type = userInfo["type"] as! String
     if type == "5" {
        var chatdata = userInfo["chat"] as? String ?? ""
       // print("sayed 2 : \(userInfo["chat"] ?? [])")
     //   print("qqq : \(convertToDictionary(text: chatdata ?? ""))")
        
        var NewChatData = convertToDictionary(text: chatdata ?? "")
        //print("message : \(NewChatData?["message"])")
        
       AppDelegate.chatAppdelegate = ChatModelDatum(id: NewChatData?["id"] as! String, senderID: NewChatData?["sender_id"] as! String, senderName: NewChatData?["sender_name"] as! String, type: NewChatData?["type"] as! String, message: NewChatData?["message"] as! String, projectID: NewChatData?["project_id"] as! String, levelID: NewChatData?["level_id"] as! String, file: NewChatData?["file"] as! String, createdAt: NewChatData?["created_at"] as! String)
        //print("try2 :  \(AppDelegate.chatAppdelegate?.message )")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: NewChatData)
    }
    

     // Change this to your preferred presentation option
     completionHandler([[.alert, .sound]])
   }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
   func userNotificationCenter(_ center: UNUserNotificationCenter,
                               didReceive response: UNNotificationResponse,
                               withCompletionHandler completionHandler: @escaping () -> Void) {
     let userInfo = response.notification.request.content.userInfo
     // Print message ID.
     if let messageID = userInfo[gcMessagesID] {
       print("Message ID4: \(messageID)")
     }

     // With swizzling disabled you must let Messaging know about the message, for Analytics
     // Messaging.messaging().appDidReceiveMessage(userInfo)

     // Print full message.
     print("aya Done \(userInfo)")
     
    let type = userInfo["type"] as! String
    if type == "1" {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let rootViewController = self.window!.rootViewController as! UINavigationController
         let view = storyboard.instantiateViewController(withIdentifier: "NewOrdersVC") as! NewOrdersVC
         rootViewController.pushViewController(view, animated: true)
    }else if type == "2" {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = self.window!.rootViewController as! UINavigationController
        let view = storyboard.instantiateViewController(withIdentifier: "ContractVC") as! ContractVC
        rootViewController.pushViewController(view, animated: true)
    }else if type == "3" {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = self.window!.rootViewController as! UINavigationController
        let view = storyboard.instantiateViewController(withIdentifier: "MailVC") as! MailVC
        rootViewController.pushViewController(view, animated: true)
    }else if type == "5" {
        var chatdata = userInfo["chat"] as? String
        print("aya 2 : \(userInfo["chat"] ?? [])")
        var NewChatData = convertToDictionary(text: chatdata ?? "")
         print("message : \(NewChatData?["message"])")
         
        AppDelegate.chatAppdelegate = ChatModelDatum(id: NewChatData?["id"] as! String, senderID: NewChatData?["sender_id"] as! String, senderName: NewChatData?["sender_name"] as! String, type: NewChatData?["type"] as! String, message: NewChatData?["message"] as! String, projectID: NewChatData?["project_id"] as! String, levelID: NewChatData?["level_id"] as! String, file: NewChatData?["file"] as! String, createdAt: NewChatData?["created_at"] as! String)
         print("try2 :  \(AppDelegate.chatAppdelegate?.message )")
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: NewChatData)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = self.window!.rootViewController as! UINavigationController
        let view = storyboard.instantiateViewController(withIdentifier: "chatRoomViewController") as! chatRoomViewController
        view.levelId = NewChatData?["level_id"] as! String
        view.projectId = NewChatData?["project_id"] as! String
        view.projectname = NewChatData?["project_name"] as! String
        view.projectLevel = NewChatData?["level_name"] as! String
        rootViewController.pushViewController(view, animated: true)
    }else{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = self.window!.rootViewController as! UINavigationController
        let view = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        rootViewController.pushViewController(view, animated: true)
    }

      completionHandler()
   }
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    func showPermissionAlert() {
        let alert = UIAlertController(title: "WARNING", message: "Please enable access to Notifications in the Settings app.", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) {[weak self] (alertAction) in
            self?.gotoAppSettings()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        alert.addAction(settingsAction)
        alert.addAction(cancelAction)

        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }

    private func gotoAppSettings() {

        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.openURL(settingsUrl)
        }
    }
  

}
extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
    
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
     UserDefaults.standard.set(fcmToken, forKey: "token")
    AppDelegate.token = fcmToken
    let dataDict:[String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }
  // [END refresh_token]
}
