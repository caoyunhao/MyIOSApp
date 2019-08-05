//
//  MessagesViewCell.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/22.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

class MessagesViewCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var message: MessageItem! {
        didSet {
            timeLabel.text = DateUtils.stringWithType1(date: message.creationTime)
            messageLabel.text = message.text
            if message.flag {
                contentView.backgroundColor = UIColor(red: 73/255.0, green: 175/255.0, blue: 254/255.0, alpha: 1)
                messageLabel.textColor = UIColor.white
            } else {
                messageLabel.textColor = UIColor.black
                contentView.backgroundColor = UIColor.white
            }
        }
    }

    func changeFlagState() {
        message = PastboardHistory.shared.changeStatus(of: message)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
