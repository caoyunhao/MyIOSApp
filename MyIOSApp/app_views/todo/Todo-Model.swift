//
//  Todo-Model.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/21.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import Foundation
import SQLite3

class TodoProject {
    var tasks = [TodoTask]()
    
    var weight: Int = 100
}

class TodoLevel {
    let weight: Int
    
    init(weight: Int) {
        self.weight = weight
    }
    
    static let low = TodoLevel(weight: 10)
}

class TodoTask {
    var title: String
    var detail: String
    
    init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }
    
    var weight: Int = 100
    
    var deadline: Date?
    
    var creationDate: Date = Date()
    var lastModificationDate: Date = Date()
    
    var spendTime: TimeInterval = 0
}

class TodoManager {
    
    static let `default` = TodoManager()
    
    func getTaskInfoTableGroups() -> [Group] {
        var groups = [Group]()
        
        let group1 = Group()
        let kinds = TodoDB.default.queryKinds().map { (kind) -> SimpleMultiChoiseRawData.Item in
            return SimpleMultiChoiseRawData.Item(id: Int(kind.id), name: kind.name)
        }
        group1.items.append(SimpleMultiChoiseRawData(key: "kind", name: "类型", items: kinds, current: kinds.first))
        if let kind = kinds.first {
            DLog("first kind id: \(kind.id)")
            let projects = TodoDB.default.queryProjects().map { (project) -> SimpleMultiChoiseRawData.Item in
                return SimpleMultiChoiseRawData.Item(id: Int(project.id), name: project.name)
            }
            group1.items.append(SimpleMultiChoiseRawData(key: "multi", name: "所属项目", items: projects, current: projects.first))
        }

        groups.append(group1)
        
        let group2 = Group()
        let titleRow = SimpleInputTableCellData(key: "title", name: "标题")
        titleRow.isFirstResponder = true
        group2.items.append(titleRow)
        groups.append(group2)
        
        let group21 = Group()
        group21.items.append(SimpleSwitchRowData(key: "imp", name: "重要"))
        group21.items.append(SimpleSwitchRowData(key: "emergency", name: "紧急"))
        groups.append(group21)
        
        let group4 = Group()
        group4.items.append(SimpleSwitchRowData(key: "notice", name: "提醒"))
        groups.append(group4)
        
        let group5 = Group()
        group5.items.append(SimpleInputFieldTableCellData(key: "detail", name: "详情"))
        groups.append(group5)
        
        return groups
    }
    
    func getKindInfoTableGroups() -> [Group] {
        var groups = [Group]()
    
        
        let group2 = Group()
        let titleRow = SimpleInputTableCellData(key: "name", name: "类型名称")
        titleRow.isFirstResponder = true
        group2.items.append(titleRow)
        groups.append(group2)

        return groups
    }
    
    class KindInfoTableConfig {
        
    }
}
