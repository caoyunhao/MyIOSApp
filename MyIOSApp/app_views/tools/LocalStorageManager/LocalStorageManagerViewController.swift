//
//  LocalStorageManagerViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/9/1.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

class LocalStorageManagerViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIScrollView!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var clearMessagesButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = "Move Assets"
        contentView.alwaysBounceVertical = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        ConstraintUtil.alignCompletely(view, child: contentView)
        
        LayoutUtil.verticalCenterView(subViews: [clearAllButton, clearMessagesButton], at: contentView, offset: 20)
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
    @IBAction
    func clearAllAction() {
        UserDefaultsUtils.cleanAll()
    }
    
    @IBAction
    func clearMessagesAction() {
        PastboardHistory.shared.clean()
    }
}
