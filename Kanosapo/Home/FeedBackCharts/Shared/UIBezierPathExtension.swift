//
//  UIBezierPathExtension.swift
//  MyTodoList
//
//  Created by yanagimachi_riku on 2019/11/29.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit

extension UIBezierPath {
    convenience init(curvedSegment: CurvedSegmentForBar) {
        self.init()
        self.move(to: curvedSegment.startPoint)
        self.addCurve(to: curvedSegment.toPoint, controlPoint1: curvedSegment.controlPoint1, controlPoint2: curvedSegment.controlPoint2)
        self.addLine(to: curvedSegment.endPoint)
    }
    
    convenience init(lineSegment: LineSegment) {
        self.init()
        self.move(to: lineSegment.startPoint)
        self.addLine(to: lineSegment.endPoint)
    }
}
