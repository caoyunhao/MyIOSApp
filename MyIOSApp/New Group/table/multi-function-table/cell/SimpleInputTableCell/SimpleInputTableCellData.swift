//
//  SimpleInputTableCellData.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/21.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import Foundation

class SimpleInputTableCellData: SimpleRowData {
    
    var placeholder: String?
    
    var inputValue: String?
    
    init(key: String, name: String) {
        super.init(type: .input, identifier: "SimpleInputTableCell", key: key, name: name)
        self.placeholder = name
    }
    
    override var value: String? {
        return inputValue
    }
}
