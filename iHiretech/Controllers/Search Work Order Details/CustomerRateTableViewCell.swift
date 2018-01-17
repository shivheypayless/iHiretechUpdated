//
//  CustomerRateTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 14/01/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class CustomerRateTableViewCell: UITableViewCell {
    
    @IBOutlet var btnStarFive: UIButton!
    @IBOutlet var btnStarFour: UIButton!
    @IBOutlet var btnStarThree: UIButton!
    @IBOutlet var btnStarTwo: UIButton!
    @IBOutlet var btnStarOne: UIButton!
    @IBOutlet var btnRating: UIButton!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var viewBorder: UIView!
    @IBOutlet var lblContactNo: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var btnChat: UIButton!
    @IBOutlet var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBorder.layer.borderWidth = 1
        self.viewBorder.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        self.btnChat.layer.cornerRadius = 3
        self.btnChat.layer.masksToBounds = true
        
        self.btnRating.layer.cornerRadius = 3
        self.btnRating.layer.masksToBounds = true
        
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
        imgProfile.layer.masksToBounds = true
        imgProfile.layoutIfNeeded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
