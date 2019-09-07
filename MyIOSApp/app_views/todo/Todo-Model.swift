//
//  Todo-Model.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/21.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import Foundation
import SQLite3
import UIKit

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
    
    func newTaskInfoTableGroups() -> [Group] {
        var groups = [Group]()
        
        let kinds = TodoDB.default.queryKinds().map { (kind) -> SimpleMultiChoiseRawData.Item in
            return SimpleMultiChoiseRawData.Item(id: Int(kind.id), name: kind.name)
        }
        let group1 = Group(items: [
            SimpleMultiChoiseRawData(key: "kind", name: "类型", items: kinds, current: kinds.first)
        ])
        
        if let kind = kinds.first {
            DLog("first kind id: \(kind.id)")
            let projects = TodoDB.default.queryProjects().map { (project) -> SimpleMultiChoiseRawData.Item in
                return SimpleMultiChoiseRawData.Item(id: Int(project.id), name: project.name)
            }
            group1.items.append(SimpleMultiChoiseRawData(key: "multi", name: "所属项目", items: projects, current: projects.first))
        }

        groups.append(group1)
        
        let titleRow = SimpleInputTableCellData(key: "title", name: "标题")
        titleRow.isFirstResponder = true
        groups.append(Group(items: [titleRow,]))
        groups.append(Group(items: [
            SimpleSwitchRowData(key: "imp", name: "重要"),
            SimpleSwitchRowData(key: "emergency", name: "紧急"),
        ]))
        groups.append(Group(items: [SimpleSwitchRowData(key: "notice", name: "提醒")]))
        groups.append(Group(items: [SimpleInputFieldTableCellData(key: "detail", name: "详情")]))
        
        return groups
    }
    
    func newKindInfoTableGroups() -> [Group] {
        var groups = [Group]()
        let titleRow = SimpleInputTableCellData(key: "name", name: "类型名称")
        titleRow.isFirstResponder = true
        groups.append(Group(items: [titleRow]))

        return groups
    }
    
    func newProjectInfoTableGroups() -> [Group] {
        var groups = [Group]()
        
        let titleRow = SimpleInputTableCellData(key: "name", name: "项目名称")
        titleRow.isFirstResponder = true
        
        groups.append(Group(items: [titleRow]))
        
        let kinds = TodoDB.default.queryKinds()
        let kindRow = SimpleMultiChoiseRawData(key: "name", name: "项目名称", items: kinds.map({ (kind) -> SimpleMultiChoiseRawData.Item in
            return SimpleMultiChoiseRawData.Item(id: Int(kind.id), name: kind.name)
        }), current: SimpleMultiChoiseRawData.Item(id: Int(kinds[0].id), name: kinds[0].name))
        
        groups.append(Group(items: [kindRow]))

        return groups
    }
    
    func newProjectConfig() {
        
    }
    

}

class GroupConfig: NSObject {
    var groups = [Group]()
}

class TodoNewTaskConfig: GroupConfig {
    override init() {
        super.init()
        let kinds = TodoDB.default.queryKinds().map { (kind) -> SimpleMultiChoiseRawData.Item in
            return SimpleMultiChoiseRawData.Item(id: Int(kind.id), name: kind.name, image: createCircularImage(rate: 0.3, color: .red))
        }
        let projectRow = SimpleMultiChoiseRawData(key: "project", name: LocalizedStrings.PROJECT, items: [], current: nil)
        
        let kindRow = SimpleMultiChoiseRawData(key: "kind", name: LocalizedStrings.KIND, items: kinds, current: kinds.first) { item in
            DLog("callback")
            projectRow.items = TodoDB.default.queryProjects(byKindId: Int32(item.id)).map({ (project) -> SimpleMultiChoiseRawData.Item in
                return SimpleMultiChoiseRawData.Item(id: Int(project.id), name: project.name)
            })
            projectRow.current = projectRow.items.first
        }
        
        let group1 = Group(items: [
            kindRow,
            projectRow,
        ])
        
        groups.append(group1)
        
        let titleRow = SimpleInputTableCellData(key: "title", name: LocalizedStrings.TITLE)
        titleRow.isFirstResponder = true
        groups.append(Group(items: [titleRow,]))
        groups.append(Group(items: [
            SimpleSwitchRowData(key: "imp", name: LocalizedStrings.IMPORTENT),
            SimpleSwitchRowData(key: "emergency", name: LocalizedStrings.EMERGENCY),
            ]))
        groups.append(Group(items: [SimpleSwitchRowData(key: "notice", name: LocalizedStrings.REMIND)]))
        groups.append(Group(items: [SimpleInputFieldTableCellData(key: "detail", name: LocalizedStrings.DETAIL)]))
    }
    
