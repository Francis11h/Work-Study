//
//  MemoryGame.swift
//  Memorize
//
//  Created by 韩子润 on 7/2/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//

import Foundation

// Foundation 里面含有Array Dictonary String Int Bool 等等数据类型


struct MemoryGame<CardContent> { //后面不再有 : View 因为他是个 non-UI thing
    var cards: Array<Card>
    
    // 得有方法 almost all arguments to all functions have a label
    func choose(card: Card) {
        print("card chosen: \(card)")   //   \()  相当于别的语言的 %s
    }
    
    // func init 的简写
    // 再来一个参数 该参数是个 function 是为了在 EmojiMemoryGame 中输入 CardContent,  Int 对应 pairIndex
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()   // ()不带参数 代表 空数组
        
        for pairIndex in 0..<numberOfPairsOfCards {
            // content的类型声明可以简写 let content: CardContent = cardContentFactory(pairIndex)
            let content = cardContentFactory(pairIndex)     // 用 let 表示常量 不会变的 用var会有 warning
            cards.append(Card(isFaceUp: false, isMatched: false, content: content))
            cards.append(Card(isFaceUp: false, isMatched: false, content: content))
            
        }
    }
    
    
    
    // nesting struct,  MemoryGame.Card
    struct Card {
        var isFaceUp: Bool
        var isMatched: Bool
        //var content: ??? // 　卡片上的东西 该用什么类型呢
        
        var content: CardContent    // 这里的 CardContent 目前我们不关心 用的时候上头输入一种特定的类型即可 这是一种很棒的写法
        
    }
}


