//
//  PastboardHistroyViewCell.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/8/5.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class PastboardHistroyViewCell: UITableViewCell {
    
    var item: PasteboardHistoryItem! {
        didSet {
            if let string = item.text {
                textLabel1?.text = string
            }
            
            if let image = item.image {
                let imageView = UIImageView(image: image)
                self.addSubview(imageView)
            }
            
            if let creationDate = item.creationDate {
                timestampLabel?.text = creationDate.description
            }
        }
    }
    
    @IBOutlet weak var textLabel1: UILabel?
    @IBOutlet weak var timestampLabel: UILabel?
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
}