    var projectId: Int? {
        return (groups[0].items[1] as! SimpleMultiChoiseRawData).current?.id
    }
    
    var taskName: String? {
        return (groups[1].items[0] as! SimpleInputTableCellData).inputValue?.valid
    }
    
    var imp: Bool? {
        return (groups[2].items[0] as! SimpleSwitchRowData).isOn
    }
    
    var emergency: Bool? {
        return (groups[2].items[1] as! SimpleSwitchRowData).isOn
    }
    
    var notice: Bool? {
        return (groups[3].items[1] as! SimpleSwitchRowData).isOn
    }
    
    var detail: String? {
        return (groups[4].items[0] as! SimpleInputFieldTableCellData).inputValue
    }
}

class TodoNewProjectConfig: GroupConfig {
    override convenience init() {
        self.init(kind: nil)
    }
    
    init(kind: Kind?) {
        super.init()
        let titleRow = SimpleInputTableCellData(key: "name", name: "项目名称")
        titleRow.isFirstResponder = true
        
        groups.append(Group(items: [titleRow]))
        
        var current: SimpleMultiChoiseRawData.Item? = nil
        if let currentKind = kind {
            current = SimpleMultiChoiseRawData.Item(id: Int(currentKind.id), name: currentKind.name)
        }
        
        let kinds = TodoDB.default.queryKinds()
        let kindRow = SimpleMultiChoiseRawData(key: "name", name: "项目类型", items: kinds.map({ (kind) -> SimpleMultiChoiseRawData.Item in
            return SimpleMultiChoiseRawData.Item(id: Int(kind.id), name: kind.name)
        }), current: current ?? SimpleMultiChoiseRawData.Item(id: Int(kinds[0].id), name: kinds[0].name))
        
        groups.append(Group(items: [kindRow]))
    }
    
    var projectName: String? {
        return (groups[0].items[0] as! SimpleInputTableCellData).inputValue?.valid
    }
    var kindId: Int? {
        return (groups[1].items[0] as! SimpleMultiChoiseRawData).current?.id
    }
}

class TodoNewKindConfig: GroupConfig {
    override init() {
        super.init()
        let titleRow = SimpleInputTableCellData(key: "name", name: "类型名称")
        titleRow.isFirstResponder = true
        groups.append(Group(items: [titleRow]))
        
        SimpleMultiChoiseRawData(key: "project", name: "所属项目", items: [], current: nil)
        
        
        
        groups.append(Group(items: [
            
        ]))
    }
    
    var kindName: String? {
        return (groups[0].items[0] as! SimpleInputTableCellData).inputValue?.valid
    }
}

private func image(with path: UIBezierPath, size: CGSize, color: UIColor) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.set()
    path.lineWidth = 2
    path.fill()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}

func createCircularImage(rate: CGFloat, color: UIColor) -> UIImage? {
//    UIColor.red.set()
    let size: CGFloat = 1000.0
    let x = (size * (1 - rate)) / 2
    
    let aPath = UIBezierPath(ovalIn: CGRect(x: x, y: x, width: size * rate, height: size * rate))
    return image(with: aPath, size: CGSize(width: size, height: size), color: color)
}
