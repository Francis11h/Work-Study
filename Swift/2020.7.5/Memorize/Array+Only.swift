//
//  Array+Only.swift
//  Memorize
//
//  Created by 韩子润 on 7/4/20.
//  Copyright © 2020 Francis Han. All rights reserved.
//

import Foundation


extension Array {
    var only: Element? {    // Optional
        count == 1 ? first : nil
    }
}

