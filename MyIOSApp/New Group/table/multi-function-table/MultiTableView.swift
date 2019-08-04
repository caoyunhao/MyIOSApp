//
//  MultiTableView.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/19.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class SimpleRowData: NSObject {
    var type: SimpleRowType
    var key: String
    var name: String
    var identifier: String
    var isFirstResponder = false
    
    var cell: SimpleRowTableCell?
    
    var value: String? {
        return nil
    }
    
    init(type: SimpleRowType, identifier: String, key: String, name: String) {
        self.type = type
        self.identifier = identifier
        self.key = key
        self.name = name
    }
    
    override var description: String {
        return "SimpleRowData(type=\(type),key=\(key),name=\(name),identifier=\(identifier))"
    }
}

struct SimpleRowType {
    var name: String
    
    static let simpleChoice = SimpleRowType(name: "SwitchTableCell")
    static let multipleChoices = SimpleRowType(name: "SwitchTableCell")
    static let input = SimpleRowType(name: "SwitchTableCell")
    static let `switch` = SimpleRowType(name: "`SwitchTableCell`")
}

class SimpleRowTableCell: UITableViewCell {
    
    var currentVC: UIViewController!
    
    func load(vc: UIViewController, rawData: SimpleRowData) {
        self.currentVC = vc
    }
}

class Group: NSObject {
    var header: String?
    var footer: String?
    
    var items = [SimpleRowData]()
    
    override var description: String {
        return "Group(header=\(header ?? "nil"),footer=\(footer ?? "nil"),items=\(join(separator: ",", list: items))"
    }
}

class MultiTableView: UITableView {
    
    var groups = [Group]()
    
    var vc: UIViewController!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func load() {
//        DLog(groups)
        for group in groups {
            for row in group.items {
//                DLog("register")
                register(UINib(nibName: row.identifier, bundle: Bundle.main), forCellReuseIdentifier: row.identifier)
            }
        }
        self.dataSource = self
        self.delegate = self
        alwaysBounceVertical = true
        
        self.estimatedRowHeight = 44
        self.rowHeight = UITableViewAutomaticDimension
        
//        self.tableFooterView = UIView(frame: .zero)
    }
    
    override var numberOfSections: Int {
        DLog("groups.count=\(groups.count)")
        return groups.count
    }
}

extension MultiTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DLog("section=\(section), rows=\(groups[section].items.count)")
        return groups[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        DLog(indexPath)
        let rowData = groups[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: rowData.identifier) as! SimpleRowTableCell
        cell.load(vc: vc, rawData: rowData)
        return cell
    }
}

extension MultiTableView: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.endEditing(true)
    }
}
