//
//  WorkOrderTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 27/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class WorkOrderTableViewCell: UITableViewCell {

    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnDetailView: UIButton!
    @IBOutlet var lblRouted: UILabel!
    @IBOutlet var lblWorkOrderId: UILabel!
    @IBOutlet var btnPrint: UIButton!
    @IBOutlet var lblCLientName: UILabel!
    @IBOutlet var lblManagerName: UILabel!
    @IBOutlet var lblWorkOrderDate: UILabel!
    @IBOutlet var lblLocationName: UILabel!
    @IBOutlet var lblCreatedBy: UILabel!
    @IBOutlet var lblWorkType: UILabel!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet var lblStatus: UILabel!
     var appdelegate = UIApplication.shared.delegate as! AppDelegate
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewSearch.layer.cornerRadius = 3
        self.viewSearch.layer.masksToBounds = true
        self.viewSearch.layer.borderWidth = 1
        self.viewSearch.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.lblStatus.layer.cornerRadius = 3
        self.lblStatus.layer.masksToBounds = true
        self.lblRouted.layer.cornerRadius = 3
        self.lblRouted.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    @IBAction func btn_VIewAction(_ sender: UIButton)
    {
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "WorkOrderDetailsViewController") as! WorkOrderDetailsViewController
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        nav.navigationController?.view.layer.add(transition, forKey: nil)
        nav.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
        nav.navigationController?.navigationBar.tintColor = UIColor.white
        nav.navigationController?.navigationBar.isTranslucent = false
        nav.navigationController?.pushViewController(nav, animated: false)
    }
}
