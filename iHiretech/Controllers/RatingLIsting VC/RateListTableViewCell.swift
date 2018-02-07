//
//  RateListTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 18/01/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import HCSStarRatingView

class RateListTableViewCell: UITableViewCell {

    @IBOutlet var viewBorder: UIView!
    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var viewRating: HCSStarRatingView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgProfilePic.layer.cornerRadius =  imgProfilePic.frame.size.height/2
        imgProfilePic.layer.masksToBounds = true
        imgProfilePic.layoutIfNeeded()
        self.viewBorder.layer.borderWidth = 1
        self.viewBorder.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
