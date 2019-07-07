//
//  CameraScanViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/9/7.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraScanViewController: UIViewController {
    //    let captureSession = AVCaptureSession()
    //  视频输入设备，前后摄像头
    var camera: AVCaptureDevice?
    @IBOutlet weak var borderHeight: NSLayoutConstraint!
    @IBOutlet weak var qrcodeImageView: UIImageView!
    //    @IBOutlet weak var cjbTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var infomationTextView: UITextView!
    private let layer = CAShapeLayer()
    private lazy var input : AVCaptureDeviceInput? = nil
    private lazy var session : AVCaptureSession = AVCaptureSession()
    
    private var photosPicker: PhotosPicker!;
    
    var callback: ((String) -> Void)?
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
        
        self.title = "Scan"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: LocalizedStrings.CLOSE, style: .plain, target: self, action: #selector(self.close(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizedStrings.ABLUM, style: .plain, target: self, action: #selector(self.openAblum(sender:)))
        
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
//        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = .black
//        self.navigationController?.navigationBar.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        let statusBar = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        statusBar.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        photosPicker = PhotosPicker(vc: self)
        
        scanQRCode()
    }

    @IBAction private func openAblum(sender: AnyObject) {
        photosPicker.pick(completion: { image in
            let text = FindFirstQRCode(cyhImage: image)
            self.infomationTextView.text = text ?? "nil"
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let statusBar = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        statusBar.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
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
    func clearLayers() -> () {
        layer.removeFromSuperlayer()
    }
    
    //    对二维码进行描边
    func drawLines(object : AVMetadataMachineReadableCodeObject) -> () {
        //   1.进行安全校验，看是否有数据
        let array = object.corners
        if array.count == 0 {
            return
        }
        drawOutlines(in: layer, object: object)
        previewLayer.addSublayer(layer)
    }
    
    @IBAction private func close(sender: AnyObject) {
        let statusBar = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion:nil)
    }
}

extension CameraScanViewController : AVCaptureMetadataOutputObjectsDelegate
{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    {
        clearLayers()
        if let o = metadataObjects.first {
            DLog(message: "检测到二维码")
            let text:String = (o as AnyObject).stringValue
            infomationTextView.text = text
            let object = previewLayer.transformedMetadataObject(for: o) as! AVMetadataMachineReadableCodeObject
            // 3.对扫描到的二维码进行描边
            drawLines(object:object)
            
            callback?(text)
        }
    }
}
