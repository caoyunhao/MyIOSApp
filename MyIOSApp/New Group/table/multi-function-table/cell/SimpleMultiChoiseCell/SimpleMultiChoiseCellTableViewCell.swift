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
    
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var selectedTextLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    override func load(vc: UIViewController, rawData: SimpleRowData) {
        super.load(vc:vc, rawData: rawData)
        guard let data = rawData as? SimpleMultiChoiseRawData else {
            return
        }
        data.cell = self
        self.data = data
        self.nameTextLabel.text = data.name
        self.selectedTextLabel.text = data.current?.name
        self.selectedImageView.image = data.current?.image
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
