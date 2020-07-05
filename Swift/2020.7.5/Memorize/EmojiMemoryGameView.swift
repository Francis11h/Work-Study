//
//  ContentView.swift
// EmojiMemoryGameView.swift
//  Memorize
//
//  Created by 韩子润 on 5/25/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    //@ObservedObject   when it seens this viewModel publishing, it redraws the view
    @ObservedObject var viewModel: EmojiMemoryGame  //这个要跟 ContentView 一起创建, 在 boilerplate（样板）中的 SceneDelegate 中
    
    var body: some View {
        // viewModel.cards is an array, which is an identifiable things
        // grid combine HStack with For each  二合一 另一个文件里写 Swift不提供
        Grid(viewModel.cards) { card in      // 最后一个 参数 本来该是 ItemView:  { card in ... 但是可以省略
            CardView(card: card).onTapGesture {
                self.viewModel.choose(card: card)        //第二个 card 是上面那个 in 之前的 card
                // 这里的 self. 是必加的 后面解释
            }
            .padding(5)  //让每个卡片 分隔一下 即 填充一下东西在每个卡片的周围
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
    private func body(for size: CGSize) -> some View {
        ZStack() {
                if self.card.isFaceUp {
                    RoundedRectangle(cornerRadius: self.cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: self.cornerRadius).stroke(lineWidth: self.edgeLineWidth)
                    //stroke = 擦除 = 由黑变白
                    Text(self.card.content)
                } else {
                    if !card.isMatched {    // match的话 直接就消失了！
                        RoundedRectangle(cornerRadius: 10.0).fill(Color.orange)
                    }
                    
                }
                
            }
                .font(Font.system(size: fontSize(for: size)))  // make the emoji 更符合
    }
    
    // MARK: -Drawing Constants
    
    // 用专业的名字 去替换上面单纯的数字
    private let cornerRadius: CGFloat = 10.0  //  option + click   出来的是 Double类型 但是 上头的 RoundedRectangle 里的 都是 CGFloat类型 所以转换一下
    private let edgeLineWidth: CGFloat = 3
    private let fontScaleFactor: CGFloat = 0.75
    
    // 优化上面 提出部分 .font 里的代码
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}



