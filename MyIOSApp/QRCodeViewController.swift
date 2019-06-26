//
//  QRCodeViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/13.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class QRCodeViewController: UIViewController {
//    let captureSession = AVCaptureSession()
    //  视频输入设备，前后摄像头
    var camera: AVCaptureDevice?
    @IBOutlet weak var borderHeight: NSLayoutConstraint!
    @IBOutlet weak var qrcodeImageView: UIImageView!
//    @IBOutlet weak var cjbTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var infomationLabel: UILabel!
    
    fileprivate let layer = CAShapeLayer()
    fileprivate lazy var input : AVCaptureDeviceInput? = nil
    fileprivate lazy var session : AVCaptureSession = AVCaptureSession()
    //  展示界面
    //    var previewLayer: AVCaptureVideoPreviewLayer!
    //  HeaderView
    //    var headerView: UIView!
    //  音频输入设备
    // let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
    //  将捕获到的视频输出到文件
//    let fileOutput = AVCaptureMovieFileOutput()
    
    
//    private lazy var metadataOutput : AVCaptureMetadataOutput = {
//        let out = AVCaptureMetadataOutput()
//        let rect = self.view.frame
//        let containerRect = self.containerView.frame
//
//        let x = containerRect.origin.y / rect.height
//        let y = containerRect.origin.x / rect.width
//        let w = containerRect.height / rect.height
//        let h = containerRect.width / rect.width
//
//        DLog(message: "x = \(x)")
//        DLog(message: "y = \(y)")
//        DLog(message: "w = \(w)")
//        DLog(message: "h = \(h)")
//
//        out.rectOfInterest = CGRect(x: x, y: y, width: w, height: h)
//
//        return out
//    }()
    
    lazy var previewLayer : AVCaptureVideoPreviewLayer = {
        let previewLayer : AVCaptureVideoPreviewLayer =  AVCaptureVideoPreviewLayer(session: self.session)
        previewLayer.frame = UIScreen.main.bounds
        return previewLayer
    }()
    
    // MARK:  方法
    override func viewDidLoad() {
        super.viewDidLoad()
        DLog(message: "QRCodeViewController")
        //self.view.bringSubview(toFront: self.cjbImageview)
        //self.view.bringSubview(toFront: self.infomationLabel)
        //开始扫描二维码
        scanQRCode()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    //    扫描二维码
    func scanQRCode() {
        
        // 对懒加载的input进行赋值
        let metadataOutput = AVCaptureMetadataOutput()
        
        guard let device = cameraWithPosition(position: .back) else {
            DLog(message: "device == nil")
            return
        }
        
        if let input = try? AVCaptureDeviceInput(device: device) {
            self.session.addInput(input)
        } else {
            DLog(message: "input == nil")
            return
        }
        
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
        } else {
            DLog(message: "canAddOutput = false")
        }
        
        // 设置输出能够解析的数据类型
        metadataOutput.metadataObjectTypes = [.qr]
        // 设置监听监听解析到的数据类型
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // 添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = view.bounds

        DLog(message: "session.startRunning()")
        session.startRunning()
    }
    
    //    清除layer的子视图
    func clearLayers() {
        layer.removeFromSuperlayer()
    }
    //    对二维码进行描边
    func drawLines(object : AVMetadataMachineReadableCodeObject) {
        //   1.进行安全校验，看是否有数据
        let array = object.corners
        if array.count == 0 {
            return
        }
        drawOutlines(in: self.layer, object: object)
        previewLayer.addSublayer(self.layer)
    }
    
    @IBAction private func close(sender: AnyObject) {
        self.dismiss(animated: true, completion:nil)
    }
}

extension QRCodeViewController : AVCaptureMetadataOutputObjectsDelegate
{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    {
        clearLayers()
        if let o = metadataObjects.first {
            DLog(message: "检测到二维码")
            let text:String = (o as AnyObject).stringValue
            infomationLabel.text = text
            let object = previewLayer.transformedMetadataObject(for: o) as! AVMetadataMachineReadableCodeObject
            // 3.对扫描到的二维码进行描边
            drawLines(object:object)
        }
    }
}
