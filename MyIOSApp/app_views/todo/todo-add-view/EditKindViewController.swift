//
//  EditKindViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/25.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class EditKindViewController: EditTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新增类型"

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action:  #selector(self.done))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func initGroupConfig() -> GroupConfig {
        return TodoNewKindConfig()
    }
    
    @objc
    func close(_ sender: AnyObject) {
        tableView.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func done(_ sender: AnyObject) {
        let config = groupConfig as! TodoNewKindConfig
        
        guard let kindName = config.kindName else {
            UINotice(text: "kindName 不能为空").show()
            return
        }
        
        if TodoDB.default.addKind(name: kindName) {
            UINotice(text: "添加成功").show()
            tableView.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        } else {
            UINotice(text: "添加失败，请重试").show()
        }
    }
}
