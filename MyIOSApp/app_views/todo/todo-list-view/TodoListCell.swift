//
//  TodoListCell.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/6/17.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class TodoListCell: UITableViewCell {
    @IBOutlet weak var box: UIView!
    var margin: CGFloat! = 10
    var cornerRadius: CGFloat! = 20
    
    var isFixed = false
    
    var data: Task? {
        didSet {
            titleTextField.text = data?.title
            detailTextField.text = data?.detail
            projectTextField.text = data?.projectName
            kindTextField.text = data?.kindName
        }
    }
    
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var kindTextField: UILabel!
    @IBOutlet weak var projectTextField: UILabel!
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var detailTextField: UILabel!
    
    override var frame: CGRect {
        set {
            var frame = newValue
//            frame.origin.x += margin;
            frame.origin.y += margin;
            frame.size.height -= margin;

//            frame.size.width -= margin * 2;
            super.frame = frame
        }
        get {
            return super.frame
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        box.frame.origin.x = margin
//        box.frame.size.width = box.frame.size.width - margin * 2
        
        // Initialization code
        backgroundColor = .clear
        
        box.layer.shadowOffset = CGSize(width: 10, height: 10)
        box.layer.shadowColor = UIColor.gray.cgColor
        box.layer.masksToBounds = false
        box.layer.cornerRadius = 6
        box.clipsToBounds = true

//        titleTextField.preferredMaxLayoutWidth = titleTextField.frame.size.width
        detailTextField.preferredMaxLayoutWidth = detailTextField.frame.size.width
        
//        detailTextField.lineBreakMode = .byTruncatingTail
//        detailTextField.numberOfLines = 0
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subView in subviews{
            if subView.isKind(of: NSClassFromString("UISwipeActionPullView")!){
                
                if subView.frame.width == 0 {isFixed = false;return}
                if isFixed {return}
                
                subView.frame = subView.frame.insetBy(dx: 0, dy: 85.5)
                subView.layer.cornerRadius = 74/2.0
                subView.layer.masksToBounds = true
                subView.layer.borderWidth = 5.0
                subView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
                isFixed = true
            }
        }
    }
    
    
    
}
