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

    @IBOutlet weak var slideview: CosmosView!
    @IBOutlet weak var speech_label: UILabel!
    @IBOutlet weak var cant_label: UILabel!
    @IBOutlet weak var can_label: UILabel!
    @IBOutlet weak var menherakanojo: UIImageView!

    var speech_flag = false
    var animationTimer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        speech_label.text = ""
        self.animationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.animate), userInfo: nil, repeats: true)
    }

    @objc func animate() {
        UIView.animate(withDuration: 0.5) {
            if self.menherakanojo.frame.origin.y == 135.0 {
                   self.menherakanojo.frame.origin.y += 10
            } else {
                   self.menherakanojo.frame.origin.y = 135.0
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentingViewController?.endAppearanceTransition()
        speech_label.numberOfLines = 3;
        speech_label.text = "集中はできたかな？\n現状までのタスクの達\n成度を教えてね♡"
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
                score += -15.0 + Double(overTime) * 0.1
            case 2.0:
                score += (-1.5+doneRate) * 10.0 + Double(overTime)*0.1
            case 3.0:
                score += (-0.5+doneRate) * 10.0 + Double(overTime)*0.1
            case 4.0:
                score += (0.5+doneRate) * 10.0 + Double(overTime)*0.1
            case 5.0:
                score += 15.0 + Double(overTime)*0.1
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
            
            let calendars = result?.calendars
            for item in calendars!{
                item.todoDone = true
            }
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
