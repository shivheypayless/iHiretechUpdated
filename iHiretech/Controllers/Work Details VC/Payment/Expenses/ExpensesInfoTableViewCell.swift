//
//  ExpensesInfoTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 09/01/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ExpensesInfoTableViewCell: UITableViewCell {

    @IBOutlet var viewBorder: UIView!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblTotalAmount: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.viewBorder.layer.borderWidth = 1
//        self.viewBorder.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.lblStatus.layer.cornerRadius = 3
        self.lblStatus.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
