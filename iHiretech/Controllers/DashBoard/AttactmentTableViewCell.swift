//
//  AttactmentTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 27/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class AttactmentTableViewCell: UITableViewCell {

    @IBOutlet var btnBackground: UIButton!
    @IBOutlet var btnDrugs: UIButton!
    @IBOutlet var btnInsurance: UIButton!
    @IBOutlet var btnResume: UIButton!
    @IBOutlet var imgbackground: UIImageView!
    @IBOutlet var imgDrug: UIImageView!
    @IBOutlet var imgInsurance: UIImageView!
    @IBOutlet var imgResume: UIImageView!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
