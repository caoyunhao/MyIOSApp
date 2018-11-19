//
//  MessageViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/9/5.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    @IBOutlet weak var contentView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    
    var message: MessageItem!

    override func viewDidLoad() {
        contentView.alwaysBounceVertical = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        ConstraintUtil.alignCompletely(view, child: contentView)
        
        LayoutUtil.verticalCenterView(subViews: [textView], at: contentView, offset: 20)
        ConstraintUtil.setHeight(textView, 300, where: contentView)
        ConstraintUtil.alignLeft(textView, to: contentView, where: contentView, offset: 20)
        ConstraintUtil.alignRight(textView, to: contentView, where: contentView, offset: 20)
        
        navigationItem.largeTitleDisplayMode = .never
        
        textView.text = message.text
        title = DateUtils.stringWithType1(date: message.creationTime)
        
        super.viewDidLoad()

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
