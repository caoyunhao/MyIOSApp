//
//  SimpleMultiChoiseRowData.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/19.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class SimpleMultiChoiseRawData: SimpleRowData {
    
    struct Item {
        var id: Int
        var name: String
    }
    
    var items = [Item]()
    var current: Item? {
        didSet {
            cell?.detailTextLabel?.text = current?.name
        }
    }
    
    override var value: String? {
        return current?.name
    }
    
    init(key: String, name: String) {
        super.init(type: .multipleChoices, identifier: "SimpleMultiChoiseCellTableViewCell", key: key, name: name)
    }
    
    convenience init(key: String, name: String, items: [Item], current: Item?) {
        self.init(key: key, name: name)
        self.items = items
        self.current = current
    }
    
    override var description: String {
        return "SimpleMultiChoiseRawData(super=\(super.description),items=\(items.description),current=\(String(describing: current?.name))"
    }
}
