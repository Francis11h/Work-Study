//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by 韩子润 on 7/7/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//

// View

import SwiftUI

struct EmojiArtDocumentView: View {
    
    @ObservedObject var document: EmojiArtDocument  //document = ViewModel
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {   //能让里面的内容 水平滑动
                HStack {
                    // use map to convert string to string array by extracting every character
                    // \.self is key path in Swift, \ 代表这是个 key path . 代表左边那一串 self 代表每个1字符自己
                    ForEach(EmojiArtDocument.palette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: self.defaultEmojiSize))
                            .onDrag { return  NSItemProvider(object: emoji as NSString) }   // NS都是 Objective-C的代码
                    }
                }
            }
            .padding(.horizontal)
            GeometryReader { geometry in
                ZStack {
                    // 1. took a white 长方形 2. overlaid image on top of it  不直接用ZStack 是因为我们要考虑 sizeing 所以overlay
                    // Rectangle().foregroundColor(.white).overlay(Image(self.document.backgroundImage))
                    // 可以直接写 Color， Color can be a View and can be ShapeStyle
                    Color.white.overlay( // 这里后面要接收的 是一个 View 而不是一个 if-statement 所以要用 Group 封装 使其变为 ViewBuilder
                        OptionalImage(uiImage: self.document.backgroundImage)    // 封装到 另一个文件了 OptionalImage
                            .scaleEffect(self.zoomScale)
                            .offset(self.panOffset)
                    )
                        .gesture(self.doubleTapToZoom(in: geometry.size))
                    ForEach(self.document.emojis) { emoji in
                        Text(emoji.text)
                            .font(animatableWithSize: emoji.fontSize * self.zoomScale)
                            .position(self.position(for: emoji, in: geometry.size))
                    }
                }
                .clipped()          // 修剪   以上部分将被裁剪到视图的边界
                .gesture(self.panGesture())
                .gesture(self.zoomGesture())
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                //拉取图片的 URL 并设置到 Model （EmojiArt）
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                     // convert from global coordinate sys to our view ios coordinate sys
                    var location = geometry.convert(location, from: .global)
                    // convert from ios coord to EmojiArt offset
                    location = CGPoint(x: location.x - geometry.size.width / 2, y: location.y - geometry.size.height / 2)
                    location = CGPoint(x: location.x - self.panOffset.width, y: location.y - self.panOffset.height)
                    location = CGPoint(x: location.x / self.zoomScale, y: location.y / self.zoomScale)
                    // return whether the drop succeeded
                    return self.drop(providers: providers, at: location)
                }
            }
        }
    }
    
    //  it only going to affect the way our  View looks, this has nothing to do with our EmojiArt document itself
    // it is purely a UI visual thing, and it's temporary
    @State private var steadyStateZoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()      // pinch 捏 掐 缩放 扩大
             // $ 代表 binding 绑定。updating 即实现 过程中改变 non-Discrete Gesture
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, transaction in     // 第二个参数 ourGestureStateInOut 此属用与 @GestureState 同名的 gestureZoomScale命名
                gestureZoomScale = latestGestureScale
            }
            .onEnded { finalGestureScale in
                self.steadyStateZoomScale *= finalGestureScale
            }
    }
    
    
    
    // Add Pan
    
    @State private var steadyStatePanOffset: CGSize = .zero
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transaction in
                gesturePanOffset = latestDragGestureValue.translation / self.zoomScale
        }
        .onEnded { finalDragGestureValue in
            self.steadyStatePanOffset = self.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)
        }
    }
    
    
    
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture{
        TapGesture(count: 2)
            // 双击了之后 会发生什么
            .onEnded {
                withAnimation {
                    self.zoomToFit(self.document.backgroundImage, in: size)
                }
                
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {    // ？问号 必有
        if let image = image, image.size.width > 0, image.size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            self.steadyStatePanOffset = .zero // = CGSize.zero //即每次panOffset 都回原点
            self.steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
//    private func font(for emoji: EmojiArt.Emoji) -> Font {
//        Font.system(size: emoji.fontSize * zoomScale)
//    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width / 2, y: location.y + size.height / 2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        return location
    }
    
    //An item provider for conveying data or a file between processes during drag and drop or copy/paste activities, or from a host app to an app extension.
    //NSItemProvider 是 古老的 Objective-C 的东西  TODO
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        // URL.self that means the actual tyope of URL, is just a static var in the type URL, it returns the Type itself
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped \(url)")
            self.document.setBackgroundURL(url)
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size: self.defaultEmojiSize)
            }
        }
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}



//  但这是 错误的做法
//  ForEach(数组)  该数组的元素必须 identifiable 而String不自带 所以加上
//extension String: Identifiable {
//   public var id: String { return self }    // string 自己作为 id 同时加上 public 能让所有的都可见
//}




