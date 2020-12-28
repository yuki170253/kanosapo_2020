//
//  EvaluViewController2.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/11/15.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit
import Cosmos
import RealmSwift
class EvaluViewController2: UIViewController {
    var index: Int = 0
    var countNum: Int = 0
    var todoListArray: [MyTodo] = []
    var myTodo: MyTodo?
    var todoid :String = ""
    let realm = try! Realm()
    var usedCount = 0

    @IBOutlet weak var pinkView: UIView!
    @IBOutlet weak var slideview: CosmosView!
    @IBOutlet weak var speech_label: UILabel!
    @IBOutlet weak var cant_label: UILabel!
    @IBOutlet weak var can_label: UILabel!
    @IBOutlet weak var menherakanojo: UIImageView!
    @IBOutlet weak var evaluButton: CustomButton!
    @IBOutlet weak var speechBubble: UIImageView!
    
    @IBOutlet weak var closeButton: CustomButton!
    
    var speech_flag = false
    var animationTimer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        autoLayout()
        var score = UserDefaults.standard.object(forKey: "score") as! Double
        if score < 25 {
            menherakanojo.image = UIImage(named:"メンヘラ_SD_100")
        }
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        speech_label.text = ""
        self.animationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.animate), userInfo: nil, repeats: true)
        
    }
    
    func autoLayout(){
        let screen = ScreenSize()
        let ratio = screen.ratio
        pinkView.frame.size = CGSize(width: pinkView.frame.size.width * ratio, height:  pinkView.frame.size.height * ratio)
        pinkView.center = self.view.center
        closeButton.frame = CGRect(x: 0, y: 0, width: closeButton.frame.size.width * ratio, height: closeButton.frame.size.height * ratio)
        speechBubble.frame = CGRect(x: 0, y: closeButton.frame.maxY, width: speechBubble.frame.size.width * ratio, height: speechBubble.frame.size.height * ratio)
        speechBubble.frame.origin.x = pinkView.frame.size.width - speechBubble.frame.size.width
        speech_label.frame.size = CGSize(width: speech_label.frame.size.width * ratio, height: speech_label.frame.size.height * ratio)
        speech_label.center = speechBubble.center
        speech_label.frame.origin = CGPoint(x: speech_label.frame.origin.x + 10 * ratio, y: speech_label.frame.origin.y - 5 * ratio)
        menherakanojo.frame = CGRect(x: 0, y: 0, width: menherakanojo.frame.size.width * ratio, height: menherakanojo.frame.size.height * ratio)
        menherakanojo.center = CGPoint(x: pinkView.frame.size.width/6, y: pinkView.frame.size.height/2)
        
        slideview.frame.size = CGSize(width: slideview.frame.size.width * ratio, height: slideview.frame.size.height * ratio)
        slideview.settings.starSize *= Double(ratio)
        slideview.center = CGPoint(x: pinkView.frame.size.width/2, y: pinkView.frame.size.height/4 * 3)
        
        cant_label.frame = CGRect(x: slideview.frame.origin.x, y: slideview.frame.maxY, width: cant_label.frame.size.width * ratio, height: cant_label.frame.size.height * ratio)
        can_label.frame = CGRect(x: 0, y: slideview.frame.maxY, width: can_label.frame.size.width * ratio, height: can_label.frame.size.height * ratio)
        can_label.frame.origin.x = slideview.frame.maxX - can_label.frame.size.width
        evaluButton.frame.size = CGSize(width: evaluButton.frame.size.width * ratio, height: evaluButton.frame.size.height * ratio)
        
        evaluButton.frame.origin.y = slideview.frame.maxY + slideview.frame.size.height/3 * 2
        evaluButton.frame.origin.x = pinkView.frame.size.width - evaluButton.frame.size.width - (pinkView.frame.size.height - evaluButton.frame.maxY)
            
        
    }

    @objc func animate() {
        UIView.animate(withDuration: 0.5) {
            if self.menherakanojo.frame.origin.y == 135.0 * ScreenSize().ratio {
                   self.menherakanojo.frame.origin.y += 10
            } else {
                   self.menherakanojo.frame.origin.y = 135.0 * ScreenSize().ratio
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentingViewController?.endAppearanceTransition()
        speech_label.numberOfLines = 3;
        speech_label.text = "集中はできたかな？\nタスクの達成度を\n教えてね♡"
        speech_label.adjustsFontSizeToFitWidth = true
        //animated_label(text: "集中はできたかな？\n現状までのタスクの達\n成度を教えてね♡")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func returnbutton(_ sender: Any) {
        self.animationTimer?.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func evalu_button(_ sender: UIButton) { //評価ボタン（ここでメンヘラメーターの値を変動させる）
        //self.speech_flag = true
        speech_label.numberOfLines = 2;
        speech_label.text = "タスクは全部終わったかな？\n教えて教えて〜♡"

        
        let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todoid)")

        var score = UserDefaults.standard.object(forKey: "score") as! Double
        var overTime:Int = 0
        var doneRate:Double = 0
        if result!.donetime > result!.dotime {
            overTime = (result!.donetime - result!.dotime) / 60
            doneRate = 1
        }else{
            doneRate = Double(result!.donetime/result!.dotime)
        }
        
        if score < 25{
            score -= Double(result!.usedCount * 5)
        }else if score < 50{
            score -= Double(result!.usedCount * 3)
        }else if score < 75{
            score -= Double(result!.usedCount)
        }else{
            
        }
        
        let rate:Double = slideview.rating
        switch rate {
            case 1.0:
                score += -15.0 - Double(result!.usedCount) + Double(overTime) * 0.1
            case 2.0:
                score += (-1.5+doneRate) * 10.0 - Double(result!.usedCount) + Double(overTime)*0.1
            case 3.0:
                score += (-0.5+doneRate) * 10.0 - Double(result!.usedCount) + Double(overTime)*0.1
            case 4.0:
                score += (0.5+doneRate) * 10.0 - Double(result!.usedCount) + Double(overTime)*0.1
            case 5.0:
                score += 15.0-Double(result!.usedCount) + Double(overTime)*0.1
        default: break
        }
        
        UserDefaults.standard.set(score, forKey: "score")
        
        try! realm.write { //ここにメンヘラメーターを変化させるような式を記述
            var donetime:Int = result!.donetime
            let countNum2 = countNum
            donetime += countNum2
            result!.donetime = donetime
            
            result!.selfEvaluation = slideview.rating
            result?.todoDone = true
            
            var usedCount2:Int = result!.usedCount
            usedCount2 = usedCount + usedCount2
            result!.usedCount = usedCount2
        }
        print("保存しました。new")
        //画面遷移の処理 以下
        self.animationTimer?.invalidate()
        let navigationVC = self.presentingViewController as! UINavigationController
        let evaluVC = navigationVC.viewControllers[1] as? EvaluViewController
        evaluVC?.trans()
        dismiss(animated: false, completion: nil)
    }

    
    func animated_label(text: String){
        speech_label.text = ""
        self.speech_flag = false //２つ目のセリフが終わった時に１つ目のセリフが途中から始まってしまうのでflagで制御
        for char in text{
            speech_label.text! += "\(char)"
            if self.speech_flag {
                //speech_label.text = ""
                print("break")
                break
            }
            RunLoop.current.run(until: Date()+0.1)
        }
        self.speech_flag = true
    }
}
