//
//  TabOrderCollectionViewCell.swift
//  iHiretech
//
//  Created by Admin on 22/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TabOrderCollectionViewCell: UICollectionViewCell {
    @IBOutlet var scrollVIew: UIView!
    @IBOutlet var cnstViewWidth: NSLayoutConstraint!
    @IBOutlet var lblTabName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
      //  self.contentView.translatesAutoresizingMaskIntoConstraints = false
     //   let screenWidth = UIScreen.main.bounds.size.width
     //   cnstViewWidth.constant = screenWidth - (2 * 12)
        // Initialization code
    }

}
