//
//  AlbumsViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/4.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import Photos

//相簿列表项
struct ImageAlbumItem {
    //相簿名称
    var title:String?
    //相簿内的资源
    var fetchResult: PHFetchResult<PHAsset>
}


class AlbumsViewController: UIViewController {
    let cellIdentifier = "AlbumsViewCell"
    
    private var items:[ImageAlbumItem] = []
    
    private var tableView: UITableView!
    
    var maxSelected:Int = 4
    var autoClose: Bool = false
    var completeHandler:((_ assets:[PHAsset])->())?
    var type: PHAssetMediaType = .image
    var subTypes: [PHAssetMediaSubtype] = []
    
    override func awakeFromNib() {
        DLog(message: "11111111")
        super.awakeFromNib()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Albums"
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        self.view.addSubview(self.tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        ConstraintUtil.alignCompletely(self.view, child: self.tableView)
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.close)),
        ]
        
        //申请权限
        PHPhotoLibrary.requestAuthorization({ (status) in
            if status != .authorized {
                AlertUtils.biAction(vc: self, message: "请允许我访问您的图库", leftTitle: "算了", rightTitle: "允许", leftAction: {
                    self.dismiss(animated: true, completion: nil)
                }, rightAction: {
                    self.dismiss(animated: true, completion: nil)
                    SystemUtils.openApplicationSetting()
                })
                return
            }
            
            // 列出所有系统的智能相册
            let smartOptions = PHFetchOptions()
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                      subtype: .albumRegular,
                                                                      options: smartOptions)
            self.convertCollection(collection: smartAlbums)
            
            //列出所有用户创建的相册
            let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            self.convertCollection(collection: userCollections as! PHFetchResult<PHAssetCollection>)
            
            //相册按包含的照片数量排序（降序）
            self.items.sort { (item1, item2) -> Bool in
                return item1.fetchResult.count > item2.fetchResult.count
            }
            
            //异步加载表格数据,需要在主线程中调用reloadData() 方法
            DispatchQueue.main.async{
                DLog(message: self.items.count)
                self.tableView.reloadData()
                
                //                //首次进来后直接进入第一个相册图片展示页面（相机胶卷）
                //                if let imageCollectionVC = self.storyboard?
                //                    .instantiateViewController(withIdentifier: "hgImageCollectionVC")
                //                    as? HGImageCollectionViewController{
                //                    imageCollectionVC.title = self.items.first?.title
                //                    imageCollectionVC.assetsFetchResults = self.items.first?.fetchResult
                //                    imageCollectionVC.completeHandler = self.completeHandler
                //                    imageCollectionVC.maxSelected = self.maxSelected
                //                    self.navigationController?.pushViewController(imageCollectionVC,
                //                                                                  animated: false)
                //                }
            }
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //页面跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


 

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
    //转化处理获取到的相簿
    private func convertCollection(collection: PHFetchResult<PHAssetCollection>){
        for i in 0..<collection.count{
            //获取出但前相簿内的图片
            let resultsOptions = PHFetchOptions()
            
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            resultsOptions.predicate = self.generateMediaPredicate(type: type, subTypes: subTypes)
            
            let c = collection[i]
            let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
            //没有图片的空相簿不显示
            if assetsFetchResult.count > 0 {
                let title = titleOfAlbumForChinse(title: c.localizedTitle)
                DLog(message: title)
                items.append(ImageAlbumItem(title: title, fetchResult: assetsFetchResult))
            }
        }
    }
    
    //由于系统返回的相册集名称为英文，我们需要转换为中文
    private func titleOfAlbumForChinse(title:String?) -> String? {
        if title == "Slo-mo" {
            return "慢动作"
        } else if title == "Recently Added" {
            return "最近添加"
        } else if title == "Favorites" {
            return "个人收藏"
        } else if title == "Recently Deleted" {
            return "最近删除"
        } else if title == "Videos" {
            return "视频"
        } else if title == "All Photos" {
            return "所有照片"
        } else if title == "Selfies" {
            return "自拍"
        } else if title == "Screenshots" {
            return "屏幕快照"
        } else if title == "Camera Roll" {
            return "相机胶卷"
        }
        return title
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func generateMediaPredicate(type: PHAssetMediaType, subTypes: [PHAssetMediaSubtype]) -> NSPredicate {
        var strList: [String] = []
        
        for subType in subTypes {
            strList.append("(mediaSubtype & \(Int(subType.rawValue))) != 0 ")
        }
        
        let ret: NSPredicate!;
        if (strList.isEmpty) {
            ret = NSPredicate(format: "mediaType = %d", type.rawValue)
        } else {
            ret =  NSPredicate(format: "mediaType = %d && (\(strList.joined(separator: "||")))", type.rawValue)
//            ret = NSPredicate(format: strList.joined(separator: "||"))
        }
        
        DLog(message: ret)
        
        return ret;
    }
}

extension AlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AlbumsViewCell
        
        let item = self.items[indexPath.row]
        cell.nameLabel.text = "\(item.title ?? "") "
        //        cell.countLabel.text = "（\(item.fetchResult.count)）"
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AlbumsViewCell
        
        DLog(message: cell.nameLabel.text)
        
        
        
        let vc = CommonUtils.loadNib(ofViewControllerType: ImagesViewController.self) as! ImagesViewController
        
        vc.title = cell.nameLabel.text
        vc.maxSelected = self.maxSelected
        vc.autoClose = self.autoClose
        
        vc.completeHandler =  {indexes in
            self.completeHandler?(self.items[indexPath.row].fetchResult.objects(at: IndexSet(indexes)))
        }
        vc.assetsFetchResults = self.items[indexPath.row].fetchResult
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
