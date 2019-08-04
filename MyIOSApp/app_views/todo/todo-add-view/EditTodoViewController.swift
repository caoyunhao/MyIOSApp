//
//  EditTodoViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/19.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class EditTodoViewController: ScrollViewController {
    
    @IBOutlet weak var inputTable1: FieldTableView!

    override func viewDidLoad() {
        DLog("viewDidLoad")
        super.viewDidLoad()
        
        title = "新增任务"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.close))
        
        inputTable1.fields = [
            FieldTableView.Field(name: "1", placeholder: NSAttributedString(string: "项目", attributes: nil)),
            FieldTableView.Field(name: "2", placeholder: NSAttributedString(string: "任务", attributes: nil)),
        ]
        inputTable1.viewDidLoad()
        inputTable1.reloadData()

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
    
    @objc
    func close(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
