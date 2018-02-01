//
//  RatingFilterTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 18/01/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class RatingFilterTableViewCell: UITableViewCell {

    @IBOutlet var btnFiveStar: UIButton!
    @IBOutlet var viewBorder: UIView!
    @IBOutlet var btnSearch: UIButton!
    @IBOutlet var btnTodate: UIButton!
    @IBOutlet var btnFromDate: UIButton!
    @IBOutlet var viewToDate: TextFieldView!
    @IBOutlet var viewFromDate: TextFieldView!
    @IBOutlet var imgOne: UIImageView!
    @IBOutlet var imgTwo: UIImageView!
    @IBOutlet var imgThree: UIImageView!
    @IBOutlet var imgFour: UIImageView!
    @IBOutlet var imgFive: UIImageView!
    @IBOutlet var btnOneStar: UIButton!
    @IBOutlet var btnTwoStar: UIButton!
    @IBOutlet var btnThreeStar: UIButton!
    @IBOutlet var btnFourStar: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.viewBorder.layer.borderWidth = 1
        self.viewBorder.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.btnSearch.layer.cornerRadius = 3
        self.btnSearch.layer.masksToBounds = true
        // Configure the view for the selected state
    }
    
}
