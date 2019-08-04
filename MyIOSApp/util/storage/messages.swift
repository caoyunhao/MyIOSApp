//
//  StorageUtil.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/23.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation

class PastboardHistory {
    
    static private let _shared = PastboardHistory(key: "message")
    
    static var shared: PastboardHistory {
        return _shared
    }
    
    let key: String
    
    init(key : String) {
        self.key = key
    }
    
    var data: [MessageItem] {
        DLog("get")
        
        let array = UserDefaultsUtils.getArray(name: self.key)
        
        if let array = array {
            DLog(array.count)
            return array.map({ (item) in
                return UserDefaultsUtils.getObject(forKey: item as! String) as! MessageItem
            })
        } else {
            DLog("empty")
            return []
        }
    }
    
    func has(text: String) -> Bool {
        return UserDefaultsUtils.has(arrayName: self.key, key: MessageItem.identifier(message: text))
    }
    
    func changeStatus(of message: MessageItem) -> MessageItem {
        message.flag = !message.flag
        _ = UserDefaultsUtils.save(object: message)
        
        return message
    }
    
    func add(text: String) {
        if !has(text: text) {
            UserDefaultsUtils.appendObject(arrayName: self.key, value: MessageItem(text: text))
        }
    }
    
    func remove(message: MessageItem) {
        UserDefaultsUtils.remove(arrayName: self.key, key: message.id)
    }
    
    func clean() {
        UserDefaultsUtils.clean(arrayName: self.key)
    }
}
