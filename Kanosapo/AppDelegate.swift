//
//  AppDelegate.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/06/07.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
import Firebase
import LineSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //かける　削除予定　12/10
    var delegateResults: Results<Calendar24>?
    //
    
    var calendarFlag: Bool?
    
    
    //var backgroundTaskID : UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LoginManager.shared.setup(channelID: "1655339965", universalLinkURL: nil)
        calendarFlag = false

        
        // Override point for customization after application launch.
        //　ナビゲーションバーの背景色
        UINavigationBar.appearance().barTintColor = UIColor(red: 246/255, green: 194/255, blue: 214/255, alpha: 255/255)
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        UINavigationBar.appearance().tintColor = UIColor.black
        // ナビゲーションバーのテキストを変更する
        UINavigationBar.appearance().titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor.black
        ]
        
        // first time to launch this app
        let defaults = UserDefaults.standard
        var dic = ["firstLaunch": true]
        defaults.register(defaults: dic)
        if defaults.bool(forKey: "firstLaunch") { 
            UserDefaults.standard.set(randomString(length: 16), forKey: "user_id")
            UserDefaults.standard.set(50, forKey: "score")
            defaults.set(false, forKey: "firstLaunch")
        }
        
        requestAuthorization()
        checkAuth()
        
        tokenUpdate()
        FirebaseApp.configure()
        writeFirebase()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return LoginManager.shared.application(app, open: url, options: options)
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        /*
         self.backgroundTaskID = application.beginBackgroundTask(){
         [weak self] in
         application.endBackgroundTask((self?.backgroundTaskID)!)
         self?.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
         }
         */
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        //かける　削除 12/10
//        var trigger: UNNotificationTrigger
//        let content = UNMutableNotificationContent()
//        var notificationTime = DateComponents()
//        if(delegateResults != nil){
//            for item in delegateResults!{
//                let components = Calendar.current.dateComponents(in: TimeZone.current, from: item.start)
//                notificationTime.hour = components.hour
//                notificationTime.minute = components.minute! - 10
//                trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
//                content.title = item.todo.first!.title
//                content.body = "もうすぐタスクの時間だよ！"
//                content.sound = UNNotificationSound.default
//                var request = UNNotificationRequest(identifier: item.calendarid, content: content, trigger: trigger)
//                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//            }
//        }
        //
        //NotificationCenter.default.post(name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)
        print("applicationWillEnterForeground")
        
        if(calendarFlag!){
            test_getCalendar()
        }
        
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //application.endBackgroundTask(self.backgroundTaskID)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func randomString(length: Int) -> String {
      let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in characters.randomElement()! })
    }
    
    private func requestAuthorization() {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert]) { [weak self] (granted, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            if granted {
                center.delegate = self
            } else {
                
                DispatchQueue.main.async {
                    guard let vc = self?.window?.rootViewController else {
                        return
                    }
                    //vc.showAlert(title: "未許可", message: "許可がないため通知ができません")
                }
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        // アプリ起動時も通知を行う
        completionHandler([ .badge, .sound, .alert ])
    }
}
