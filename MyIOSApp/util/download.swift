//
//  download.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/8/2.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import Foundation

class Downloader: NSObject {
    private var task: URLSessionDownloadTask!
    private var session: URLSession!
    private var notice: UINotice
    private var queue: DispatchQueue
    
    init(url: URL, session: URLSession? = nil) {
        self.session = nil
        self.task = nil
        self.queue = DispatchQueue(label: "Downloader", qos: .unspecified, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        let op = UINotice.Options()
        op.hasProgress = true
        op.autoLayout = false
        op.autoCleanTimeInterval = -1
        notice = UINotice(text: "Start downloading", options: op)
        super.init()
        self.session = session ?? {
            let configuration = URLSessionConfiguration.default
            configuration.isDiscretionary = true //自由决定选择哪种网络状态进行下载数据
            let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
            return session
        }()
        self.task = self.session.downloadTask(with: URLRequest(url: url))
    }
    
    func start() {
        notice.show()
        self.task.resume()
    }
    
    func stop() {
        self.task.cancel()
    }
}

extension Downloader: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let path = NSTemporaryDirectory() + "/temp.mp4"
        if FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.removeItem(atPath: path)
        }
        let url = URL(fileURLWithPath: path)
        try! FileManager.default.moveItem(at: location, to: url)
        DispatchQueue.main.async {
            AssetsUtils.saveVideo(atFileURL: url)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            self.notice.progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            self.notice.text = "\(totalBytesWritten)/\(totalBytesExpectedToWrite)"
            self.notice.layout()
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DLog("error: \(String(describing: error))")
        DispatchQueue.main.async {
            self.notice.hide()
        }
    }
}
