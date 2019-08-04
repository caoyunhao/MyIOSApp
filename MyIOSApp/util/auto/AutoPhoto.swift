//
//  AutoCamera.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/10.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


class AutoPhoto: NSObject, AutoProtocol {
    func load() {
        
    }
    
    func stop() {
        
    }
    
    private var device: AVCaptureDevice?
    private var input: AVCaptureDeviceInput?
    private var output: AVCapturePhotoOutput?
    private var session: AVCaptureSession?
    
    func openSettings(action: UIAlertAction) {
        let settingsURL:NSURL = NSURL(string:UIApplicationOpenSettingsURLString)!
        UIApplication.shared.open(settingsURL as URL, completionHandler:nil)
    }
    
    func start() {
        openCamera()
        let thread:Thread = Thread {
            DLog("Thread")
            Thread.sleep(forTimeInterval: 1)
            self.takePhotoAction()
        }
        thread.start()
    }
    
    private func openCamera() {
        DLog("open camera 1")
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { success in
            if !success {
//                let alertVC = UIAlertController(title: "相机权限未开启", message: "请您到 设置->隐私->相机 开启访问权限", preferredStyle: .actionSheet)
//                alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: self.openSettings))
//                self.present(alertVC, animated: true, completion: nil)
                exit(0)
            }
        }
        DLog("open camera 2")
        if let _d = cameraWithPosistion(.front) {
            device = _d
            DLog("open camera 3")
        }
        //        if device.isExposureModeSupported(AVCaptureExposureModeAutoExpose){
        //            device.exposureMode = AVCaptureExposureModeAutoExpose;
        //        }
        input = try? AVCaptureDeviceInput(device: device!)
        guard input != nil else {
            return
        }
        output = AVCapturePhotoOutput()
        session = AVCaptureSession()
        session?.beginConfiguration()
        if session!.canAddInput(input!) {
            session!.addInput(input!)
        }
        if session!.canAddOutput(output!) {
            session!.addOutput(output!)
        }
        session?.commitConfiguration()
        DLog("session?.startRunning()")
        session?.startRunning()
    }
    
    private func cameraWithPosistion(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let type = AVCaptureDevice.DeviceType(rawValue: "AVCaptureDeviceTypeBuiltInWideAngleCamera")
        if let _device = AVCaptureDevice.default(type, for: AVMediaType.video, position: position) {
            return _device
        }
        else {
            return nil
        }
    }
    
    @objc private func takePhotoAction() {
        DLog("takePhotoAction")
        let connection = output?.connection(with: AVMediaType.video)
        guard connection != nil else {
            return
        }
        let photoSettings = AVCapturePhotoSettings()
        output?.capturePhoto(with: photoSettings, delegate: self)
        
//        let alertVC = UIAlertController(title: "保存成功！", message: "", preferredStyle: .actionSheet)
//        alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
//        self.present(alertVC, animated: true, completion: nil)
    }
}

@available(iOS 10.0, *)
extension AutoPhoto: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
//        if error != nil {
//            DLog("error = \(String(describing: error?.localizedDescription))")
//            return
//        }
//        if let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer){
//            //                picData = imageData
//            //                showImageContainerView?.isHidden = false
//            //                showImageView?.image = UIImage(data: imageData)
//            //                if TGPhotoPickerConfig.shared.saveImageToPhotoAlbum{
//            self.saveImageToPhotoAlbum(UIImage(data: imageData)!)
//        }
//    }
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        self.saveImageToPhotoAlbum(UIImage(data: imageData!)!)
    }
    
    fileprivate func saveImageToPhotoAlbum(_ savedImage:UIImage){
        DLog("saveImageToPhotoAlbum")
        UIImageWriteToSavedPhotosAlbum(savedImage, self, #selector(self.imageDidFinishSavingWithErrorContextInfo), nil)
    }
    
    @objc fileprivate func imageDidFinishSavingWithErrorContextInfo(image:UIImage,error:NSError?,contextInfo:UnsafeMutableRawPointer?){
        
        //        let msg = (error != nil) ? ("("+(error?.localizedDescription)!+")") : "保存成功"
        //        if error == nil{
        //            return
        //        }
        //        let alert =  UIAlertView(title: , message: msg, delegate: self, cancelButtonTitle: TGPhotoPickerConfig.shared.confirmTitle)
        //        alert.show()
        
    }
}
