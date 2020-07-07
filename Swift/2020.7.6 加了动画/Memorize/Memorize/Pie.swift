//
//  Pie.swift
//  Memorize
//
//  Created by 韩子润 on 7/5/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//

import SwiftUI


// CG stands for Core Graphic


struct Pie: Shape {
    var startAngle : Angle
    var endAngle: Angle
    var clockwise: Bool = false //
    
    var animatableData: AnimatablePair<Double, Double> {        // Shape 前面 都不用声明 Animatable 自带的  //Pair： animate two things at once
        get {
            AnimatablePair(startAngle.radians,endAngle.radians)  //radians 弧度
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    //画一条路径
    func path (in rect: CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint (
            x: center.x + radius * cos(CGFloat(startAngle.radians)),    //radians 弧度
            y: center.y + radius * sin(CGFloat(startAngle.radians))
        )
        
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 clockwise: clockwise)
        p.addLine(to: center)
        return p
    }
}
