//
//  SimpleInputTableCell.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/21.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class SimpleInputTableCell: SimpleRowTableCell {
    
    @IBOutlet weak var textField: UITextField!
    
    private var data: SimpleInputTableCellData!
    
    override func load(vc: UIViewController, rawData: SimpleRowData) {
        super.load(vc:vc, rawData: rawData)
        guard let data = rawData as? SimpleInputTableCellData else {
            DLog("error")
            return 
        }
        self.data = data
        
        textField.text = data.inputValue
        if let str = data.placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: str, attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        }
        
        textField.addTarget(self, action: #selector(self.inputDone), for: .editingChanged)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if data.isFirstResponder {
             self.textField.becomeFirstResponder()
        }
    }
    
    @objc
    func inputDone(_ sender: UITextField) {
        data.inputValue = textField.text
    }
}
