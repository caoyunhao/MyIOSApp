//
//  BaseViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/12/29.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.alwaysBounceVertical = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        ConstraintUtil.alignCompletely(view, child: contentView)
        // Do any additional setup after loading the view.
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
