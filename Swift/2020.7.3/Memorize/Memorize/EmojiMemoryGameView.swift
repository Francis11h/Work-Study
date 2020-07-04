//
//  ContentView.swift
// EmojiMemoryGameView.swift
//  Memorize
//
//  Created by 韩子润 on 5/25/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
//        //return was left out by Swift. fot one-liner
//        Text("Hello There, World!")
//    }
//}

//-------------------------------------------------------------------------------

//struct ContentView: View {
//    var body: some View {
//        return ZStack(content: {
//            RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
//            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
//            //stroke = 擦除 = 由黑变白
//            Text("👻")
//        })
//            .padding()
//            .foregroundColor(Color.orange) // put modifiers for these combiner Views on a line by themselves
//            .font(Font.largeTitle)  // make the emoji larger
//    }
//}




//-------------------------------------------------------------------------------
//struct ContentView: View {
//    var body: some View {
//        return ForEach(0..<4, content: { index in
//           ZStack(content: {
//               RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
//               RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
//               //stroke = 擦除 = 由黑变白
//               Text("👻")
//           })
//        })
//               .padding()
//               .foregroundColor(Color.orange) // put modifiers for these combiner Views on a line by themselves
//               .font(Font.largeTitle)  // make the emoji larger
//    }
//}
// 0..<4 代表 0到4 不包含4 即--->  0-3



//-------------------------------------------------------------------------------
//ZStack arranges things from back to ground
//HStack arranges things horizontally





//-------------------------------------------------------------------------------
//struct ContentView: View {
//    var body: some View {
//        HStack (content: {
//            ForEach(0..<4, content: { index in
//               ZStack(content: {
//                   RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
//                   RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
//                   //stroke = 擦除 = 由黑变白
//                   Text("👻")
//               })
//            })
//        })
//           .padding()
//           .foregroundColor(Color.orange) // put modifiers for these combiner Views on a line by themselves
//           .font(Font.largeTitle)  // make the emoji larger
//    }
//}



//-------------------------------------------------------------------------------
// 可以把 小括号 都放到一起 进行 简化/干净的写法

//struct ContentView: View {
//    var body: some View {
//        HStack() {
//            ForEach(0..<4) { index in
//               ZStack() {
//                   RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
//                   RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
//                   //stroke = 擦除 = 由黑变白
//                   Text("👻")
//               }
//            }
//        }
//           .padding()
//           .foregroundColor(Color.orange) // put modifiers for these combiner Views on a line by themselves
//           .font(Font.largeTitle)  // make the emoji larger
//    }
//}



//-------------------------------------------------------------------------------
// 更加优化的写法 之 封装 encapsulation

struct EmojiMemoryGameView: View {
    //@ObservedObject   when it seens this viewModel publishing, it redraws the view
    @ObservedObject var viewModel: EmojiMemoryGame  //这个要跟 ContentView 一起创建, 在 boilerplate（样板）中的 SceneDelegate 中
    
    var body: some View {
        HStack() {
            ForEach(viewModel.cards) { card in      // for each through these cards in this array
                CardView(card: card).onTapGesture {
                    self.viewModel.choose(card: card)        //第二个 card 是上面那个 in 之前的 card
                    // 这里的 self. 是必加的 后面解释
                }
            }
        }
           .padding()
           .foregroundColor(Color.orange) // put modifiers for these combiner Views on a line by themselves
    }
}


struct CardView: View {
    
    var card: MemoryGame<String>.Card
    
//    var isFaceUp: Bool
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
        
    }
    
    // 写一个辅助函数来时代码更可读 某种东西的 size 输出 某种 view
    // for 是外部名字 size 是内部
    func body(for size: CGSize) -> some View {
        ZStack() {
                if self.card.isFaceUp {
                    RoundedRectangle(cornerRadius: self.cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: self.cornerRadius).stroke(lineWidth: self.edgeLineWidth)
                    //stroke = 擦除 = 由黑变白
                    Text(self.card.content)
                } else {
                    RoundedRectangle(cornerRadius: 10.0).fill(Color.orange)
                }
                
            }
                .font(Font.system(size: fontSize(for: size)))  // make the emoji 更符合
    }
    
    // MARK: -Drawing Constants
    
    // 用专业的名字 去替换上面单纯的数字
    let cornerRadius: CGFloat = 10.0  //  option + click   出来的是 Double类型 但是 上头的 RoundedRectangle 里的 都是 CGFloat类型 所以转换一下
    let edgeLineWidth: CGFloat = 3
    let fontScaleFactor: CGFloat = 0.75
    
    // 优化上面 提出部分 .font 里的代码
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}



