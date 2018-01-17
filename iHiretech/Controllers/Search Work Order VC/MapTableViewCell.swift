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

class MapTableViewCell: UITableViewCell,GMSMapViewDelegate ,  CLLocationManagerDelegate{

    @IBOutlet var mapView: GMSMapView!
     var selfMarker = LocateMarker()
     var locationManager = CLLocationManager()
     var getSearchListDetails = [AnyObject]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        locationManager.delegate = self
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
//        {
//            locationManager.startUpdatingLocation()
//        }
//        else
//        {
//            locationManager.requestWhenInUseAuthorization()
//
//        }
       // self.mapView.delegate = self
        self.mapView.layer.borderWidth = 1
        self.mapView.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
//        locationManager.startMonitoringSignificantLocationChanges()
//              self.mapView.isMyLocationEnabled = true
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        print(self.getSearchListDetails)
//        for i in 0...self.getSearchListDetails.count-1
//        {
//            self.mapView.delegate = self
//            selfMarker.isDraggable = false
//            self.mapView.isMyLocationEnabled = true
//            selfMarker.position = CLLocationCoordinate2D(latitude: Double((self.getSearchListDetails[i])["location_latitude"] as! String)!, longitude: Double((self.getSearchListDetails[i])["location_longitude"] as! String)!)
//            let gmsCamera = GMSCameraPosition.camera(withLatitude: Double((self.getSearchListDetails[i])["location_latitude"] as! String)!, longitude: Double((self.getSearchListDetails[i])["location_longitude"] as! String)!, zoom: 10.0)
//            self.mapView.camera = gmsCamera
//            selfMarker.map = self.mapView
//            selfMarker.tag = i
//            selfMarker.title = ((self.getSearchListDetails[i])["location_name"] as? String)
//        }
//        locationManager.stopUpdatingLocation()
//        locationManager.stopMonitoringSignificantLocationChanges()
//
//    }
    
}

class LocateMarker : GMSMarker
{
    var tag : Int!
}
