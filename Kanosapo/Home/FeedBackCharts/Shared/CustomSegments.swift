//
//  CustomSegments.swift
//  MyTodoList
//
//  Created by yanagimachi_riku on 2019/11/29.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import Foundation
import CoreGraphics.CGGeometry

struct CurvedSegmentForBar {
    let startPoint: CGPoint
    let endPoint: CGPoint
    let toPoint: CGPoint
    let controlPoint1: CGPoint
    let controlPoint2: CGPoint
}


struct CurvedSegmentForLine {
    var controlPoint1: CGPoint
    var controlPoint2: CGPoint
}

struct LineSegment {
    let startPoint: CGPoint
    let endPoint: CGPoint
}
