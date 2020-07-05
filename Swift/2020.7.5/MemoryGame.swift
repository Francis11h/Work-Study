//
//  MemoryGame.swift
//  Memorize
//
//  Created by 韩子润 on 7/2/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//

import Foundation

// Foundation 里面含有Array Dictonary String Int Bool 等等数据类型

// where CardContent: Equatable 只有当这个 CardContent类型 实现了 == 比较的时候 才可以

struct MemoryGame<CardContent> where CardContent: Equatable{ //后面不再有 : View 因为他是个 non-UI thing
    private(set) var cards: Array<Card>     //access control
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?  {  //是Optional 的原因是 可能有 0 1 2 个 卡牌被翻面 / = nil 可以不写 系统默认Optional初始为nill
        
        get {
            
//            var faceUpCardIndices = [Int]() // 和这个一样 Array<Int>()
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    faceUpCardIndices.append(index)
//                }
//            }
//            if faceUpCardIndices.count == 1 {
//                return faceUpCardIndices.first //与 这个 faceUpCardIndices[0] 一样
//            } else {
//                return nil
//            }
            
            // filter 返回在某个范围内的一个Int数组 [Int]
            // var faceUpCardIndices =  cards.indices.filter { (index) -> Bool in
            //     return cards[index].isFaceUp
            // }
            // 上面注释的简化
            // var faceUpCardIndices =  cards.indices.filter { index in cards[index].isFaceUp }
            
            //  再简化 $0 for the first element  所有朝上的卡牌数组
            
            cards.indices.filter { cards[$0].isFaceUp }.only
            
//            if faceUpCardIndices.count == 1 {
//                return faceUpCardIndices.first //与 这个 faceUpCardIndices[0] 一样
//            } else {
//                return nil
//            }
        }
        
        set {
            for index in cards.indices {
                //newValue 是 set 方法自带的一个属性  //it is whatever the people set this(indexOfTheOneAndOnlyFaceUpCard) to
                cards[index].isFaceUp = index == newValue   // 不用再写 if else 了 这样子
//                if index == newValue {
//                    cards[index].isFaceUp = true
//                } else {
//                    cards[index].isFaceUp = false
//                }
            }
        }
    }
    
    mutating func choose(card: Card) {
        print("card chosen: \(card)")   //   \()  相当于别的语言的 %s
       
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                self.cards[chosenIndex].isFaceUp = true
                // indexOfTheOneAndOnlyFaceUpCard = nil 不需要了 因为上头如果不是一张的 每次都赋值为nil
            } else {
                // 不用把其他所有的 翻面了
//                for index in cards.indices {
//                    cards[index].isFaceUp = false
//                }
                
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex    //  这里会被 set 自动设置
            }
        }
    }
    
    
    
//    mutating func choose(card: Card) {
//        print("card chosen: \(card)")   //   \()  相当于别的语言的 %s
//        // 这里加 if 是 为了对 Optional unwrap
//        // ,  逗号等于 sequential and   顺序与
//        // 即 先做 let chosenIndex = cards.firstIndex(matching: card) 然后再做 !cards[chosenIndex].isFaceUp
//        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
//            //have a match
//            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
//                if cards[chosenIndex].content == cards[potentialMatchIndex].content { // not every type has == 所以前面要限制
//                    cards[chosenIndex].isMatched = true
//                    cards[potentialMatchIndex].isMatched = true
//                }
//                // 不管match 与否 现在都有两张卡翻过来了 那就设为nil
//                indexOfTheOneAndOnlyFaceUpCard = nil
//            } else {    //如果有 0 或者 大于1 数量的翻过来 就全翻过去
//                for index in cards.indices {    //indices index的复数
//                    cards[index].isFaceUp = false
//                }
//                //更新这个
//                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
//            }
//            // 一次翻牌翻的那一张
//            self.cards[chosenIndex].isFaceUp = true
//        }
//    }
    
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
    // 按理说 Card 也应该 private 但是 从外部获取Card的唯一方式 就是通过我们上面的。private Array 所以就避免了
    struct Card: Identifiable{          //Identifiable 是 swift 提供的 可以建立唯一标识的 formalism， 他是一种 protocol
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        //var content: ??? // 　卡片上的东西 该用什么类型呢
        
        var content: CardContent    // 这里的 CardContent 目前我们不关心 用的时候上头输入一种特定的类型即可 这是一种很棒的写法
        var id: Int         //这里就是id 唯一标识 对应上面的 Identifiable
    }
}


