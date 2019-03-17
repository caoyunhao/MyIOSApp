//
//  TableViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/26.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

fileprivate struct ToolViewInfo {
    var name: String
    var viewControllerClass: UIViewController.Type
    var description: String
}

fileprivate let phoneticViewInfo = ToolViewInfo(
    name: "Phonetic",
    viewControllerClass: PhoneticAdditionViewController.self,
    description: "为联系人添加 Phonetic 字段（该字段用于联系人排序）"
)

fileprivate let ResizeViewInfo = ToolViewInfo(
    name: "Resize",
    viewControllerClass: ResizingViewController.self,
    description: "重置一张图片（包括 Gif）的像素级大小、翻转"
)

fileprivate let moveAssetsViewInfo = ToolViewInfo(
    name: "Move Assets",
    viewControllerClass: AssetsMovementViewController.self,
    description: "移动媒体到指定文件夹"
)

fileprivate let livePhotosViewInfo = ToolViewInfo(
    name: "Live Photos",
    viewControllerClass: LivePhotosConverterViewController.self,
    description: "将 Live Photo 转换成视频"
)

fileprivate let gifPickerViewInfo = ToolViewInfo(
    name: "Gif Picker",
    viewControllerClass: GifPickerViewController.self,
    description: "从 GIF 里提取照片"
)

fileprivate let convertVideoViewInfo = ToolViewInfo(
    name: "Convert Video",
    viewControllerClass: VideoConversionViewController.self,
    description: "将视频转化为 GIF"
)

fileprivate let localStorageManagerViewInfo = ToolViewInfo(
    name: "Local Storage Manager",
    viewControllerClass: LocalStorageManagerViewController.self,
    description: "此软件本地存储大小"
)

fileprivate let developerWebsiteViewInfo = ToolViewInfo(
    name: "Developer Website",
    viewControllerClass: DeveloperWebsiteViewController.self,
    description: "开发者个人网站"
)

fileprivate let deviceInformationViewInfo = ToolViewInfo(
    name: "Device Information",
    viewControllerClass: DeviceInformationViewController.self,
    description: "这台设备的一些基本信息"
)

class ToolsTableViewController: UITableViewController {
    
    fileprivate var titleConfig: [[String: Any]] = [
        [
            "title": "Contract",
            "items": [
                phoneticViewInfo,
            ]
        ],
        [
            "title": "Image",
            "items": [
                ResizeViewInfo,
                moveAssetsViewInfo,
                livePhotosViewInfo,
                gifPickerViewInfo,
            ]
        ],
        [
            "title": "Video",
            "items": [
                convertVideoViewInfo,
            ]
        ],
        [
            "title": "Local Storage",
            "items": [
                localStorageManagerViewInfo,
            ]
        ],
        [
            "title": "About",
            "items": [
                deviceInformationViewInfo,
                developerWebsiteViewInfo,
            ]
        ],
    ]
    
    fileprivate func getTitle(_ section: Int) -> String {
        return self.titleConfig[section]["title"]! as! String
    }
    
    fileprivate func getToolViewInfoItems(_ section: Int) -> [ToolViewInfo] {
        return self.titleConfig[section]["items"]! as! [ToolViewInfo]
    }
    
    fileprivate func getViewControllerClass(_ section: Int, _ row: Int) -> AnyClass {
        return self.getToolViewInfoItems(section)[row].viewControllerClass
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
        return self.getToolViewInfoItems(section).count
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
        
        let vc = CommonUtils.loadNib(ofViewControllerType: self.getViewControllerClass(indexPath.section, indexPath.row) as! UIViewController.Type)
//        vc.title =

        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc!, animated: true)
        //        self.present(alertController,animated: true,completion: nil)
        
        //        let secondView = DetailViewController()
        //        self.navigationController?.pushViewController(secondView , animated: true)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToolsTableViewCell", for: indexPath) as! ToolsTableViewCell
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "default");
        // Configure the cell...
        
        let item = getToolViewInfoItems(indexPath.section)[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.description
        cell.accessoryType = .disclosureIndicator

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
