//
//  PhotosHelper.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/30.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class PhotosPickerHelper: NSObject {
    var pickCallback: ((_ gifPhoto: GifPhoto) -> Void)?
    
    var vc: UIViewController
    
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    static func albumsViewController(completeHandler: @escaping ([PHAsset]) -> Void) -> AlbumsViewController {
        let vc = CommonUtil.loadNib(ofViewControllerType: AlbumsViewController.self) as! AlbumsViewController
        
        vc.completeHandler = completeHandler
        return vc
    }
    
    func pick(completion: @escaping (_ gifPhoto: GifPhoto) -> Void) {
        PHPhotoLibrary.requestAuthorization({(status) in
            
        })
        self.pickCallback = completion
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = .photoLibrary
            //设置是否允许编辑
            picker.allowsEditing = false
            //弹出控制器，显示界面
            self.vc.present(picker, animated: true, completion: nil)
        }else{
            DLog(message: "读取相册错误")
        }
    }
}

extension PhotosPickerHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //选择图片成功后代理
    @objc internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //查看info对象
        // DLog(message: "info: \(info)")
//        if self.canEdit {
//            //获取编辑后的图片
//            pickedSelectedImage = info[UIImagePickerControllerEditedImage] as! UIImage
//        } else {
//            //获取选择的原图
//            pickedSelectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        }
        //        let url = info[UIImagePickerControllerImageURL] as! NSURL
        let asset = info[UIImagePickerControllerPHAsset] as! PHAsset
        
        //        let fetchOptions = PHFetchOptions()
        //        fetchOptions.
        //        PHAsset.fetchAssets
        //
        //        let manager = PHImageManager.default()
        //        let requestOptions = PHImageRequestOptions()
        //        manager.
        
        //图片控制器退出
        picker.dismiss(animated: true, completion: nil)
        
        AssetsUtils.dataFrom(imageAsset: asset) { (data) in
            DLog(message: "imageAsset size: \(data.count)")

            GifUtil.gifFrom(data: data, handler: { (photo) in
                self.pickCallback?(photo)
            })

        }
    }
}

