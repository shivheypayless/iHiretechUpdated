//
//  ChatListTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 07/02/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {
    @IBOutlet var lblOrderTitle: UILabel!
    @IBOutlet var lblOrderId: UILabel!
    @IBOutlet var viewSuper: UIView!
    @IBOutlet var lblMsg: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewSuper.layer.cornerRadius = 3
        self.viewSuper.layer.masksToBounds = true
        self.viewSuper.layer.borderWidth = 1
        self.viewSuper.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
