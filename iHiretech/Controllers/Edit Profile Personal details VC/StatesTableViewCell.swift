//
//  StatesTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 21/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class StatesTableViewCell: UITableViewCell {

    @IBOutlet var lblState: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
