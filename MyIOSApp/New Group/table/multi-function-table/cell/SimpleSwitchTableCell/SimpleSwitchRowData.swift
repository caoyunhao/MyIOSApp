//
//  SimpleSwitchRowData.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/19.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import Foundation

class SimpleSwitchRowData: SimpleRowData {
    override var value: String? {
        return isOn.description
    }
    
    var isOn: Bool = false
    
    init(key: String, name: String) {
        super.init(type: .switch, identifier: "SwitchTableCell", key: key, name: name)
    }
    
    
    override var description: String {
        return "SimpleSwitchRowData(super=\(super.description),isOn=\(isOn.description))"
    }
}
