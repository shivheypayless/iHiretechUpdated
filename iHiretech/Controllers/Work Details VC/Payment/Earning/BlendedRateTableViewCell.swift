//
//  BlendedRateTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 23/01/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class BlendedRateTableViewCell: UITableViewCell {

    @IBOutlet var lblTotalEarning: UILabel!
    @IBOutlet var lblScndAmtEarned: UILabel!
    @IBOutlet var lblScndClocedHrs: UILabel!
    @IBOutlet var lblsecndMaxhrs: UILabel!
    @IBOutlet var lblSecndAmtPayable: UILabel!
    @IBOutlet var lblFirstAmtEarnd: UILabel!
    @IBOutlet var lblFirstClockedHrs: UILabel!
    @IBOutlet var lblFirstMaxHours: UILabel!
    @IBOutlet var lblFirstPayableAmt: UILabel!
    @IBOutlet var viewBorder: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBorder.layer.borderWidth = 1
        self.viewBorder.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
