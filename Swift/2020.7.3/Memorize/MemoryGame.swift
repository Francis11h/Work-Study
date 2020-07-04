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
    
    
    // mutating 自我变异的  即struct中 可以修改自身属性的 func
    // all functions that modify self have to be marked mutating in a struct (this is not true in a Class beacuse Class is in the heap 所以class不需要这种)
    mutating func choose(card: Card) {
        print("card chosen: \(card)")   //   \()  相当于别的语言的 %s
        
        // card.isFaceUp = !card.isFaceUp  //通过这么写 来实现 翻牌toggled 是有问题的
        // 首先 choose(card: Card) 中 choose(let card: Card) 前面那个 是 let 不可变得
        // 更甚至 最重要的 Card 是个 struct， 这是一个 value type 不是 reference 就是每次都会被复制 is copied every time when it's passed as a parameter to a function or even assign to another variable
        
        let chosenIndex: Int = self.index(of: card) // index 是个 函数   card 是 func choose(card: Card) 中选中的 card
        self.cards[chosenIndex].isFaceUp = !self.cards[chosenIndex].isFaceUp
    }
    
    func index(of card: Card) -> Int {  // 这个 of 是 外部external的名字 card 是内部internal的名字  是为了方便外部的调用起的 别名
        for index in 0..<self.cards.count {
            if self.cards[index].id == card.id {
                return index
            }
        }
        return 0 // TODO: bogus虚假的!
    }
    
    // func init 的简写
    // 再来一个参数 该参数是个 function 是为了在 EmojiMemoryGame 中输入 CardContent,  Int 对应 pairIndex
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()   // ()不带参数 代表 空数组
        
        for pairIndex in 0..<numberOfPairsOfCards {
            // content的类型声明可以简写 let content: CardContent = cardContentFactory(pairIndex)
            let content = cardContentFactory(pairIndex)     // 用 let 表示常量 不会变的 用var会有 warning
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
            
        }
    }
    
    
    
    // nesting struct,  MemoryGame.Card
    struct Card: Identifiable{          //Identifiable 是 swift 提供的 可以建立唯一标识的 formalism， 他是一种 protocol
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        //var content: ??? // 　卡片上的东西 该用什么类型呢
        
        var content: CardContent    // 这里的 CardContent 目前我们不关心 用的时候上头输入一种特定的类型即可 这是一种很棒的写法
        var id: Int         //这里就是id 唯一标识 对应上面的 Identifiable
    }
}


