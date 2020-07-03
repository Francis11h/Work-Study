//
//  ContentView.swift
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

struct ContentView: View {
    var viewModel: EmojiMemoryGame  //这个要跟 ContentView 一起创建, 在 boilerplate（样板）中的 SceneDelegate 中
    
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
           .font(Font.largeTitle)  // make the emoji larger
    }
}


struct CardView: View {
    
    var card: MemoryGame<String>.Card
    
//    var isFaceUp: Bool
    
    var body: some View {
        ZStack() {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                //stroke = 擦除 = 由黑变白
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.orange)
            }
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
    }
}



