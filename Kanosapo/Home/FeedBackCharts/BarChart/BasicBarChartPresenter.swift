//
//  BasicBarChartPresenter.swift
//  MyTodoList
//
//  Created by yanagimachi_riku on 2019/11/29.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import Foundation
import CoreGraphics.CGGeometry

class BasicBarChartPresenter {
    let barWidth: CGFloat
    let space: CGFloat
    
    /// Reserved space to show text below each bar
    private let bottomSpace: CGFloat = 40.0
    /// Reserved space to show value (or height) of the bar
    private let topSpace: CGFloat = 100
    
    var dataEntries: [DataEntry] = []
    
    init(barWidth: CGFloat = 140, space: CGFloat = -70) {
        self.barWidth = barWidth
        self.space = space
    }
    
    func computeContentWidth() -> CGFloat {
        return (barWidth) * CGFloat(dataEntries.count + 1)/2
    }
    
    func computeBarEntries(viewHeight: CGFloat) -> [BasicBarEntry] {
        var result: [BasicBarEntry] = []
        
        for (index, entry) in dataEntries.enumerated() {
            let entryHeight = CGFloat(entry.height) * (viewHeight - bottomSpace - topSpace)
            let xPosition: CGFloat = CGFloat(index) * (barWidth + space)
            let yPosition = viewHeight - bottomSpace - entryHeight
            
            let barEntry = BasicBarEntry(origin: CGPoint(x: xPosition, y: yPosition), barWidth: barWidth, barHeight: entryHeight, data: entry)
            
            result.append(barEntry)
        }
        
        return result
    }
}
