//
//  date.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/9/6.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation

class DateUtils {
    static let timeZone = TimeZone.current
    static let locale = Locale.init(identifier: "zh_CN")
    
    static var dataFormatter1: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = locale
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter
    }
    
    static func stringWithType1(date: Date) -> String {
        return dataFormatter1.string(from: date)
    }
}
