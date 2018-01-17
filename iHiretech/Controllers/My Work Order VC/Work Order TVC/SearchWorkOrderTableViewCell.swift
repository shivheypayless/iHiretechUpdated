//
//  SearchWorkOrderTableViewCell.swift
//  iHiretech
//
//  Created by HPL on 30/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class SearchWorkOrderTableViewCell: UITableViewCell {

    @IBOutlet var viewToDate: TextFieldView!
    @IBOutlet var viewFromDate: TextFieldView!
    @IBOutlet var cntStatusHeight: NSLayoutConstraint!
    @IBOutlet var UpDwnArrow: UIImageView!
    @IBOutlet var txtWorkOrderNo: TextFieldView!
    @IBOutlet var statusTableView: UITableView!
    @IBOutlet var btnToDate: UIButton!
    @IBOutlet var btnFromDate: UIButton!
    @IBOutlet var btnSelectStatus: UIButton!
    @IBOutlet var btnSearch: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var searchExpandView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.searchExpandView.layer.borderWidth = 1
        self.searchExpandView.layer.borderColor =  UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.btnReset.layer.borderWidth = 1
        self.btnReset.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        self.btnSearch.layer.borderWidth = 1
        self.btnSearch.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        self.btnSelectStatus.layer.borderWidth = 1
        self.btnSelectStatus.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
