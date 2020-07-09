//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by 韩子润 on 7/7/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//



//这个文件是 MVVM 中的 VM

import SwiftUI



class EmojiArtDocument: ObservableObject {
    
    static let palette: String = "⭐️⛈🍎🌏🥨⚾️"        // pretzel 🥨 椒盐脆饼
    
    @Published private var emojiArt: EmojiArt = EmojiArt()  // start with empty EmojiArt
    
    //UIImage 带着 UI 是swiftUI 之前的版本的 被保留下来了 类比 UIColor
    @Published private(set) var backgroundImage: UIImage?     //加？变Optional 防空 nil
    
    var emojis: [EmojiArt.Emoji] { return emojiArt.emojis } //return 可省
    
    //MARK: -Intent(s)

    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    // for us to do drag and drop
    func setBackgroundURL(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        // 呼应上面的 @Published private var backgroundImage: UIImage?
        // how are we gonna to fecth the backgroundImage and create an UIImage from this url
        fetchBackgroundImageData()
    }
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil// set current to nil
        if let url = self.emojiArt.backgroundURL {  //非空才做
            // 这里可能用时 几秒 几分钟。。。 during this 我们所有的程序都等 这是我们所不能允许发生的！！！！！！ 所以要多线程分配 dispatch
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) { // 这里可能用时 几秒 几分钟。。。
                    DispatchQueue.main.async {  //放回主线程 因为要draw
                        if url == self.emojiArt.backgroundURL { //防止多次拖拽覆盖
                            self.backgroundImage = UIImage(data: imageData) //这里涉及UI渲染 不能放在background线程里 会crash
                        }
                    }
                }
            }
            
        }
    }
}

// make it for us to don't need to deal with Int ever in our View
// 写在 VM 里 是因为 它就是做一个 解释 Model（EmojiArt） 的作用
extension EmojiArt.Emoji {
    var fontSize: CGFloat{ CGFloat(self.size)}
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y))}
}
























