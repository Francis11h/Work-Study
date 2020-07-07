//
//  Cardify.swift
//  Memorize
//
//  Created by 韩子润 on 7/5/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier {  // = ViewModifier + Animatable
    var rotation: Double
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180       // 初始化为 0 或者 180
    }
    var isFaceUp: Bool {        // the faceup is always tracking the rotation
        rotation < 90   //isFaceUp 会随着 rotation改变  其小于90度 就是正面
    }
    
    var animatableData: Double {    // this Double is our rotation 相当于把rotation 重命名为animatableData 系统才能找得到
        get { return rotation}
        set { rotation = newValue}
    }
    
    func body(content: Content) -> some View {
        ZStack {
            // 为什么 后来matched的卡片不旋转 因为它被展示出来的时候 已经是 isFaceUp & isMatche 的了 而不是后来变成isMatche的
            // 而Animation 只能 模拟变化的过程 所以会有这个问题: 咋么解决 --> opacity 即 hide something 而不是 if-then 直接让东西 disappear 而是hide 藏起来
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            }
                .opacity(isFaceUp ? 1 : 0)  // 1 = opaque 0 = transparent = hide
            
            RoundedRectangle(cornerRadius: cornerRadius).fill(Color.orange)
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))       //用 rotation代替 card.isFaceUp ? 180 : 0

    }
    
    // 用专业的名字 去替换上面单纯的数字
    private let cornerRadius: CGFloat = 10.0  //  option + click   出来的是 Double类型 但是 上头的 RoundedRectangle 里的 都是 CGFloat类型 所以转换一下
    private let edgeLineWidth: CGFloat = 3
//    private let fontScaleFactor: CGFloat = 0.7
}



extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
