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
import Onboard

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
        
        let userDefault = UserDefaults.standard.bool(forKey: "firstLaunch")
//        Logger.debugLog(userDefault)
        if userDefault == true {
            // ↓画面分岐処理確認用
            //UserDefaults.standard.set(false, forKey: "firstLaunch")
            print("初回起動でない")
        } else {
            //UserDefaults.standard.set(true, forKey: "firstLaunch")
            print("初回起動時")
            
            // チュートリアル画面表示
            setOnBoard(application)
        }
        
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

extension AppDelegate {
    /// チュートリアル画面の初期設定
    func setOnBoard(_ application: UIApplication) {
        if true {
            var image = UIImage(named:"ToDo4")!
            var reSize = CGSize(width: 250, height: 450)
            image = image.reSizeImage(reSize: reSize)
            let content1 = OnboardingContentViewController(
                title: "",
                body: "◯タスク追加\nボタンからタスク追加してね\n◯カレンダーアイコン\nカレンダーで設定するとアイコンが表示されるよ\n◯削除\n左へスライドすると削除ボタンが表示されるよ",
                image: image,
                buttonText: "ToDoリスト",
                action: nil
            )
            content1.topPadding = 20
            content1.underIconPadding = 5
            content1.underTitlePadding = 0
            content1.bottomPadding = 0
            content1.bodyLabel.font = content1.bodyLabel.font.withSize(15)
            content1.bodyLabel.textAlignment = NSTextAlignment.left
            image = UIImage(named: "ToDo3")!
            reSize = CGSize(width: 250, height: 450)
            image = image.reSizeImage(reSize: reSize)
            let content2 = OnboardingContentViewController(
                title: "",
                body: "◯タイトル\nタイトルを入力してね\n◯目標時間\n目標時間を入力してね\n◯日付指定\n繰り返し行うタスクは指定なし\n期日のあるものは指定あり",
                image: image,
                buttonText: "ToDoリスト",
                action: nil
            )
            content2.topPadding = 20
            content2.underIconPadding = 5
            content2.underTitlePadding = 0
            content2.bottomPadding = 0
            content2.bodyLabel.font = content1.bodyLabel.font.withSize(15)
            content2.bodyLabel.textAlignment = NSTextAlignment.left
            image = UIImage(named: "カレンダー6")!
            reSize = CGSize(width: 250, height: 450)
            image = image.reSizeImage(reSize: reSize)
            let content3 = OnboardingContentViewController(
                title: "",
                body: "◯やることリスト\nToDoリストで追加したタスクを表示\n◯標準カレンダーデータ\n標準カレンダーのデータを参照\n◯削除ボタン\n削除する\n◯実行時間\n実行時間を伸縮する",
                image: image,
                buttonText: "カレンダー",
                action: nil
            )

            image = UIImage(named: "カレンダー7")!
            reSize = CGSize(width: 250, height: 450)
            image = image.reSizeImage(reSize: reSize)
            let content4 = OnboardingContentViewController(
                title: "",
                body: "◯日付アイコン\n指定ありのタスクに表示される\n◯ドラッグ&ドロップ\nスケジュールの隙間時間と比較しながら開始時間を設定できる",
                image: image,
                buttonText: "カレンダー",
                action: nil
            )
            content4.topPadding = 20
            content4.underIconPadding = 5
            content4.underTitlePadding = 0
            content4.bottomPadding = 0
            content4.bodyLabel.font = content1.bodyLabel.font.withSize(15)
            content4.bodyLabel.textAlignment = NSTextAlignment.left
            var bgImage = UIImage(named:"画面フレーム")
//            let screen = ScreenSize() * screen.calScale
            reSize = CGSize(width: 375, height: 600)
            bgImage = bgImage!.reSizeImage(reSize: reSize)
//            let bgImage = UIImage(data: NSData(contentsOf: bgImageURL as URL)! as Data)
            let vc = OnboardingViewController(
                backgroundImage: bgImage,
                contents: [content1, content2, content3, content4]
            )

            vc?.allowSkipping = true
            vc?.skipHandler = {
                print("skip")
                //遷移
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeView = storyboard.instantiateViewController(withIdentifier: "Home")as! HomeNavigationController
                self.window?.rootViewController = homeView
                self.window?.makeKeyAndVisible()
                //skipボタンを押したときに, 初回起動ではなくす
                UserDefaults.standard.set(true, forKey: "firstLaunch")
            }


            // 最後のページが表示されるとき, skipボタンを消す
            content3.viewWillAppearBlock = {
                    vc?.skipButton.isHidden = true
            }

            // 最後のページが消えるとき, skipボタンを表示(前ページに戻った場合のため)
            content3.viewDidDisappearBlock = {
                    vc?.skipButton.isHidden = false
            }

            window?.rootViewController = vc
            
        }
    }
}

extension UIImage {
    // resize image
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }

    // scale the image at rates
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}
