//
//  CustomerInformationTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 02/01/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class CustomerInformationTableViewCell: UITableViewCell {

    @IBOutlet var btnStarFive: UIButton!
    @IBOutlet var btnStarFour: UIButton!
    @IBOutlet var btnStarThree: UIButton!
    @IBOutlet var btnStarTwo: UIButton!
    @IBOutlet var btnStarOne: UIButton!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var viewBorder: UIView!
    @IBOutlet var lblContactNo: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var btnChat: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewBorder.layer.borderWidth = 1
        self.viewBorder.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        self.btnChat.layer.cornerRadius = 3
        self.btnChat.layer.masksToBounds = true
        
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