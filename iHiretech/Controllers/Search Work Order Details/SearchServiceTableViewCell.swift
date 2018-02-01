//
//  SearchServiceTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 14/01/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class SearchServiceTableViewCell: UITableViewCell {
    @IBOutlet var viewBorder: UIView!
    @IBOutlet var lblTypeOfWork: UILabel!
    @IBOutlet var lblServiceTitle: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblClientName: UILabel!
    @IBOutlet var lblOrderId: UILabel!
    @IBOutlet var lblManagerName: UILabel!
    @IBOutlet var btnApply: UIButton!
    @IBOutlet var lblSkills: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBorder.layer.borderWidth = 1
        self.viewBorder.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        self.btnApply.layer.cornerRadius = 3
        self.btnApply.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
