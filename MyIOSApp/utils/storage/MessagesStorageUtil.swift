//
//  StorageUtil.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/23.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation

class MessagesStorageUtil {
    static let key = "message"
    
    static func data() -> [MessageItem] {
        DLog(message: "get")
        
        let array = UserDefaultsStorageUtil.getArray(name: key)
        
        if let array = array {
            DLog(message: array.count)
            return array.map({ (item) in
                return UserDefaultsStorageUtil.getObject(forKey: item as! String) as! MessageItem
            })
        } else {
            DLog(message: "empty")
            return []
        }
    }
    
    static func has(text: String) -> Bool {
        return UserDefaultsStorageUtil.has(arrayName: key, key: MessageItem.identifier(message: text))
    }
    
    static func changeStatus(of message: MessageItem) -> MessageItem {
        message.flag = !message.flag
        _ = UserDefaultsStorageUtil.save(object: message)
        
        return message
    }
    
    static func add(text: String) {
        if !has(text: text) {
            UserDefaultsStorageUtil.appendObject(arrayName: key, value: MessageItem(text: text))
        }
    }
    
    static func remove(message: MessageItem) {
        UserDefaultsStorageUtil.remove(arrayName: key, key: message.id)
    }
    
    static func clean() {
        UserDefaultsStorageUtil.clean(arrayName: key)
    }
}
