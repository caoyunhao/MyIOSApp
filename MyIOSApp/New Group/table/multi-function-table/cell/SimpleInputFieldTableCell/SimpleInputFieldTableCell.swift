//
//  SimpleInputFieldTableCell.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/21.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class SimpleInputFieldTableCell: SimpleRowTableCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    private var data: SimpleInputFieldTableCellData!
    
    override func load(vc: UIViewController, rawData: SimpleRowData) {
        super.load(vc: vc, rawData: rawData)
        
        data = (rawData as! SimpleInputFieldTableCellData)
        label.text = data.name
        textView.text = data.inputValue ?? ""
        textView.delegate = self
        
//        textView.addTarget(self, action: #selector(self.inputDone), for: .editingChanged)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(false, animated: animated)
        if selected {
            textView.becomeFirstResponder()
        }
        // Configure the view for the selected state
    }
    
}

extension SimpleInputFieldTableCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        data.inputValue = textView.text
    }
}
