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
        var image: UIImage?
        
        init(id: Int, name: String, image: UIImage? = nil) {
            self.id = id
            self.name = name
            self.image = image
        }
    }
    
    var items: [Item] = []
    var callback: ((Item) -> ())?
    var current: Item? {
        didSet {
            if let cell1 = cell as? SimpleMultiChoiseCellTableViewCell {
                cell1.selectedTextLabel?.text = current?.name
                cell1.selectedImageView.image = current?.image
            }
            if let current = current {
                callback?(current)
            }
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
    
    convenience init(key: String, name: String, items: [Item], current: Item?, callback: ((Item) -> ())?) {
        self.init(key: key, name: name)
        self.items = items
        self.callback = callback
        self.current = current
        if let current = current {
            self.callback?(current)
        }
    }
    
    override var description: String {
        return "SimpleMultiChoiseRawData(super=\(super.description),items=\(items.description),current=\(String(describing: current?.name))"
    }
}
