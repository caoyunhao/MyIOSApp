//
//  EditTableViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/8/5.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class EditTableViewController: UITableViewController {

    var groupConfig: GroupConfig!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: view.frame, style: .grouped)
        self.tableView.alwaysBounceVertical = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.editEnd))
        self.tableView.addGestureRecognizer(tap)
        tap.delegate = self
        
        groupConfig = initGroupConfig()
        
        for group in groupConfig.groups {
            for row in group.items {
                self.tableView.register(UINib(nibName: row.identifier, bundle: Bundle.main), forCellReuseIdentifier: row.identifier)
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func initGroupConfig() -> GroupConfig {
        return GroupConfig()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return groupConfig.groups.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupConfig.groups[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowData = groupConfig.groups[indexPath.section].items[indexPath.row]
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
    func editEnd() {
        tableView.endEditing(true)
    }
}

extension EditTableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view is UITableView
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

func stringTrim(string: String?) -> String? {
    if let string = string {
        let string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if string != "" {
            return string
        }
    }
    return nil
}
