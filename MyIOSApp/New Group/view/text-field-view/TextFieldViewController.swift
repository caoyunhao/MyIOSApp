//
//  TextFieldViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/3/18.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class TextFieldViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextView!
    var text: String?
    var isPop: Bool = false;

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.alwaysBounceVertical = true
        navigationItem.largeTitleDisplayMode = .never
        
        textField.text = text ?? "(nil)"
        
        if (isPop) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.close))
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "复制", style: .plain, target: self, action: #selector(self.copyTo))
        // Do any additional setup after loading the view.
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @objc func copyTo() {
        UIPasteboard.general.string = text
        NoticeHUD(text: "Copied").show()
    }
}
