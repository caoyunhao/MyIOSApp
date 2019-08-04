//
//  SimpleMultiChoiseCellTableViewCell.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/19.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class SimpleMultiChoiseCellTableViewCell: SimpleRowTableCell {
    var data: SimpleMultiChoiseRawData!
    
    override func load(vc: UIViewController, rawData: SimpleRowData) {
        super.load(vc:vc, rawData: rawData)
        guard let data = rawData as? SimpleMultiChoiseRawData else {
            return
        }
        data.cell = self
        self.data = data
        self.textLabel?.text = data.name
        self.detailTextLabel?.text = data.current?.name
        self.accessoryType = .disclosureIndicator
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        if selected {
            let vc = CommonUtils.loadNib(ofViewControllerType: SimpleMutilChoiseSelectionViewController.self) as! SimpleMutilChoiseSelectionViewController
            vc.data = data
            vc.title = self.data.name
            currentVC.navigationController?.pushViewController(vc, animated: true)
        }
        // Configure the view for the selected state
    }
    
    var result: String {
        return ""
    }
    
}
