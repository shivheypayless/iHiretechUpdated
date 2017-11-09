//
//  NotificationTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 31/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet var viewSuper: UIView!
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
