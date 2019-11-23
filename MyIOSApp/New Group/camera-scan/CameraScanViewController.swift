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
    
    private let sender = NSObject()
    
    private var photosPicker: PhotosPicker!;
    
    var callback: ((String) -> Void)?
    
    lazy var previewLayer : AVCaptureVideoPreviewLayer = {
        let previewLayer : AVCaptureVideoPreviewLayer =  AVCaptureVideoPreviewLayer(session: self.session)
        previewLayer.frame = UIScreen.main.bounds
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }()
    
    // MARK:  方法
    override func viewDidLoad() {
        DLog("viewDidLoad")
        super.viewDidLoad()
        
        photosPicker = PhotosPicker(vc: self)
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(startRunning), name: .UIApplicationDidBecomeActive, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(stopRunning), name: .UIApplicationWillResignActive, object: nil)
        
        setUI()
        
        DispatchQueue.main.async {
            self.setupQRCodeScanner()
            self.startRunning()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopRunning()
    }
    
    private func setUI() {
        self.title = "Scan"
        self.view.backgroundColor = .black
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: LocalizedStrings.CLOSE, style: .plain, target: self, action: #selector(self.close(sender:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizedStrings.ABLUM, style: .plain, target: self, action: #selector(self.openAblum(sender:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.getStatusBarView()?.tintColor = .white
        
        
        view.addSubview(ScanView(frame: UIScreen.main.bounds))
        view.bringSubview(toFront: self.infomationTextView)
        self.infomationTextView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.infomationTextView.textColor = UIColor(white: 0.7, alpha: 1.0)
    }
    
    private func getStatusBarView() -> UIView? {
        if #available(iOS 13.0, *) {
            if let keyWindow = (UIApplication.shared.windows.filter    {$0.isKeyWindow}).first {
                if let statusBar = keyWindow.viewWithTag(38782) {
                    return statusBar
                } else {
                    if let statusBarFrame =                          keyWindow.windowScene?.statusBarManager?.statusBarFrame {
                        let view = UIView(frame: statusBarFrame)
                        view.tag = 38482
                        keyWindow.addSubview(view)
                        return view
                    }
                }
            }
            return nil
        } else {
            return UIApplication.shared.value(forKey: "statusBar") as? UIView
        }
    }
    
    //    扫描二维码
    func setupQRCodeScanner() {
        // 对懒加载的input进行赋值
        let metadataOutput = AVCaptureMetadataOutput()
        
        guard let device = GetCaptureDevice(withPosition: .back) else {
            DLog("device == nil")
            return
        }
        
        if let input = try? AVCaptureDeviceInput(device: device) {
            self.session.addInput(input)
        } else {
            DLog("input == nil")
            return
        }
        
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
        } else {
            DLog("canAddOutput = false")
        }
        
        // 设置输出能够解析的数据类型
        metadataOutput.metadataObjectTypes = [.qr]
        // 设置监听监听解析到的数据类型
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

        view.layer.insertSublayer(previewLayer, at: 0)
    }
    
    @objc
    private func startRunning() {
        DLog("startRunning")
        session.startRunning()
    }
    
    @objc
    private func stopRunning() {
        DLog("stopRunning")
        session.stopRunning()
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
        
        layer.frame = UIScreen.main.bounds
        layer.borderWidth = 2
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        
        drawOutlines(in: layer, object: object)
        previewLayer.addSublayer(layer)
    }
    
    @IBAction private func openAblum(sender: AnyObject) {
        photosPicker.pick(completion: { image in
            let text = FindFirstQRCode(cyhImage: image)
            self.infomationTextView.text = text ?? "nil"
        })
    }
    
    @IBAction private func close(sender: AnyObject) {
        getStatusBarView()?.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion:nil)
    }
}

extension CameraScanViewController : AVCaptureMetadataOutputObjectsDelegate
{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    {
        clearLayers()
        if let o = metadataObjects.first {
            let text:String = (o as AnyObject).stringValue
            infomationTextView.text = text
            let object = previewLayer.transformedMetadataObject(for: o) as! AVMetadataMachineReadableCodeObject
            // 3.对扫描到的二维码进行描边
            drawLines(object:object)
            
            callback?(text)
        }
    }
}

private class ScanView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // 阴暗区域
        UIColor(white: 0, alpha: 0.618).setFill()
        UIRectFill(rect)
        // 明亮区域
        UIColor.clear.setFill()
        let frame = ScanView.computeSmallFrame(fullFrame: rect.size)
        UIRectFill(frame)
        
        ScanView.drawBoard(rect: frame)
    }
    
    private static func computeSmallFrame(fullFrame: CGSize) -> CGRect {
        let fullWidth = fullFrame.width
        let size = fullWidth * 0.618
        
        let xstart = (fullWidth - size) * 0.5
        let ystart =  (fullFrame.height - size) * 0.39
        
        return CGRect(x: xstart, y: ystart, width: size, height: size)
    }
    
    private static func drawBoard(rect: CGRect) {
        let scanner_borderWidth: CGFloat = 0.5
        let scanner_cornerWidth: CGFloat = 3.0
        let scanner_cornerLength: CGFloat = 20.0
        
        let scanner_x = rect.origin.x
        let scanner_y = rect.origin.y
        let scanner_width = rect.width
        
        // 边框
        let borderPath = UIBezierPath(rect: CGRect(x: scanner_x, y: scanner_y, width: scanner_width, height: scanner_width))
        borderPath.lineCapStyle = .round
        borderPath.lineWidth = scanner_borderWidth
        UIColor.white.set()
        borderPath.stroke()
        
        for index in 0...3 {
            let tempPath = UIBezierPath()
            tempPath.lineWidth = scanner_cornerWidth
            UIColor(red: 63/255.0, green: 187/255.0, blue: 54/255.0, alpha: 1.0).set()
            
            switch index {
            // 左上角棱角
            case 0:
                tempPath.move(to: CGPoint(x: scanner_x + scanner_cornerLength, y: scanner_y))
                tempPath.addLine(to: CGPoint(x: scanner_x, y: scanner_y))
                tempPath.addLine(to: CGPoint(x: scanner_x, y: scanner_y + scanner_cornerLength))
            // 右上角
            case 1:
                tempPath.move(to: CGPoint(x: scanner_x + scanner_width - scanner_cornerLength, y: scanner_y))
                tempPath.addLine(to: CGPoint(x: scanner_x + scanner_width, y: scanner_y))
                tempPath.addLine(to: CGPoint(x: scanner_x + scanner_width, y: scanner_y + scanner_cornerLength))
            // 左下角
            case 2:
                tempPath.move(to: CGPoint(x: scanner_x, y: scanner_y + scanner_width - scanner_cornerLength))
                tempPath.addLine(to: CGPoint(x: scanner_x, y: scanner_y + scanner_width))
                tempPath.addLine(to: CGPoint(x: scanner_x + scanner_cornerLength, y: scanner_y + scanner_width))
            // 右下角
            case 3:
                tempPath.move(to: CGPoint(x: scanner_x + scanner_width - scanner_cornerLength, y: scanner_y + scanner_width))
                tempPath.addLine(to: CGPoint(x: scanner_x + scanner_width, y: scanner_y + scanner_width))
                tempPath.addLine(to: CGPoint(x: scanner_x + scanner_width, y: scanner_y + scanner_width - scanner_cornerLength))
            default:
                break
            }
            tempPath.stroke()
        }
    }
}
