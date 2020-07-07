//
//  ContentView.swift
// EmojiMemoryGameView.swift
//  Memorize
//
//  Created by 韩子润 on 5/25/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//

//这个文件是 MVVM 中的 V View

import SwiftUI

struct EmojiMemoryGameView: View {
    //@ObservedObject   when it seens this viewModel publishing, it redraws the view
    @ObservedObject var viewModel: EmojiMemoryGame  //这个要跟 ContentView 一起创建, 在 boilerplate（样板）中的 SceneDelegate 中
    
    var body: some View {
        VStack {
            // viewModel.cards is an array, which is an identifiable things
            // grid combine HStack with For each  二合一 另一个文件里写 Swift不提供
            Grid(viewModel.cards) { card in      // 最后一个 参数 本来该是 ItemView:  { card in ... 但是可以省略
                CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration: 0.75)) {
                        self.viewModel.choose(card: card)        //第二个 card 是上面那个 in 之前的 card
                    }
                }
                .padding(5)  //让每个卡片 分隔一下 即 填充一下东西在每个卡片的周围
            }
                .padding()
                .foregroundColor(Color.orange) // put modifiers for these combiner Views on a line by themselves
            //最底下加个按钮
            Button(action: {
                withAnimation(.easeInOut) { // 等于简写 withAnimation(Animation.easeOut)
                    self.viewModel.resetGame()
                }
            }, label: { Text("New Game")})
        }
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
    
    @State private var animatedBonusRemaining: Double = 0           //Synced up
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    // 写一个辅助函数来时代码更可读 某种东西的 size 输出 某种 view
    // for 是外部名字 size 是内部
    @ViewBuilder    //这个 就把这个func 认为成了 a list of Views 最后就可自动返回 EmptyView
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack() {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(-animatedBonusRemaining * 360 - 90), clockwise: true)
                            .onAppear {  // call this closure（大括号里面的） anytime this View appears on screen =
                                self.startBonusTimeAnimation()   // 每次这个pie一出现 我们要reset animatedBonusRemaining to be what's in the Model
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(-card.bonusRemaining * 360 - 90), clockwise: true)
                    }
                }
                .padding(5).opacity(0.4)  //paddig 是在圆周边填充一些 不让其紧挨着边框
                .transition(.identity)  // .identity Pie出现的时候是本身 .scale Pie出现的时候放大一下
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))  // make the emoji 更符合
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)    // implicit animations
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)    //过渡 当match时 缩放
        }
    }
    
    // MARK: -Drawing Constants
    

    
    // 优化上面 提出部分 .font 里的代码
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])    //为了 preview 一下第一张牌 这里就方便调试 不用每次再run了
        return EmojiMemoryGameView(viewModel: game)
    }
}



