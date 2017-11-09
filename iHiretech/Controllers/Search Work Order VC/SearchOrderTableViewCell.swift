//
//  SearchOrderTableViewCell.swift
//  iHiretech
//
//  Created by HPL on 30/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class SearchOrderTableViewCell: UITableViewCell {

    @IBOutlet var btnSearch: UIButton!
    @IBOutlet var superViewBorder: UIView!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnSelectMiles: UIButton!
    @IBOutlet weak var btnSortClient: UIButton!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.btnSortClient.layer.borderWidth = 1
        self.btnSortClient.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        self.btnSelectMiles.layer.borderWidth = 1
        self.btnSelectMiles.layer.borderColor =  UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        self.btnReset.layer.borderWidth = 1
        self.btnReset.layer.borderColor =  UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        self.btnSearch.layer.borderWidth = 1
        self.btnSearch.layer.borderColor =  UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        self.superViewBorder.layer.borderWidth = 1
        self.superViewBorder.layer.borderColor =  UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
