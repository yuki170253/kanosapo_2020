//
//  ConfirmationTableViewCell.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/11/09.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit

class ConfirmationTableViewCell: UITableViewCell {

    var values:Double?
    
    var valueOfAchievement:Double?

    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    @IBOutlet var percentageLabel: UILabel!
    @IBOutlet var taskNameLabel: UILabel!
    @IBOutlet var averageLabel: UILabel!
    @IBOutlet var averageDataLabel: UILabel!
    
    @IBOutlet var menheraPic: UIImageView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        
        values = valueOfAchievement!/100.0
            
            var percent:Double = 0
            
            var stopPercentageProgress: Bool = true
            
            DispatchQueue.global().async {
                while stopPercentageProgress{
                    if self.values! <= 25{
                        Thread.sleep(forTimeInterval: 0.05)
                    }else if self.values! <= 50{
                        Thread.sleep(forTimeInterval: 0.03)
                    }else if self.values! <= 75{
                        Thread.sleep(forTimeInterval: 0.025)
                    }else{
                        Thread.sleep(forTimeInterval: 0.015)
                    }
                    DispatchQueue.main.async {
                        self.percentageLabel.text = "\(String(Int(percent)) + "%")"
                        if percent > self.values!*100.0{
                            print(percent)
                            
                            stopPercentageProgress = false
                        }else{
                            print(percent)
                            percent += 1
                        }
                    }
                }
            }
            animateCircle()
    }
}


extension ConfirmationTableViewCell{
    
    func trackLayerValue(){
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 70, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        
        trackLayer.lineWidth = 20
        
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.position = CGPoint(x: 270, y: 200)
        
        
        self.layer.addSublayer(trackLayer)
        
    }
    
    
    func shapeLayerValue(){
        let circularPath2 = UIBezierPath(arcCenter: .zero, radius: 70, startAngle: 0, endAngle: (2*CGFloat.pi) * CGFloat(valueOfAchievement!/100.0), clockwise: true)
        
            shapeLayer.path = circularPath2.cgPath
            
            shapeLayer.strokeColor = UIColor.red.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            
            shapeLayer.lineWidth = 20
            
            shapeLayer.lineCap = CAShapeLayerLineCap.round
            shapeLayer.position = CGPoint(x: 270, y: 200)
            
            
            shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
            
            shapeLayer.strokeEnd = 0
            
            self.layer.addSublayer(shapeLayer)
        
        }
}
