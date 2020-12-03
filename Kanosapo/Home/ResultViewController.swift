//
//  ResultViewController.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/11/14.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit
import RealmSwift

class ResultViewController: UIViewController {

    var values:Double?
    
    var valueOfAchievement:Double?
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    @IBOutlet var percentageLabel: UILabel!
    @IBOutlet var taskNameLabel: UILabel!
    @IBOutlet var taskDate: UILabel!
    
    @IBOutlet var menheraImage: UIImageView!
    
    var toDoId: String?
    
    var index: Int = 0
    var countNum: Int = 0
    var myTodo: MyTodo?
    var sepatime: [Int] = []
    //var evaluation: [Double] = []
    var evaluation: Int = 0
    var x: Double = 0
    var rate: Double = 0
    var dotime: Int = 0
    var todotitle: String = ""
    var todoListArray:[MyTodo] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        print("ResultViewControllerに遷移")
        let realm = try! Realm()
        let myTodos = realm.objects(Todo.self)
        for myTodo in myTodos{
            
            if toDoId == myTodo.todoid{
                print("OkBooooooooooooy")
                if myTodo.date != nil{
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM-dd"
                    taskDate.text = df.string(from: myTodo.date!)
                }else{
                    taskDate.text = "時間指定なし"
                }

                evaluation = myTodo.rate
                dotime = myTodo.dotime
                todotitle = myTodo.title
                
                taskNameLabel.text = myTodo.title
                valueOfAchievement = Double(evaluation)
                trackLayerValue()
                shapeLayerValue()
                loadGraph()
            }else{
                print("終わってないみたい")
            }
        }
    }
    
    @IBAction func transbutton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        //dismiss(animated: false, completion: nil)
    }
    
    
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    
    @objc func loadGraph(){
        print("Attempting to animate stroke")
            
            var percent:Double = 0
            
            var stopPercentageProgress: Bool = true
            
            DispatchQueue.global().async {
                while stopPercentageProgress{
                    if self.valueOfAchievement! <= 25{
                        print("25以下だよ")
                        Thread.sleep(forTimeInterval: 0.05)
                    }else if self.valueOfAchievement! <= 50{
                        print("50以下だよ")
                        Thread.sleep(forTimeInterval: 0.03)
                    }else if self.valueOfAchievement! <= 75{
                        print("75以下だよ")
                        Thread.sleep(forTimeInterval: 0.025)
                    }else{
                        print("100以下だよ")
                        Thread.sleep(forTimeInterval: 0.015)
                    }
                    DispatchQueue.main.async {
                        self.percentageLabel.text = "\(String(Int(self.valueOfAchievement!)) + "点")"
                        if percent > self.valueOfAchievement!{
                            stopPercentageProgress = false
                        }else{
                            percent += 1
                        }
                    }
                }
            }
            animateCircle()
    }
}



extension ResultViewController{
    
    func trackLayerValue(){
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        
        trackLayer.lineWidth = 28
        
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.position = CGPoint(x: 187.5, y: 270)
        
        
        self.view.layer.addSublayer(trackLayer)
    }
    
    
    func shapeLayerValue(){
        let circularPath2 = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: (2*CGFloat.pi) * CGFloat(valueOfAchievement!/100.0), clockwise: true)
        
            shapeLayer.path = circularPath2.cgPath
            
            shapeLayer.strokeColor = UIColor.systemPink.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            
            shapeLayer.lineWidth = 28
            
            shapeLayer.lineCap = CAShapeLayerLineCap.round
            shapeLayer.position = CGPoint(x: 187.5, y: 270)
            
            shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
            
            shapeLayer.strokeEnd = 0
            
            self.view.layer.addSublayer(shapeLayer)
        }
}
