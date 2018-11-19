//
//  BaseStorage.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/9/1.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation

class BaseStorage: NSObject, NSCoding {
    private var _id: String
    
    var id: String {
        get {
            return _id
        }
    }
    
    init(id: String) {
        _id = id
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_id, forKey: "_id")
    }
    
    required init?(coder aDecoder: NSCoder) {
        _id = aDecoder.decodeObject(forKey: "_id") as! String
    }
}
