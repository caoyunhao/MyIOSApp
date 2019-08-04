//
//  SwitchTableCell.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/19.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class SwitchTableCell: SimpleRowTableCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
    var data: SimpleSwitchRowData!
    
    private var _isOn: Bool!
    var isOn: Bool {
        return data.isOn
    }
    
    override func load(vc: UIViewController, rawData: SimpleRowData) {
        super.load(vc:vc, rawData: rawData)
        guard let data = rawData as? SimpleSwitchRowData else {
            return
        }
        self.data = data
        label.text = self.data.name
        `switch`.isOn = self.data.isOn
        
        `switch`.addTarget(self, action: #selector(self.switchDidChange), for: .valueChanged)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc
    func switchDidChange(_ sender: UISwitch) {
        self.data.isOn = sender.isOn
    }
}
