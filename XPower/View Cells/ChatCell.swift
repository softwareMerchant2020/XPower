//
//  ChatCell.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/21/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setMessage(message:Message)  {
        if message.sender == Utilities.currentUserName() {
            messageLabel.textAlignment = .right
            messageLabel.text = message.message
        }
        else
        {
            messageLabel.textAlignment = .left
            messageLabel.text = message.message
        }
    }
    
}
