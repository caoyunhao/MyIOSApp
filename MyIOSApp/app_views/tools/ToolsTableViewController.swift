//
//  TableViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/26.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

class ToolsTableViewController: UITableViewController {
    
    private var actionConfig: [String: UIViewController.Type] = [
        "Phonetic": PhoneticAdditionViewController.self,
        "Resize": ResizingViewController.self,
        "Move Assets": AssetsMovementViewController.self,
        "Convert Live Photos": LivePhotosConverterViewController.self,
        "Convert Video": VideoConversionViewController.self,
        "Local Storage manager": LocalStorageManagerViewController.self,
        "Developer Website": DeveloperWebsiteViewController.self,
        "Device Information": DeviceInformationViewController.self,
    ]
    
//    private var actionNameConfig: [String: String] = [
//        "Phonetic": "添加 Phonetic 字段",
//        "Resize": "重置一张图片的大小",
//        "Move Assets": "移动媒体到指定文件夹",
//        "Convert Live Photos": "转换Live Photos视频",
//        ]
    
    private var titleConfig: [[String: Any]] = [
        [
            "title": "Contract",
            "items": [
                "Phonetic",
            ]
        ],
        [
            "title": "Image",
            "items": [
                "Resize",
                "Move Assets",
                "Convert Live Photos",
            ]
        ],
        [
            "title": "Video",
            "items": [
                "Convert Video",
            ]
        ],
        [
            "title": "Local Storage",
            "items": [
                "Local Storage manager",
            ]
        ],
        [
            "title": "About",
            "items": [
                "Device Information",
                "Developer Website",
            ]
        ],
    ]
    
    func getTitle(_ section: Int) -> String {
        return self.titleConfig[section]["title"]! as! String
    }
    
    func getItems(_ section: Int) -> [String] {
        return self.titleConfig[section]["items"]! as! [String]
    }
    
    func getStoryBoardName(_ section: Int, _ row: Int) -> AnyClass {
        return self.actionConfig[self.getItems(section)[row]]!
    }
    
    func getStoryBoardTypeName(_ section: Int, _ row: Int) -> String {
        return CommonUtil.stringFrom(clazz: self.actionConfig[self.getItems(section)[row]]!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.titleConfig.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.getItems(section).count
    }
    
    // 设置 section 的 header 文字
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.getTitle(section)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = LivePhotosConverterViewController(nibName: "LivePhotosConverterViewController", bundle: Bundle.main)
//        let vc = ResizingViewController(nibName: CommonUtil.stringFrom(clazz: ResizingViewController.self), bundle: Bundle.main)
//        let vc = CommonUtil.getFromNib(clazz: ResizingViewController.self)
//        let vc = UIStoryboard(name: self.getStoryBoardName(indexPath.section, indexPath.row), bundle: nil).instantiateInitialViewController()!
        
//        let vc = (self.getStoryBoardName(indexPath.section, indexPath.row) as! UIViewController.Type)
//            .init(nibName: self.getStoryBoardTypeName(indexPath.section, indexPath.row), bundle: Bundle.main)
        
        let vc = CommonUtil.loadNib(ofViewControllerType: self.getStoryBoardName(indexPath.section, indexPath.row) as! UIViewController.Type)

        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc!, animated: true)
        //        self.present(alertController,animated: true,completion: nil)
        
        //        let secondView = DetailViewController()
        //        self.navigationController?.pushViewController(secondView , animated: true)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToolsTableViewCell", for: indexPath) as! ToolsTableViewCell
        
        // Configure the cell...
        
        cell.lable.text = getItems(indexPath.section)[indexPath.row]

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
