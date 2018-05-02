//
//  WorkspaceTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 05/01/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class WorkspaceTableViewCell: UITableViewCell {

    @IBOutlet var imgCheckOut: UIImageView!
    @IBOutlet var imgTask: UIImageView!
    @IBOutlet var img_CheckIn: UIImageView!
    @IBOutlet var btnCheckOutTime: UIButton!
    @IBOutlet var btnCheckOutDate: UIButton!
    @IBOutlet var btnCheckOut: UIButton!
    @IBOutlet var btnTaskList: UIButton!
    @IBOutlet var btnCheckInDate: UIButton!
    @IBOutlet var btnCheckInTime: UIButton!
    @IBOutlet var btnCheckIn: UIButton!
    @IBOutlet var viewBorder: UIView!
    @IBOutlet var viewCheckOutTIme: UIView!
    @IBOutlet var viewCheckOutDate: UIView!
    @IBOutlet var viewCheckInTime: UIView!
    @IBOutlet var viewCheckInDate: UIView!
    @IBOutlet var lblCheckoutTime: UILabel!
    @IBOutlet var lblCheckOutDate: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var cnstrntLocationTrackingButtonHeight: NSLayoutConstraint!
    @IBOutlet var btnStartTracking: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBorder.layer.borderWidth = 1
        self.viewBorder.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.viewCheckInTime.layer.cornerRadius = 3
        self.viewCheckInTime.layer.masksToBounds = true
        self.viewCheckInTime.layer.borderWidth = 1
        self.viewCheckInTime.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        self.viewCheckOutTIme.layer.cornerRadius = 3
        self.viewCheckOutTIme.layer.masksToBounds = true
        self.viewCheckOutTIme.layer.borderWidth = 1
        self.viewCheckOutTIme.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        self.viewCheckOutTIme.layer.cornerRadius = 3
        self.viewCheckOutTIme.layer.masksToBounds = true
        self.viewCheckOutTIme.layer.borderWidth = 1
        self.viewCheckOutTIme.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor

        self.viewCheckOutDate.layer.cornerRadius = 3
        self.viewCheckOutDate.layer.masksToBounds = true
        self.viewCheckOutDate.layer.borderWidth = 1
        self.viewCheckOutDate.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        self.viewCheckInDate.layer.cornerRadius = 3
        self.viewCheckInDate.layer.masksToBounds = true
        self.viewCheckInDate.layer.borderWidth = 1
        self.viewCheckInDate.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor

        self.btnCheckOut.layer.cornerRadius = 3
        self.btnCheckOut.layer.masksToBounds = true
        
        self.btnCheckIn.layer.cornerRadius = 3
        self.btnCheckIn.layer.masksToBounds = true
        
        self.btnStartTracking.layer.cornerRadius = 3
        self.btnStartTracking.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
