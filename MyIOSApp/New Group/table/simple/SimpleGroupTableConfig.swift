//
//  SimpleGroupTableConfig.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/11/10.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

struct SimpleGroupTableConfigGroupConfig {
    var header: String
    var content: [(label: String, detailLabel: String, style: UITableViewCell.CellStyle)]
    var footer: String?
}

class SimpleGroupTableConfig {
    
    var data: [SimpleGroupTableConfigGroupConfig] = []
    
    var sectionCount: Int {
        return data.count
    }
    
    func rowsInSection(_ i: Int) -> Int {
        return data[i].content.count
    }
    
    func getGroupHeader(section: Int) -> String {
        return data[section].header
    }
    
    func getGroupFooter(section: Int) -> String? {
        return data[section].footer
    }
    
    func getStyle(cellForRowAt indexPath: IndexPath) -> UITableViewCell.CellStyle {
        return data[indexPath.section].content[indexPath.row].style
    }
    
    func getLabel(cellForRowAt indexPath: IndexPath) -> String {
        return data[indexPath.section].content[indexPath.row].label
    }
    
    func getDetailLabel(cellForRowAt indexPath: IndexPath) -> String {
        return data[indexPath.section].content[indexPath.row].detailLabel
    }
}


