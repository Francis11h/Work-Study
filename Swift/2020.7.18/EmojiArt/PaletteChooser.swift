//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by 韩子润 on 7/18/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument
    
    @Binding var chosenPalette: String
    
    var body: some View {
        HStack {
            Stepper(onIncrement: {
                self.chosenPalette = self.document.palette(after: self.chosenPalette)
            }, onDecrement: {
                self.chosenPalette = self.document.palette(before: self.chosenPalette)
            }, label: { EmptyView() })
            Text(self.document.paletteNames[self.chosenPalette] ?? "")
        }
        .fixedSize(horizontal: true, vertical: false)
//        .onAppear { self.chosenPalette = self.document.defaultPalette }
    }
}

struct PaletteChooser_Preview: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(), chosenPalette: Binding.constant(""))
    }
}
