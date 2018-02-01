//
//  OtherUserTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 31/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class OtherUserTableViewCell: UITableViewCell {

    @IBOutlet var lblTime: UILabel!
    @IBOutlet var viewText: UIView!
    @IBOutlet var lblText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewText.layer.cornerRadius = 6
        self.viewText.layer.masksToBounds = true
        self.viewText.layer.borderWidth = 1
        self.viewText.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1).cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
