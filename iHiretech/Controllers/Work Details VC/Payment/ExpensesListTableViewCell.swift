//
//  ExpensesListTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 08/01/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ExpensesListTableViewCell: UITableViewCell {

    @IBOutlet var viewBorder: UIView!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var lblProcessingFees: UILabel!
    @IBOutlet var lblTechnicianExpenses: UILabel!
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
