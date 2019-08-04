//
//  EditTodoViewController2.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/19.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class EditTodoViewController2: UITableViewController {
    
    var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新增任务"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        
        self.tableView = MultiTableView(frame: view.frame, style: .grouped)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
        // let view_ = tableView as! MultiTableView
        
        initData()
//        DLog("reloadData")
//        tableView.reloadData()
        DLog("viewDidLoad done")
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        DLog("viewWillAppear done")
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        DLog("viewDidAppear done")
//    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        DLog("numberOfSections=\(groups.count)")
//        return groups.count
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        DLog("numberOfRowsInSection=\(groups[section].items.count)")
//        return groups[section].items.count
//    }
    
    
    func initData() {
        
        
        let view_ = tableView as! MultiTableView
        view_.vc = self
        
//        view_.groups = getTaskInfoTableGroups()
        
        view_.load()
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        let msg = join(separator: "\n", list: groups)
        let notice = NoticeHUD(text: msg, options: NoticeHUD.Options())
        notice.show()
        self.dismiss(animated: true, completion: nil)
    }
}

func join<T: NSObject>(separator: String, list: [T], toString: ((T) -> String)? = nil) -> String {
    let count = list.count
    var msg = ""
    for i in 0 ..< count {
        let item = list[i]
        if let stringFunc = toString {
            msg += stringFunc(item)
        } else {
            msg += item.description
        }
        if i != count - 1 {
            msg += separator
        }
    }
    return msg
}
