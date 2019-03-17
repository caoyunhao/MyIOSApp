//
//  AutoRecord.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/10.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class AutoRecording: NSObject, AutoProtocol {
    //  最常视频录制时间，单位 秒
    let MaxVideoRecordTime = 6000
    
    //  MARK: - Properties ，
    //  视频捕获会话，他是 input 和 output 之间的桥梁，它协调着 input 和 output 之间的数据传输
    let captureSession = AVCaptureSession()
    //  视频输入设备，前后摄像头
    var camera: AVCaptureDevice?
    //  展示界面
//    var previewLayer: AVCaptureVideoPreviewLayer!
    //  HeaderView
//    var headerView: UIView!
    
    //  音频输入设备
    let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
    //  将捕获到的视频输出到文件
    let fileOutput = AVCaptureMovieFileOutput()

    //  录制时间Timer
    var timer: Timer?
    var secondCount = 0
    
    //  表示当时是否在录像中
    var isRecording = false
    
    public func load() {
        self.setupAVFoundationSettings()
    }
    
    //  MARK: - Private Methods
    func setupAVFoundationSettings() {
        camera = cameraWithPosition(position: .front)
        
        //  设置视频清晰度，这里有很多选择
        // captureSession.sessionPreset = AVCaptureSessionPreset640x480
        
        //  添加视频、音频输入设备
        if let videoInput = try? AVCaptureDeviceInput(device: self.camera!) {
            self.captureSession.addInput(videoInput)
        }
        if let audioInput = try? AVCaptureDeviceInput(device: self.audioDevice!) {
            self.captureSession.addInput(audioInput)
        }
        
        //  添加视频捕获输出
        self.captureSession.addOutput(fileOutput)
        
        //  使用 AVCaptureVideoPreviewLayer 可以将摄像头拍到的实时画面显示在 ViewController 上
//        let videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
//        videoLayer.frame = view.bounds
//        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        view.layer.addSublayer(videoLayer)
        
//        previewLayer = videoLayer
        
        //  启动 Session 回话
        print("startRunning")
        self.captureSession.startRunning()
    }
    
    
    
    func start() {
//        hiddenHeaderView(true)
        
        //  开启计时器
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(videoRecordingTotolTime), userInfo: nil, repeats: true)
        
        if !isRecording {
            //  记录状态： 录像中 ...
            isRecording = true
            captureSession.startRunning()

            //  设置录像保存地址，在 Documents 目录下，名为 当前时间.mp4
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentDirectory = path[0] as String
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyyMMddHHmmss"
            let filePath: String? = "\(documentDirectory)/\(dformatter.string(from: Date())).mp4"
            let fileUrl: NSURL? = NSURL(fileURLWithPath: filePath!)
            //  启动视频编码输出
            self.fileOutput.startRecording(to: fileUrl! as URL, recordingDelegate: self)
            
            //  开始、结束按钮改变颜色
//            startButton.backgroundColor = UIColor.lightGrayColor()
//            stopButton.backgroundColor = UIColor.redColor()
//            startButton.userInteractionEnabled = false
//            stopButton.userInteractionEnabled = true
        }
        
        let t = Thread {
            print("Thread")
            Thread.sleep(forTimeInterval: 5)
            self.stop()
        }
        t.start()
    }
    
    func stop() {
//        hiddenHeaderView(false)
        //  关闭计时器
        timer?.invalidate()
        timer = nil
        secondCount = 0
        
        if isRecording {
            //  停止视频编码输出
            captureSession.stopRunning()
            
            //  记录状态： 录像结束 ...
            isRecording = false
            
            //  开始结束按钮颜色改变
//            startButton.backgroundColor = UIColor.redColor()
//            stopButton.backgroundColor = UIColor.lightGrayColor()
//            startButton.userInteractionEnabled = true
//            stopButton.userInteractionEnabled = false
        }
        print("stop")
    }
    
    @objc func videoRecordingTotolTime() {
        secondCount += 1
        
        //  判断是否录制超时
        if secondCount == MaxVideoRecordTime {
//            timer?.invalidate()
//            let alertC = UIAlertController(title: "最常只能录制十分钟呢", message: nil, preferredStyle: .Alert)
//            alertC.addAction(UIAlertAction(title: "确定", style: .Cancel, handler: nil))
//            self.presentViewController(alertC, animated: true, completion: nil)
        }
        
//        let hours = secondCount / 3600
//        let mintues = (secondCount % 3600) / 60
//        let seconds = secondCount % 60
//
//        totolTimeLabel.text = String(format: "%02d", hours) + ":" + String(format: "%02d", mintues) + ":" + String(format: "%02d", seconds)
    }
    
    func changeCamera() {
//        cameraSideButton.isSelected = !cameraSideButton.isSelected
        captureSession.stopRunning()
        //  首先移除所有的 input
        if let  allInputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in allInputs {
                captureSession.removeInput(input)
            }
        }
        
//        changeCameraAnimate()
        
        //  添加音频输出
        if let audioInput = try? AVCaptureDeviceInput(device: self.audioDevice!) {
            self.captureSession.addInput(audioInput)
        }
        
        if true {
            camera = cameraWithPosition(position: .front)
            if let input = try? AVCaptureDeviceInput(device: camera!) {
                captureSession.addInput(input)
            }
            
        } else {
            camera = cameraWithPosition(position: .back)
            if let input = try? AVCaptureDeviceInput(device: camera!) {
                captureSession.addInput(input)
            }
        }
    }
}

@available(iOS 10.0, *)
extension AutoRecording: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("fileOutput")
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL as URL)
        }, completionHandler: { (isSuccess: Bool, error: Error?) in
            DispatchQueue.main.async {
                //弹出提示框
                //                let alertController = UIAlertController(title: message, message: nil,
                //                                                        preferredStyle: .alert)
                //                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                //                alertController.addAction(cancelAction)
                //                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
}

func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
    let deviceDescoverySession = AVCaptureDevice.DiscoverySession.init(
        deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
        mediaType: AVMediaType.video, position: position)
    
    for device in deviceDescoverySession.devices {
        if device.position == position {
            return device
        }
    }
    return nil
}
    
//    func captureOutput(captureOutput: AVCaptureFileOutput!,
//                       didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!,
//                       fromConnections connections: [AVCaptureConnection]!, error: NSError!) {
////        var message:String!
//        //将录制好的录像保存到照片库中
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL as URL)
//        }, completionHandler: { (isSuccess: Bool, error: Error?) in
////            if isSuccess {
////                message = "保存成功!"
////            } else{
////                message = "保存失败：\(error!.localizedDescription)"
////            }
////
//            DispatchQueue.main.async {
//                //弹出提示框
////                let alertController = UIAlertController(title: message, message: nil,
////                                                        preferredStyle: .alert)
////                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
////                alertController.addAction(cancelAction)
////                self.present(alertController, animated: true, completion: nil)
//            }
//        })
//    }
