//
//  DeviceInformationViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/11/5.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import AdSupport

class DeviceInformationViewController: UITableViewController {
    
    private var tableConfig: SimpleGroupTableConfig!
    
    func initData() {
        tableConfig = SimpleGroupTableConfig();
        
        SystemUtils.getWiFi()
        
        tableConfig.data.append(SimpleGroupTableConfigGroupConfig(header: "Some ID", content: [
            (label: "IDFA", detailLabel: ASIdentifierManager.shared().advertisingIdentifier.uuidString, style: .value1),
            (label: "IDFV", detailLabel: UIDevice.current.identifierForVendor?.uuidString ?? "nil", style: .value1),
            ], footer: nil))
        
        tableConfig.data.append(SimpleGroupTableConfigGroupConfig(header: "System", content: [
            (label: "iOS Version", detailLabel: UIDevice.current.systemVersion, style: .value1),
//            (label: "Model", detailLabel: UIDevice.current.model, style: .value1),
//            (label: "Localized Model", detailLabel: UIDevice.current.model, style: .value1),
//            (label: "Wi-Fi", detailLabel: UIDevice.current.model, style: .value1),
            ], footer: nil))
        
        tableConfig.data.append(SimpleGroupTableConfigGroupConfig(header: "Storage", content: [
            (label: "RAM Total Size", detailLabel: UIDevice.fileSizeString(fileSize: UIDevice.current.totalRAM) , style: .value1),
            
            (label: "Disk Available Size", detailLabel: UIDevice.fileSizeString(fileSize: UIDevice.current.availableDisk) , style: .value1),
            (label: "Disk Total Size", detailLabel: UIDevice.fileSizeString(fileSize: UIDevice.current.totalDisk) , style: .value1),
            ], footer: nil))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        
        navigationItem.largeTitleDisplayMode = .never
        title = "Device Information"
        tableView.alwaysBounceVertical = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tableConfig.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableConfig.rowsInSection(section)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let cell = UITableViewCell(style: tableConfig.getStyle(cellForRowAt: indexPath), reuseIdentifier: "default");
        
        cell.textLabel?.text = tableConfig.getLabel(cellForRowAt: indexPath)
        cell.detailTextLabel?.text = tableConfig.getDetailLabel(cellForRowAt: indexPath)
        
        //        let switchView = UISwitch(frame: .zero)
        //        switchView.setOn(false, animated: true)
        //        switchView.tag = indexPath.row
        //
        //        cell.accessoryView = switchView
        
        // Configure the cell...
        
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
    
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender: Any?) {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) {
            if let cell = tableView.cellForRow(at: indexPath) {
                if let msg = cell.detailTextLabel?.text {
                    UIPasteboard.general.string = msg
                    AlertUtils.simple(vc: self, message: "Copied!")
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy(_:))
    }
    
    // 设置 section 的 header 文字
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableConfig.getGroupHeader(section: section)
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
