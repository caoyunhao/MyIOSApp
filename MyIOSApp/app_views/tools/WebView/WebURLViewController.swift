//
//  WebURLViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/8/2.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class WebURLViewController: UIViewController {
    
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var openButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        openButton.addOnClickListener(target: self, action: #selector(self.open))
        // Do any additional setup after loading the view.
    }
    
    @objc
    func open() {
        let vc = CommonUtils.loadNib(ofViewControllerType: DouyinViewController.self)
        as! DouyinViewController
        if let path = urlField.text, let url = URL(string: path) {
            vc.url = url
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            hidesBottomBarWhenPushed = false
        } else {
            UINotice(text: "no url").show()
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
