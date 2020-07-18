//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by 韩子润 on 7/14/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?           // it's an optional
    
    var body: some View {
        Group {
            if uiImage != nil {
                // Image 不能接收 Optional 所以判断不为nil之后 unwrap 用 !
                Image(uiImage: uiImage!)
            }
        }
    }
}
