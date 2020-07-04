//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by 韩子润 on 7/2/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//



//这个文件是 MVVM 中的 VM
// view 类比 房子 model类比外头的世界 viewModel就是房子的大门 用来连接

import SwiftUI

// 不再需要这个  下面代替了
//func createCardContent(pairIndex: Int) -> String {
//    return "😂"
//}

// 用 class 的最大好处是 easy to share 因为其 lives in the heap and it has pointers to it
class EmojiMemoryGame: ObservableObject {   // ObservableObject 这个 constrain(即 protocol) 用来实现 reactive 即实时更新
    
    // private means this var can only be accessed by this class
    // none of the views can look out the door --> none of the views can see the Model anymore 这就不行了 因为view还是和model要有链接的
    // 此时 一个更伟大的 发明出现了 我们用 "private(set)"
    // 这就好比 把之前的门变成了玻璃门 只有 EmojiMemoryGame 类可以 修改modify the model but everyone else can see the model
    // private(set) var model: MemoryGame<String>    //之所以 CardContent 用 string 是因为 我们卡片上就一个 表情 Emoji 它是 String
    
    // 同时 更加优化的 不用玻璃门了 用个 门上带vedio的门 更加安全 即内部变量cards
//    private var model: MemoryGame<String> =
//        MemoryGame<String>(numberOfPairsOfCards: 2, cardContentFactory: { (pairIndex: Int) -> String in
//            return "😃"
//        })   //第二个输入的应该是一个函数
//        // inlining of functions in Swift is called a closure
    
//    private var model: MemoryGame<String> = MemoryGame<String>(numberOfPairsOfCards: 2) { _ in "😃" }
    
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()   // property wrapper 即自动 send
    
    //但是这样子会报错 we cannot use any functions on our class or struct until all of these(上面那一行) are initalized
    // 所以 变成 static 方法即可 即不是这个类的实例 istance 方法 就没事了 因为用这个方法的时候不需要新建一个实例 而是直接通过调用 Type.functionName 即可 这里的 Type 类比于 Java的 Class
    //
    static func createMemoryGame() ->  MemoryGame<String> {
        let emojis: Array<String> = ["👻", "🎃", "🕷"]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex]
         }
    }
    
    // var objectWillChange: ObservableObjectPublisher 这个变量是 ObservableObject 自动获取的 we get it for free 后面直接用就行
    
    
    
    //MARK: -Access to the model
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    //MARK: -Intent(s) 标记一下
    
    func choose(card: MemoryGame<String>.Card) {
        // objectWillChange.send() //publish to the world that it changed      但是有很多地方都需要这个  所以会有 error prone
        // 所以可以再前头用 @Published 注解 a property wrapper
        model.choose(card: card)
    }
    
    
}




