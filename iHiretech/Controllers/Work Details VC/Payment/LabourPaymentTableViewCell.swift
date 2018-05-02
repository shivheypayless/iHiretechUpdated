//
//  LabourPaymentTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 08/01/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class LabourPaymentTableViewCell: UITableViewCell {

    @IBOutlet var cnstAddExpensesHeight: NSLayoutConstraint!
    @IBOutlet var viewBorder: UIView!
    @IBOutlet var lblTotalExpenses: UILabel!
    @IBOutlet var lblLabourAmount: UILabel!
    @IBOutlet var lblTotalWOrkingHrs: UILabel!
    @IBOutlet var btnAddExpenses: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBorder.layer.borderWidth = 1
        self.viewBorder.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.btnAddExpenses.layer.cornerRadius = 3
        self.btnAddExpenses.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
