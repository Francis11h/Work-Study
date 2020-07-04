//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by 韩子润 on 7/4/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//

import Foundation


// 由于 我们     Grid.swift 和  MemoryGame.swift 都用到了    func index(of item: Item) -> Int ... 所以可以优化 不要重复写无用功
// 这里也是 constrains and gains

//extension Array where Element: Identifiable {
//
//    func firstIndex(matching: Element) -> Int {       // Item 改为 Element         of item: 改个名字吧 改成 matching:
//        for index in 0..<self.count {
//            if self[index].id == matching.id {      // items[index].id 改为 self 这里的self就是指 该 Array items
//                return index
//            }
//        }
//        return 0    // TODO bogus!   当数组为空的时候 显然是 错误的
//    }
//}


extension Array where Element: Identifiable {
    
    func firstIndex(matching: Element) -> Int? {    // 这里的 Int？ 是 Optional 是不同于 Int的 类型type    而不是 Int + modifier
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil      // nil 就保证了 数组为空不会出bug
    }
}
