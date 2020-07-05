//
//  Grid.swift
//  Memorize
//
//  Created by 韩子润 on 7/4/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//

import SwiftUI

// .. where Item: Identifiable 代表 只有当 items 数组中每个 Item 是 有唯一id 的 才合法 这是为了和 MemoryGame.swift 中 struct Card: Identifiable 对应
// , ItemView: View 是因为 self.viewForItem(item) 的返回值是 ItemView, 所以只有当 ItemView 是 View 的时候 ForEach(items) 才合法
// beacuse ForEach can only use Views to have Views for these items

// 这里用到的知识点 就是 我们用一些 constrains (即 where 后的条件 即 protocols) to constain these don't care(generics) to work
// generics(Grid<Item, ItemView>) and protocols(Identifiable, View)

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View{  //  don't care what Item       don't care what ItemView
    private var items: [Item]   // items = an Array of Item type item       // private可以 因为后面有 public 的 init函数
    private var viewForItem: (Item) -> ItemView
    
    // @escaping 是为了防止内存泄露 即两个reference 一直有 pointers 互相指着
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    
    // Gird 是一个 container, whose job is take the space that's offered to them and divide it up, which means
    // we need to know how much space has been allocated to us -----> 用 GeometryReader
    
//    错误代码 需要 拆分 escaping
//    var body: some View {
//        GeometryReader { geometry in
//            ForEach(items) { item in            // a for each of our items we are going to return a view of that items
//                self.viewForItem(item)
//            }
//        }
//    }
    
    //MARK: - use GeometryReader to calculate the total space
    var body: some View {
        GeometryReader { geometry in                //  GeometryReader is escaping, so wo do this self.
            self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
        }
    }
    
    //MARK: - use GridLayout to divide it up
    
    private func body(for layout: GridLayout) -> some View {
        ForEach(items) { item in                // ForEach is also escaping, so wo do this self.
            self.body(for: item, in: layout)      // 加上这
            //self.viewForItem(item)            // 删去这 后面 再封装一层 不用self.
        }
    }
    
    //MARK: - we offer the divided space(frame) to our sub-Views
    
//    func body(for item: Item, in layout: GridLayout) -> some View {
//        let index = self.index(of: item)
//        // offer space to this items with frame
//        return viewForItem(item)
//            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
//            .position(layout.location(ofItemAt: index))
//    }
    
//    func body(for item: Item, in layout: GridLayout) -> some View {
//        let index = items.firstIndex(matching: item)        // index 的类型是 Optional 不是 Int 所以后面需要 unwrap
//        // 同时可以直接 判断index不为nil即可
//        // 但是还是有问题 我们要 返回的是个 View 但如果 index == nil 就什么也不返回了 这就有问题
//        // 所以我么要一个 结构 Group, it takes a ViewBuilder that kinda does nothing 就是只要一个 viewbuilder 参数 并且 不会对其内部做任何操作
//        // ViewBuilder 是 一个  function but is a special kind of function where u put the if-else there and u can list views and it turns that all into something that is "somw view"
//        return Group {
//            if index != nil {
//                // offer space to this items with frame
//                viewForItem(item)
//                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
//                    .position(layout.location(ofItemAt: index!))    // 加叹号 exclamation point ！ 是 unwrap the Oprional 的 写法
//            }
//        }    // 如果 index == nil 则 Group will。reutrn a group that has some sort of empty content, its body will be an empty View
//    }
    
    private func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(matching: item)!        // index 的类型是 Optional 不是 Int 所以后面需要 unwrap
        // 加叹号 exclamation point ！ 是 unwrap the Oprional 的 写法 在这里直接unwrap
        return  viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
    }
}







//struct Grid_Previews: PreviewProvider {
//    static var previews: some View {
//        Grid()
//    }
//}
