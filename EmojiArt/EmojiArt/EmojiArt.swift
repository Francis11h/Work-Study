//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by 韩子润 on 7/8/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//


// Model


import Foundation

struct EmojiArt {
    var backgroundURL: URL?     // this URL is a Swift library struct
    var emojis = [Emoji]()
    
    struct Emoji: Identifiable {
        let text: String
        var x: Int          // offset from the center (in the middle) but in ios coordinate system center is upper left so we need to convert them to fit this
        var y: Int
        var size: Int
        // var id: UUID    // universe unique identifier  which is overkill
        let id: Int
        
        // fileprivate 这个函数 只对这个file可见 外头的都改不了 
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId))
    }
}
