//
//  SimpleInputFieldTableCellData.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/21.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import Foundation

class SimpleInputFieldTableCellData: SimpleRowData {
    
    var inputValue: String?
    
    init(key: String, name: String) {
        super.init(type: .input, identifier: "SimpleInputFieldTableCell", key: key, name: name)
    }

    override var value: String? {
        return inputValue
    }
}
