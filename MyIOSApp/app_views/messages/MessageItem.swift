//
//  Message.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/22.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation

class MessageItem: BaseStorage {
    var text: String
    var creationTime: Date = Date()
    var flag: Bool = false
    
    struct PropertyKey {
        static let text = "text"
        static let creationTime = "creationTime"
        static let flag = "flag"
    }
    
    static func identifier(message: String) -> String {
        return "MessageItem:\(message.md5)"
    }
    
    init(text: String) {
        self.text = text
        super.init(id: MessageItem.identifier(message: text))
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(text, forKey: PropertyKey.text)
        aCoder.encode(creationTime, forKey: PropertyKey.creationTime)
        aCoder.encode(flag, forKey: PropertyKey.flag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = (aDecoder.decodeObject(forKey: PropertyKey.text) as? String)!
        creationTime = (aDecoder.decodeObject(forKey: PropertyKey.creationTime) as? Date) ?? Date()
        flag = (aDecoder.decodeObject(forKey: PropertyKey.flag) as? Bool) ?? false
        super.init(coder: aDecoder)
    }
}
