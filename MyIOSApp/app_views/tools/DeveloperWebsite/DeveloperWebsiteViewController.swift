//
//  DeveloperWebsiteViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/9/1.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import WebKit

class DeveloperWebsiteViewController: UIViewController {
    
    var contentView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        contentView = WKWebView(frame: .zero, configuration: webConfiguration)
        contentView.uiDelegate = self
        contentView.navigationDelegate = self
//        view.addSubview(contentView)
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        contentView.uiDelegate = self
        navigationItem.largeTitleDisplayMode = .never
        
        let url = NSURL(string: "https://caoyunhao.com")
        /// 根据URL创建请求
        let requst = NSURLRequest(url: url! as URL)
        /// 设置代理
//        contentView.navigationDelegate = self
        /// WKWebView加载请求
        contentView.load(requst as URLRequest)
        
//        view = contentView

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DeveloperWebsiteViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                          didFinish navigation: WKNavigation!) {
        title = webView.title;
    }
}
