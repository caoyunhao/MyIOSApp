//
//  EditTodoViewController3.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/21.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class EditTodoViewController3: UIViewController {
    
    var tableView: MultiTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = MultiTableView(frame: view.frame, style: .grouped)
        
        tableView.vc = self
//        tableView.groups = getTaskInfoTableGroups()
        tableView.load()
        
        tableView.reloadData()
        
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
