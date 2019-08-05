//
//  EditTodoViewController4.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/22.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class EditTodoViewController4: EditTableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新增任务"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action:  #selector(self.done))
    }
    
    override func initGroupConfig() -> GroupConfig {
        return TodoNewTaskConfig()
    }
    
    @objc
    func close(_ sender: AnyObject) {
        tableView.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func done(_ sender: AnyObject) {
        let config = groupConfig as! TodoNewTaskConfig
        
        guard let projectId = config.projectId else {
            NoticeHUD(text: "projectId == nil").show()
            return
        }
        
        guard let title = config.taskName else {
            NoticeHUD(text: "title == nil").show()
            return
        }
        
        guard let detail = config.detail else {
            NoticeHUD(text: "detail == nil").show()
            return
        }
        
        guard let im = config.imp else {
            NoticeHUD(text: "im == nil").show()
            return
        }
        
        guard let em = config.emergency else {
            NoticeHUD(text: "emergency == nil").show()
            return
        }
        
        DLog("title    : \(title)")
        DLog("detail   : \(detail)")
        DLog("im       : \(im)")
        DLog("em       : \(em)")
        DLog("projectId: \(projectId)")
        
        let imInt = Int32(im ? 1: 0)
        let emInt = Int32(im ? 1: 0)
        
        if TodoDB.default.addTask(title: title as NSString, detail: detail as NSString, importent: imInt, emergency: emInt, projectId: Int32(projectId)) {
            NoticeHUD(text: "添加成功").show()
            tableView.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        } else {
            NoticeHUD(text: "添加失败").show()
        }
    }
}
