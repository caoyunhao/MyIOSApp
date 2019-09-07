//
//  DouyinViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/8/2.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit
import Photos
import WebKit
import SafariServices

class DouyinViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var url: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提取", style: .plain, target: self, action: #selector(self.extract(sender:)))
        
        
//        webView = WKWebView(frame: view.frame)
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressWeb(sender:)))
        longPress.delegate = self
        webView.addGestureRecognizer(longPress)
        
        webView.uiDelegate = self
    
//        webView.configuration.userContentController
        webView.load(URLRequest(url: url))
        
        DLog(webView.url)
        // Do any additional setup after loading the view.
    }
    
    @objc
    func extract(sender: AnyObject) {
        let c = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        c.addAction(UIAlertAction(title: "Open Video in New Tab", style: .default, handler: { (action) in
            self.loadVideo()
        }))
        c.addAction(UIAlertAction(title: "Save Video", style: .default, handler: { (action) in
            self.saveVideo()
        }))
        c.addAction(UIAlertAction(title: "Copy Link", style: .default) { (action) in
            if let url = self.webView.url?.absoluteString {
                UINotice(text: url).show()
                UIPasteboard.general.string = url
            }
        })
        c.addAction(UIAlertAction(title: LocalizedStrings.CANCEL, style: .cancel, handler: { (action) in
            
        }))
        self.present(c, animated: true, completion: nil)
    }
    
    func loadVideo() {
        self.webView.evaluateJavaScript("""
        document.querySelector('video').getAttribute('src')
        """, completionHandler: { (result, error) in
            if let urlStr = result as? String, let url = URL(string: urlStr) {
                let vc = CommonUtils.loadNib(ofViewControllerType: DouyinViewController.self) as! DouyinViewController
                vc.url = url
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                self.hidesBottomBarWhenPushed = false
            } else {
                UINotice(text: "no video url").show()
            }
        })
    }
    
    func saveVideo() {
        if let url = webView.url {
            self.downloadVideo(url: url)
        } else {
            UINotice(text: "no video").show()
        }
    }
    
    func downloadVideo(url: URL) {
//        DispatchQueue.global(qos: .background).async {
//            if let data = NSData(contentsOf: url) {
//                let path = NSTemporaryDirectory() + "/temp.mp4"
//                let url = URL(fileURLWithPath: path)
//                let fm = FileManager.default
//                if fm.fileExists(atPath: path) {
//                    try? fm.removeItem(atPath: path)
//                }
//                data.write(to: url, atomically: true)
//                DispatchQueue.main.async {
//                    PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL:url)
//                    }) { completed, error in
//                        if completed {
//                            DLog("Video is saved!")
//                        } else {
//                            DLog("error: \(error?.localizedDescription)")
//                        }
//                    }
//                }
//            }
//        }
        
//        let input = InputStream(url: url)
        let downloader = Downloader(url: url)
        downloader.start()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc
    func longPressWeb(sender: UILongPressGestureRecognizer){
        if(sender.state != .began){return;}
        let touchPoint = sender.location(in: webView);
        let html = """
        document.elementFromPoint(\(touchPoint.x),\(touchPoint.y)).outerHTML
        """
        DLog("html: \(html)")
        self.webView.evaluateJavaScript(html, completionHandler: { (result, error) in
            if let element = result as? String {
                DLog("yes has \(element)  \(type(of: element))");
                if element.contains("<iframe")  {
//                    let parser = HTMLPar
                }
            } else {
                DLog("no hasnot");
            }
        })
    }
}

extension DouyinViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';", completionHandler: nil)
    }
}

extension DouyinViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
