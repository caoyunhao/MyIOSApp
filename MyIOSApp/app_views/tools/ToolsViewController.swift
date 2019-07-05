//
//  ToolsViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/6/10.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit
import SafariServices

fileprivate enum ViewControllerOpenStyle {
    case push
    case pop
}

fileprivate struct RowInfo {
    var name: String
    var description: String
    var action: (UIViewController) -> ()
}

fileprivate let phoneticViewInfo = RowInfo(
    name: "添加 Phonetic 字段",
    description: "该字段用于联系人排序",
    action: { (currentViewController) in
        let vc = CommonUtils.loadNib(ofViewControllerType: PhoneticAdditionViewController.self)
        currentViewController.navigationController?.pushViewController(vc, animated: true)
    }
)

fileprivate let ResizeViewInfo = RowInfo(
    name: "查看、编辑",
    description: "修改像素大小、翻转、查看详细信息",
    action: { (currentViewController) in
        let vc = CommonUtils.loadNib(ofViewControllerType: ResizingViewController.self)
        currentViewController.navigationController?.pushViewController(vc, animated: true)
    }
)

fileprivate let moveAssetsViewInfo = RowInfo(
    name: "Move Assets",
    description: "移动媒体到指定文件夹",
    action: { (currentViewController) in
        let vc = CommonUtils.loadNib(ofViewControllerType: AssetsMovementViewController.self)
        currentViewController.navigationController?.pushViewController(vc, animated: true)
    }
)

fileprivate let livePhotosViewInfo = RowInfo(
    name: "Live Photos 工具",
    description: "Live Photos 和 视频 的相互转换",
    action: { (currentViewController) in
        let vc = CommonUtils.loadNib(ofViewControllerType: LivePhotosConverterViewController.self)
        currentViewController.navigationController?.pushViewController(vc, animated: true)
    }
)

fileprivate let gifPickerViewInfo = RowInfo(
    name: "提取 Gif",
    description: "从 GIF 里提取照片",
    action: { (currentViewController) in
        let vc = CommonUtils.loadNib(ofViewControllerType: GifPickerViewController.self)
        currentViewController.navigationController?.pushViewController(vc, animated: true)
    }
)

fileprivate let convertVideoViewInfo = RowInfo(
    name: "转为 GIF",
    description: "将视频转化为 GIF",
    action: { (currentViewController) in
        let vc = CommonUtils.loadNib(ofViewControllerType: VideoConversionViewController.self)
        currentViewController.navigationController?.pushViewController(vc, animated: true)
    }
)

fileprivate let localStorageManagerViewInfo = RowInfo(
    name: "Local Storage Manager",
    description: "此软件本地存储大小，谨慎操作",
    action: { (currentViewController) in
        let vc = CommonUtils.loadNib(ofViewControllerType: LocalStorageManagerViewController.self)
        currentViewController.navigationController?.pushViewController(vc, animated: true)
    }
)

fileprivate let developerWebsiteViewInfo = RowInfo(
    name: "Developer Website",
    description: "开发者个人网站",
    action: { (currentViewController) in
        AlertUtils.biAction(vc: currentViewController, message: "将跳转至 Safari", leftTitle: "取消", rightTitle: "跳转", leftAction: nil, rightAction: {
            let url = URL(string: "https://caoyunhao.com")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
//        let vc = DeveloperWebsiteViewController(url: url)
//        currentViewController.present(vc, animated: true)
    }
)

fileprivate let deviceInformationViewInfo = RowInfo(
    name: "Device Information",
    description: "这台设备的一些基本信息",
    action: { (currentViewController) in
        let vc = CommonUtils.loadNib(ofViewControllerType: DeviceInformationViewController.self)
        currentViewController.navigationController?.pushViewController(vc, animated: true)
    }
)

class ToolsViewController: UITableViewController {
    
    fileprivate var titleConfig: [[String: Any]] = [
        [
            "title": LocalizedStrings.CONTACT,
            "items": [
                phoneticViewInfo,
            ]
        ],
        [
            "title": LocalizedStrings.IMAGE,
            "items": [
                ResizeViewInfo,
                moveAssetsViewInfo,
                livePhotosViewInfo,
                gifPickerViewInfo,
            ]
        ],
        [
            "title": LocalizedStrings.VIDEO,
            "items": [
                convertVideoViewInfo,
            ]
        ],
        [
            "title": LocalizedStrings.LOCAL_STORAGE,
            "items": [
                localStorageManagerViewInfo,
            ]
        ],
        [
            "title": LocalizedStrings.ABOUT,
            "items": [
                deviceInformationViewInfo,
                developerWebsiteViewInfo,
            ]
        ],
    ]
    
    fileprivate func getTitle(_ section: Int) -> String {
        return self.titleConfig[section]["title"]! as! String
    }
    
    fileprivate func getToolViewInfoItems(_ section: Int) -> [RowInfo] {
        return self.titleConfig[section]["items"]! as! [RowInfo]
    }
    
    fileprivate func getRowInfo(_ section: Int, _ row: Int) -> RowInfo {
        return self.getToolViewInfoItems(section)[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DLog(message: "viewDidLoad")
        
        self.title = LocalizedStrings.UTILITIES
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.tableView = UITableView(frame: view.frame, style: .grouped)
        self.tableView.alwaysBounceVertical = true
//        self.tableView.can
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DLog(message: "awakeFromNib")
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
        let rowInfo = getRowInfo(indexPath.section, indexPath.row)
        //        vc.title =
        
        rowInfo.action(self);
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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
