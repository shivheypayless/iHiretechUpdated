//
//  WorkOrderInformationTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 02/01/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class WorkOrderInformationTableViewCell: UITableViewCell {

    @IBOutlet var lblBorder: UILabel!
    @IBOutlet var lblHtml: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblBorder.layer.borderWidth = 1
        self.lblBorder.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
        // Configure the view for the selected state
    }
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        
    }
    
}
