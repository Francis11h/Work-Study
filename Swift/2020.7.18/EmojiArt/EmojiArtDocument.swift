//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by 韩子润 on 7/7/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//



//这个文件是 MVVM 中的 VM

import SwiftUI
import Combine          // 含有AnyCancellable publishing subscribing


class EmojiArtDocument: ObservableObject {
    
    static let palette: String = "⭐️⛈🍎🌏🥨⚾️"        // pretzel 🥨 椒盐脆饼
    
    @Published private var emojiArt: EmojiArt
    
//    不用@Published的替代办法 如下   // workaround 解决方法 for property observer problem with property wrappers
//    private var emojiArt: EmojiArt {    // start with empty EmojiArt
//        willSet {   // 用来代替 @Published
//            objectWillChange.send()
//        }
//        didSet {
//            // print("json = \(emojiArt.json?.utf8 ?? "nil")")  // ? 可能为nil utf8 是基本都用这个
//            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
//        }
//    }
    
    private static let untitled = "EmojiArtDocument.Untitled"
    
    private var autoSaveCancellable: AnyCancellable?
    
    init() {
        // 后面的 ?? 代表可能为空
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        autoSaveCancellable = $emojiArt.sink { emojiArt in
            print("json = \(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
        }
        fetchBackgroundImageData()
    }
    
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
    var backgroundURL: URL? {
        get {
            emojiArt.backgroundURL
        }
        set {
            emojiArt.backgroundURL = newValue?.imageURL
           // 呼应上面的 @Published private var backgroundImage: UIImage?
           // how are we gonna to fecth the backgroundImage and create an UIImage from this url
           fetchBackgroundImageData()
        }
    }
    
    private var fetchImageCancellable: AnyCancellable?
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = self.emojiArt.backgroundURL {
             fetchImageCancellable?.cancel()
             fetchImageCancellable = URLSession.shared.dataTaskPublisher(for: url)      //相比下面 挪到 一行上来
                 .map{ data, URLResponse in UIImage(data: data)}
                 .receive(on: DispatchQueue.main)
                 .replaceError(with: nil).assign(to: \.backgroundImage, on: self)
        }
    }
    
//    private func fetchBackgroundImageData() {
//       backgroundImage = nil
//       if let url = self.emojiArt.backgroundURL {
//            fetchImageCancellable?.cancel()                     //只有当这个取消了 后面才做
//            let session = URLSession.shared
//            let publisher = session.dataTaskPublisher(for: url)     // get thing from where ： dataTaskPublisher
//                .map{ data, URLResponse in UIImage(data: data)}     // eliminate URLError
//                .receive(on: DispatchQueue.main)                    // publish it on the mainn queue
//                .replaceError(with: nil)                            // change the error type to Never
//
//            fetchImageCancellable = publisher.assign(to: \.backgroundImage, on: self)       // to: + key path
//       }
//   }
    
//    不用 URL session 的做法
//    private func fetchBackgroundImageData() {
//        backgroundImage = nil// set current to nil
//        if let url = self.emojiArt.backgroundURL {  //非空才做
//            // 这里可能用时 几秒 几分钟。。。 during this 我们所有的程序都等 这是我们所不能允许发生的！！！！！！ 所以要多线程分配 dispatch
//            DispatchQueue.global(qos: .userInitiated).async {
//                if let imageData = try? Data(contentsOf: url) { // 这里可能用时 几秒 几分钟。。。
//                    DispatchQueue.main.async {  //放回主线程 因为要draw
//                        if url == self.emojiArt.backgroundURL { //防止多次拖拽覆盖
//                            self.backgroundImage = UIImage(data: imageData) //这里涉及UI渲染 不能放在background线程里 会crash
//                        }
//                    }
//                }
//            }
//
//        }
//    }
}

// make it for us to don't need to deal with Int ever in our View
// 写在 VM 里 是因为 它就是做一个 解释 Model（EmojiArt） 的作用
extension EmojiArt.Emoji {
    var fontSize: CGFloat{ CGFloat(self.size)}
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y))}
}
























