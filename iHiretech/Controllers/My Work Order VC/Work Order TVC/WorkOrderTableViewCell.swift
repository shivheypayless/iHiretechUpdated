//
//  WorkOrderTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 27/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class WorkOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet var lblStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewSearch.layer.cornerRadius = 3
        self.viewSearch.layer.masksToBounds = true
        self.viewSearch.layer.borderWidth = 1
        self.viewSearch.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
