//
//  Tutorial.swift
//  Kanosapo
//
//  Created by 牧内秀介 on 2020/12/27.
//

import Foundation
import Onboard
/// チュートリアル画面の初期設定

class Tutorial: NSObject {
    func setOnBoard(_ application: UIApplication) {
        if true {
            let content1 = OnboardingContentViewController(
                title: "titleだよ",
                body: "bodyだよ",
                image: nil,
                buttonText: "",
                action: nil
            )
            let content2 = OnboardingContentViewController(
                title: "Titleだよ",
                body: "Bodyだよ",
                image: nil,
                buttonText: "",
                action: nil
            )
            let content3 = OnboardingContentViewController(
                title: "Titleだよ",
                body: "Bodyだよ",
                image: nil,
                buttonText: "はじめる",
                action: {
                    //遷移
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeView = storyboard.instantiateViewController(withIdentifier: "Map")as! ViewController
                    self.window?.rootViewController = homeView
                    self.window?.makeKeyAndVisible()
                    //skipボタンを押したときに, 初回起動ではなくす
                    UserDefaults.standard.set(true, forKey: "firstLaunch")
                }
            )
            
            let bgImageURL = NSURL(string: "https://www.pakutaso.com/shared/img/thumb/P1030938-Edit_TP_V4.jpg")!
            let bgImage = UIImage(data: NSData(contentsOf: bgImageURL as URL)! as Data)
            let vc = OnboardingViewController(
                backgroundImage: bgImage,
                contents: [content1, content2, content3]
            )
            
            vc?.allowSkipping = true
            vc?.skipHandler = {
                print("skip")
                //遷移
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeView = storyboard.instantiateViewController(withIdentifier: "Map")as! ViewController
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
