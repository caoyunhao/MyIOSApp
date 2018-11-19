//
//  NSRange.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/28.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation

//扩展NSRange，让swift的string能使用stringByReplacingCharactersInRange
extension NSRange {
    func toRange(string: String) -> Range<String.Index> {
//        let startIndex = string.startIndex.advanced(by: self.location)
        let startIndex = String.Index(encodedOffset: string.startIndex.encodedOffset + self.location)
        let endIndex = String.Index(encodedOffset: startIndex.encodedOffset + self.length)
        return startIndex..<endIndex
    }
}
