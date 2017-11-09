//
//  MapTableViewCell.swift
//  iHiretech
//
//  Created by Admin on 31/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import GooglePlaces

class MapTableViewCell: UITableViewCell,GMSMapViewDelegate {

    @IBOutlet var mapView: GMSMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mapView.layer.borderWidth = 1
        self.mapView.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
