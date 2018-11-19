//
//  PlayersViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/2/15.
//  Copyright © 2018年 Yunhao. All rights reserved.
//

import UIKit
import Foundation


class MessagesViewController: UITableViewController {
    let cellIdentifier = "MessagesViewCell"
    
    let keyOfStorage = "messages"
    
    var messgaes:[MessageItem] = []
    
    @objc
    func handleRefresh(sender: NSNotification) {
        self.refreshingData()
        refreshControl?.endRefreshing()
    }
    
    func refreshingData() {
        messgaes = MessagesStorageUtil.data()
        tableView.reloadData()
    }
    
    @objc func left() {
        let vc = CommonUtil.loadNib(ofViewControllerType: CameraScanViewController.self) as! CameraScanViewController
        let nvc = UINavigationController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Recent"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.searchController = UISearchController(searchResultsController: UIViewController())
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Scan", style: .plain, target: self, action: #selector(self.left))
        
//        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        
        refreshControl?.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)

        

        messgaes = MessagesStorageUtil.data()
        
        //tableView.addSubview(m_RefreshControl) // not required when using UITableViewController

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        DLog(message: "123456 md5: \("123456".md5)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshingData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messgaes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessagesViewCell
    
        cell.message = messgaes[indexPath.row] as MessageItem
        
        
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    /// 从左侧划出
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Flag") { (action, view, handler) in
//            self.updateMarkState(for: indexPath)
            handler(true)
            
            let cell = tableView.cellForRow(at: indexPath) as! MessagesViewCell
            cell.changeFlagState()
            
        }
        action.backgroundColor = UIColor(red: 73/255.0, green: 175/255.0, blue: 254/255.0, alpha: 1)
        
//        if markState(for: indexPath) {
//            action.title = "Unmark"
//            action.backgroundColor = UIColor.red
//        }
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    /// 从右侧划出
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
//            self.removeItem(at: indexPath)
            handler(true)
            MessagesStorageUtil.remove(message: (tableView.cellForRow(at: indexPath) as! MessagesViewCell).message)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    // 设置 section 的 header 文字
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "header-\(section)"
//    }
    // 设置 section 的 footer 文字
//    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return "footer-\(section)"
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = CommonUtil.loadNib(ofViewControllerType: MessageViewController.self) as! MessageViewController
        let cell = tableView.cellForRow(at: indexPath) as! MessagesViewCell
        vc.message = cell.message
        self.navigationController?.pushViewController(vc, animated: true)
//        NSLog("选中了第\(indexPath.row)个cell")
//        let alertController = UIAlertController(
//            title: "提示",
//            message: "一個簡單提示，請按確認繼續",
//            preferredStyle: .alert)
//        let okAction = UIAlertAction(
//            title: "確認",
//            style: .default,
//            handler: {
//                (action: UIAlertAction!) -> Void in
//                print("按下確認後，閉包裡的動作")
//        })
//        alertController.addAction(okAction)
//        self.present(alertController,animated: true,completion: nil)
        
//        let secondView = DetailViewController()
//        self.navigationController?.pushViewController(secondView , animated: true)
    }
}
