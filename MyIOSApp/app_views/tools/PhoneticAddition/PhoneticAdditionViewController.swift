//
//  PhoneticAdditionViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/18.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

class PhoneticAdditionViewController: UIViewController {

    @IBOutlet weak var contentView: UIScrollView!
    @IBOutlet weak var phoneticButton: UIButton!
    @IBOutlet weak var callerlocButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.alwaysBounceVertical = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        ConstraintUtil.alignCompletely(view, child: contentView)
        
        LayoutUtil.verticalCenterView(subViews: [phoneticButton, callerlocButton], at: contentView, offset: 20)
        
        navigationItem.largeTitleDisplayMode = .never
        title = "Add Phonetic"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction
    func phoneticAction() {
        ContactsUtil().phonetic()
    }
    
    @IBAction
    func callerlocAction() {
        ContactsUtil().callerloc()
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
