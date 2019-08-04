//
//  EditTodoViewController4.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/22.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class EditTodoViewController4: UITableViewController {
    
    var groups: [Group]!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: view.frame, style: .grouped)
        self.tableView.alwaysBounceVertical = true
        title = "新增任务"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action:  #selector(self.done))
        
        groups = TodoManager.default.getTaskInfoTableGroups()
        
        for group in groups {
            for row in group.items {
                self.tableView.register(UINib(nibName: row.identifier, bundle: Bundle.main), forCellReuseIdentifier: row.identifier)
            }
        }
        
//        tableView.addOnClickListener(target: self, action: #selector(self.editEnd))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.editEnd))
        self.tableView.addGestureRecognizer(tap)
        tap.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return groups.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups[section].items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowData = groups[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: rowData.identifier) as! SimpleRowTableCell
        cell.load(vc: self, rawData: rowData)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc
    func close(_ sender: AnyObject) {
        tableView.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func done(_ sender: AnyObject) {
        tableView.endEditing(true)
        
        let projectId = (groups[0].items[1] as! SimpleMultiChoiseRawData).current!.id
        let title = groups[1].items[0].value!
        let detail = groups[4].items[0].value!
        let im = (groups[2].items[0] as! SimpleSwitchRowData).isOn
        let em = (groups[2].items[1] as! SimpleSwitchRowData).isOn
        
        DLog("title    : \(title)")
        DLog("detail   : \(detail)")
        DLog("im       : \(im)")
        DLog("em       : \(em)")
        DLog("projectId: \(projectId)")
        
        let imInt = Int32(im ? 1: 0)
        let emInt = Int32(im ? 1: 0)
        
        if TodoDB.default.addTask(title: title as NSString, detail: detail as NSString, importent: imInt, emergency: emInt, projectId: Int32(projectId)) {
            let notice = NoticeHUD(text: "添加成功")
            notice.show()
        } else {
            let notice = NoticeHUD(text: "添加失败")
            notice.show()
        }
        
//        let msg = join(separator: "\n", list: groups)
//        let notice = NoticeHUD(text: msg, options: NoticeHUD.Options())
//        notice.show()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func editEnd() {
        tableView.endEditing(true)
    }
}

extension EditTodoViewController4: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view is UITableView
    }
}
