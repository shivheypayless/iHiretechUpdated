//
//  SearchWorkOrderTableViewController.swift
//  iHiretech
//
//  Created by HPL on 30/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SWRevealViewController
import KLCPopup
import GoogleMaps
import GooglePlaces
import MapKit

@available(iOS 10.0, *)
class SearchWorkOrderTableViewController: UITableViewController , GMSMapViewDelegate , CLLocationManagerDelegate{

    var collapsedSections = NSMutableSet()
      var appdelegate = UIApplication.shared.delegate as! AppDelegate
    var frmSrc = String()
    var popup = KLCPopup()
    var statusTableView = UITableView()
    var milesTAbleView = UITableView()
    var milesName = UIButton()
    var milesTableCnst = NSLayoutConstraint()
    var calenderPickerView = UIDatePicker()
    var getStatusName = [AnyObject]()
    var getWorkListData = [String:Any]()
    var getSearchListDetails = [AnyObject]()
    var statusName = UIButton()
    var statusId = Int()
    var statusTableCnst = NSLayoutConstraint()
    var milesArray = ["10","20","30","40"]
    var searchmap = GMSMapView()
    var locationManager = CLLocationManager()
     var markerArray = [LocationMarker]()
     var selfMarker = LocationMarker()
    var workOrderId = Int()
    var noDataFOund = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Search Work Order"
    
         self.statusTableCnst.constant = 0
         self.milesTableCnst.constant = 0
        
        let button4 =  UIBarButtonItem(image: UIImage(named: "img_Back"), style: .plain, target: self, action: #selector(SearchWorkOrderTableViewController.btnbackAction))

        self.navigationItem.leftBarButtonItem = button4
        self.tableView.register(UINib(nibName: "SearchOrderTableViewCell", bundle: nil) , forCellReuseIdentifier: "SearchOrderTableViewCell")
        self.tableView.register(UINib(nibName: "WorkOrderTableViewCell", bundle: nil) , forCellReuseIdentifier: "WorkOrderTableViewCell")
        self.tableView.register(UINib(nibName: "MapTableViewCell", bundle: nil) , forCellReuseIdentifier: "MapTableViewCell")
        self.tableView.separatorStyle = .none
        collapsedSections.add(1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWorkList()
         self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWorkList()
    {
        let parameters = ["work_order_number": "" , "from_date": "" , "to_date": "", "status":"" ,"per_page":"", "miles":"" , "client":""] as [String:AnyObject]
        WebAPI().callJSONWebApi(API.searchWorkOrderListing, withHTTPMethod: .post, forPostParameters: parameters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            let data = serviceResponse["data"] as? [String:Any]
            self.getWorkListData = data!["work_orders"] as! [String:Any]
            self.getStatusName = data!["clients"] as! [AnyObject]
            self.getSearchListDetails = self.getWorkListData["data"] as! [AnyObject]
            if self.getSearchListDetails.count != 0
            {
                print(self.getSearchListDetails.count)
                self.locationManager.delegate = self
                if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
                {
                    self.locationManager.startUpdatingLocation()
                }
                else
                {
                    self.locationManager.requestWhenInUseAuthorization()
                    
                }
            }
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
        })
       
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
             locationManager.startMonitoringSignificantLocationChanges()
            self.searchmap.isMyLocationEnabled = true
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(getSearchListDetails)
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        self.searchmap.delegate = self
        selfMarker.isDraggable = false
        self.searchmap.isMyLocationEnabled = true
        selfMarker.tag = -1
        
       let latitude = locations.first!.coordinate.latitude
       let longitude = locations.first!.coordinate.longitude
       
        selfMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        selfMarker.tag = -1
       let gmsCamera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 5.0)
         self.searchmap.camera = gmsCamera
        
        if self.getSearchListDetails.count != 0
        {
        for (index,eachPrayer) in getSearchListDetails.enumerated()
        {
            let marker = LocationMarker()
            marker.position = CLLocationCoordinate2D(latitude: Double(eachPrayer["location_latitude"] as! String)!, longitude: Double(eachPrayer["location_longitude"] as! String)!)
            let gmsCamera = GMSCameraPosition.camera(withLatitude: Double(eachPrayer["location_latitude"] as! String)!, longitude: Double(eachPrayer["location_longitude"] as! String)!, zoom: 0.0)
             self.searchmap.camera = gmsCamera
            marker.map = self.searchmap
            marker.tag = index
            marker.title = (eachPrayer["location_name"] as? String)!
            marker.snippet = (eachPrayer["work_order_number"] as? String)!
            self.markerArray.append(marker)
        }
        }
       // print(self.markerArray)

    }

    
    public func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let customInfoWindow = Bundle.main.loadNibNamed("LocationWindowView", owner: self, options: nil)![0] as! UIView
        customInfoWindow.clipsToBounds = true
        if((marker as! LocationMarker).tag != -1)
        {
            (customInfoWindow.viewWithTag(1) as! UILabel).text = (marker as! LocationMarker).title!
            (customInfoWindow.viewWithTag(2) as! UILabel).text = (marker as! LocationMarker).snippet!
        }
        return customInfoWindow
    }
    
    func startSendingLocation()
    {
        self.locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            self.locationManager.startUpdatingLocation()
        }
        else
        {
            self.locationManager.requestWhenInUseAuthorization()
            
        }
    }
  
    @objc func btnNotificationAction(_ sender: UIButton)
    {
        let nav = (appdelegate.storyBoard)?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        nav.frmSrc = "SearchWork"
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.pushViewController(nav, animated: false)
    }
    
  
    @objc func btnbackAction()
    {
        let destination = (appdelegate.storyBoard)?.instantiateViewController(withIdentifier: "DashBoardViewController") as! DashBoardViewController
        let nav = UINavigationController(rootViewController: destination)
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        nav.view.layer.add(transition, forKey: nil)
        nav.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
        nav.navigationBar.tintColor = UIColor.white
        nav.navigationBar.isTranslucent = false
        self.revealViewController().setFront(nav, animated: true)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if tableView == self.statusTableView
        {
            return 1
        }
        else if tableView == self.milesTAbleView
        {
            return 1
        }
        else
        {
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if tableView == self.statusTableView
        {
            return self.getStatusName.count
        }
        else if tableView == self.milesTAbleView
        {
            return self.milesArray.count
        }
        else
        {
            if section == 0
            {
                return collapsedSections.contains(section) ? 0 :  1
            }
            else if section == 1
            {
                return 1
            }
            else
            {
                return self.getSearchListDetails.count
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.statusTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatesTableViewCell", for: indexPath) as! StatesTableViewCell
            cell.lblState.text! = ((self.getStatusName[indexPath.row])["client_name"] as? String)!
            return cell
        }
        else if tableView == self.milesTAbleView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatesTableViewCell", for: indexPath) as! StatesTableViewCell
            cell.lblState.text! = "\((self.milesArray[indexPath.row]) as String) Miles"
            return cell
        }
        else
        {
            if indexPath.section == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchOrderTableViewCell", for: indexPath) as! SearchOrderTableViewCell
                cell.viewFromDate.txtFieldName.text = "From Date"
                cell.viewToDate.txtFieldName.text = "To Date"
                cell.btnSortClient.setTitle("   Client Name", for: .normal)
                cell.btnSelectMiles.setTitle("   Select Miles", for: .normal)
                cell.viewWordOrderNo.placeholder = "Search by work order number"
                self.milesName.setTitle("   Select Miles", for: .normal)
                cell.viewWordOrderNo.txtFieldName.text = ""
                cell.btnFromDate.addTarget(self, action: #selector(self.DatePickerFromDate(_:)), for: UIControlEvents.touchUpInside)
                cell.btnToDate.addTarget(self, action: #selector(self.DatePickerToDate(_:)), for: UIControlEvents.touchUpInside)
                cell.btnSortClient.addTarget(self, action: #selector(self.btnStatusAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnReset.addTarget(self, action: #selector(self.btn_ResetAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnSearch.addTarget(self, action: #selector(self.btn_SearchAction(_:)), for: UIControlEvents.touchUpInside)
                self.statusName =  cell.btnSortClient
                 cell.btnSelectMiles.addTarget(self, action: #selector(self.btnMilesAction(_:)), for: UIControlEvents.touchUpInside)
                self.milesName =  cell.btnSelectMiles
                return cell
            }
            if indexPath.section == 1
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell", for: indexPath) as! MapTableViewCell
               self.searchmap = cell.mapView
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOrderTableViewCell", for: indexPath) as! WorkOrderTableViewCell
                if self.getSearchListDetails.count != 0
                {
                    cell.lblWorkOrderId.text = "#\(String(describing: (self.getSearchListDetails[indexPath.row])["work_order_number"] as! String)) "
                    let cap = ((self.getSearchListDetails[indexPath.row])["status_name"] as! String)
                    let finalString = cap.capitalized
                    cell.lblStatus.text = " \(finalString) "
                    cell.lblWorkType.text = (((self.getSearchListDetails[indexPath.row])["work_category"]) as! [String:Any])["work_category_name"] as? String
                    cell.lblLocationName.text = ((self.getSearchListDetails[indexPath.row])["location_name"] as? String)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-DD HH:mm:ss"
                    if !((self.getSearchListDetails[indexPath.row])["schedule_exact_date"] is  NSNull) && !((self.getSearchListDetails[indexPath.row])["schedule_exact_time"] is  NSNull)
                    {
                    let date = dateFormatter.date(from: "\((self.getSearchListDetails[indexPath.row])["schedule_exact_date"] as! String) \((self.getSearchListDetails[indexPath.row])["schedule_exact_time"] as! String)")
                    dateFormatter.dateFormat = "MM-DD-YYYY hh:mm a"
                    cell.lblWorkOrderDate.text = dateFormatter.string(from: date!)
                    }
                    cell.lblCLientName.text = (((self.getSearchListDetails[indexPath.row])["clients"]) as! [String:Any])["client_name"] as? String
                    cell.lblManagerName.text = ((((self.getSearchListDetails[indexPath.row])["manager"]) as! [String:Any])["first_name"] as? String)!+" "+((((self.getSearchListDetails[indexPath.row])["manager"]) as! [String:Any])["last_name"] as? String)!
                   cell.lblRouted.isHidden = true
//                   cell.btnDetailView.tag = indexPath.row
                    cell.btnCancel?.removeFromSuperview()
                    let detail = UIImage(named: "img_View")
                    cell.btnPrint.setImage(detail, for: .normal)
                    cell.btnPrint.addTarget(self, action: #selector(self.btnViewAction(_:)), for: .touchUpInside)
                    
                    if ((self.getSearchListDetails[indexPath.row])["tech_applied_status"] as? String) != nil
                    {
                        let image = UIImage(named: "img_ApplyOrder")
                        cell.btnDetailView.tag = indexPath.row
                        cell.btnDetailView.removeTarget(nil, action: nil, for: .allEvents)
                        cell.btnDetailView.setImage(image, for: .normal)
                        cell.btnDetailView.addTarget(self, action: #selector(self.btnApplyAlready(_:)), for: .touchUpInside)
                    }
                    else
                    {
                        let image = UIImage(named: "img_Apply")
                        cell.btnDetailView.setImage(image, for: .normal)
                         cell.btnDetailView.removeTarget(nil, action: nil, for: .allEvents)
                        cell.btnDetailView.tag = indexPath.row
                        cell.btnDetailView.addTarget(self, action: #selector(self.btnApplyAction(_:)), for: .touchUpInside)
                    }
                   
                    if indexPath.row == self.getSearchListDetails.count - 1 { // last cell
                        loadMoreItems()
                        //}
                    }
                }
                return cell
            }
            
        }
      
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
            if tableView == statusTableView
            {
                let status = ((self.getStatusName[indexPath.row])["client_name"] as? String)!
                self.statusId = ((self.getStatusName[indexPath.row])["client_id"] as? Int)!
                statusName.titleLabel?.text = " \(status)"
                self.statusName.setTitle("\(status)", for: .normal)
                self.statusTableCnst.constant = 0
                self.tableView.rowHeight = 456.0
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                
            }
            else if tableView == milesTAbleView
            {
                let status = (self.milesArray[indexPath.row]) as String
              //  milesName.titleLabel?.text = "\(status)"
                 milesName.titleLabel?.text = status
                self.milesName.setTitle(status, for: .normal)
                self.milesTableCnst.constant = 0
                self.tableView.rowHeight = 456.0
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.statusTableView
        {
            return nil
        }
        else if tableView == self.milesTAbleView
        {
            return nil
        }
        else
        {
        if section == 0
        {
            let headerViewArray = Bundle.main.loadNibNamed("SearchViewExpandableView", owner: self, options: nil)?[0] as! UIView
            (headerViewArray.viewWithTag(4) as! UILabel).text = "Filter"
            (headerViewArray.viewWithTag(1) as! UIView).layer.borderWidth = 1
            (headerViewArray.viewWithTag(1) as! UIView).layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
            var tap = UITapGestureRecognizer()
            tap =  UITapGestureRecognizer(target: self, action: #selector(self.extendSection))
            headerViewArray.addGestureRecognizer(tap)
            headerViewArray.tag = section
            return headerViewArray
        }
        else if section == 1
        {
            let headerViewArray = Bundle.main.loadNibNamed("SearchResultHeaderView", owner: self, options: nil)?[0] as! UIView
            (headerViewArray.viewWithTag(1) as! UILabel).text = "Location"
            (headerViewArray.viewWithTag(2) as! UILabel).isHidden = true
            return headerViewArray
        }
        else
        {
            let headerViewArray = Bundle.main.loadNibNamed("SearchResultHeaderView", owner: self, options: nil)?[0] as! UIView
            (headerViewArray.viewWithTag(1) as! UILabel).text = "Search Result"
            if self.getSearchListDetails.count != 0
            {
              (headerViewArray.viewWithTag(2) as! UILabel).isHidden = true
            }
            else
            {
                (headerViewArray.viewWithTag(2) as! UILabel).isHidden = false
            }
            return headerViewArray
        }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            if tableView == self.statusTableView || tableView == self.milesTAbleView
            {
                return 0
            }
            else
            {
                return 47.0
            }
        }

        else
        {
            if self.getSearchListDetails.count != 0
            {
                return 55.0
            }
            else
            {
                return 82.0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == self.statusTableView
        {
            return 30
        }
        else if tableView == self.milesTAbleView
        {
            return 30
        }
        if indexPath.section == 0
        {
            if tableView == self.statusTableView
            {
                return 30
            }
            else
            {
                if statusTableCnst.constant == 0
                {
                    return 456
                }
                else if milesTableCnst.constant == 0
                {
                    return 456
                }
                else
                {
                    return 540
                }
            }
        }
        else if indexPath.section == 1
        {
            return 300
        }
        else
        {
            return 408
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0
    }
    
    @objc func extendSection(_ sender : UIGestureRecognizer)
    {
        let section = sender.view!.tag
        if(section == 0)
        {
            self.tableView.beginUpdates()
            let shouldCollapse: Bool = !collapsedSections.contains(section)
            if shouldCollapse
            {

                (sender.view!.viewWithTag(2) as! UIImageView).image = UIImage(named: "plus")
                (sender.view!.viewWithTag(2) as! UIImageView).layoutIfNeeded()
                let numOfRows = tableView.numberOfRows(inSection: section)
                let indexPaths:[NSIndexPath] = self.indexPathsForSection(section: section, withNumberOfRows: numOfRows)
                self.tableView.deleteRows(at: indexPaths as [IndexPath], with: .fade)
                collapsedSections.add(section)
            }
            else
            {

                (sender.view!.viewWithTag(2) as! UIImageView).image = UIImage(named: "minus")
                (sender.view!.viewWithTag(2) as! UIImageView).layoutIfNeeded()
                let indexPaths: [NSIndexPath] = self.indexPathsForSection(section: section, withNumberOfRows: 1)
                self.tableView.insertRows(at: indexPaths as [IndexPath], with: .fade)
                collapsedSections.remove(section)
                print(collapsedSections)
            }
            self.tableView.endUpdates()
        }
        
    }
    
    func indexPathsForSection(section: Int, withNumberOfRows numberOfRows: Int) -> [NSIndexPath] {
        var indexPaths: [NSIndexPath] = [NSIndexPath]()
        for i in 0..<numberOfRows {
            let indexPath: NSIndexPath = NSIndexPath(row: i, section: section)
            indexPaths.append(indexPath)
        }
        print(indexPaths)
        return indexPaths
        
    }
    
    @objc func btnStatusAction(_ sender : UIButton)
    {
        if statusTableCnst.constant == 0
        {
            let cell_indexPath = NSIndexPath(row: 0, section: 0)
            let tableViewCell = tableView.cellForRow(at: cell_indexPath as IndexPath) as! SearchOrderTableViewCell
            statusTableCnst = tableViewCell.cnstClientHeight
            statusTableCnst.constant = 85.0
            self.tableView.beginUpdates()
            self.tableView.rowHeight = 540.0
            self.tableView.endUpdates()
            tableViewCell.tblClient.layer.borderWidth = 1
            tableViewCell.tblClient.layer.borderColor = UIColor.lightGray.cgColor
            self.statusTableView = tableViewCell.tblClient
            self.statusTableView.register(UINib(nibName: "StatesTableViewCell", bundle: nil) , forCellReuseIdentifier: "StatesTableViewCell")
            self.statusTableView.delegate = self
            self.statusTableView.dataSource = self
            self.statusTableView.reloadData()
           // tableView.reloadData()
        }
        else
        {
            statusTableCnst.constant = 0
       
           tableView.reloadData()
         //   self.upDwnArrow.image = UIImage(named: "minus")
        }
    }
    
    @objc func btnMilesAction(_ sender : UIButton)
    {
        if milesTableCnst.constant == 0
        {
            let cell_indexPath = NSIndexPath(row: 0, section: 0)
            let tableViewCell = tableView.cellForRow(at: cell_indexPath as IndexPath) as! SearchOrderTableViewCell
            milesTableCnst = tableViewCell.cnstMilesHeight
            milesTableCnst.constant = 85.0
            tableView.rowHeight = 540.0
            tableViewCell.tblMiles.layer.borderWidth = 1
            tableViewCell.tblMiles.layer.borderColor = UIColor.lightGray.cgColor
            self.milesTAbleView = tableViewCell.tblMiles
            self.milesTAbleView.register(UINib(nibName: "StatesTableViewCell", bundle: nil) , forCellReuseIdentifier: "StatesTableViewCell")
            self.milesTAbleView.delegate = self
            self.milesTAbleView.dataSource = self
            self.milesTAbleView.reloadData()
            tableView.reloadData()
        }
        else
        {
            milesTableCnst.constant = 0
            tableView.reloadData()
        }
    }
    
    
    @objc func DatePickerFromDate(_ sender : UIButton)
    {
        view.endEditing(true)
        var calenderView = UIView()
        calenderView = Bundle.main.loadNibNamed("DatePickerView", owner: self, options: nil)?[0] as! UIView
        calenderView.layer.cornerRadius = 10.0
        calenderView.layer.masksToBounds = true
        self.calenderPickerView = (calenderView.viewWithTag(3)! as! UIDatePicker)
        self.calenderPickerView.datePickerMode = UIDatePickerMode.date
        //  self.calenderPickerView.maximumDate = Date()
        let CloseButton = calenderView.viewWithTag(1) as! UIButton
        CloseButton.addTarget(self, action: #selector(self.btn_CloseAction(_:)), for: UIControlEvents.touchUpInside)
        let SaveButton = calenderView.viewWithTag(2) as! UIButton
        SaveButton.addTarget(self, action: #selector(self.btn_SaveFromAction(_:)), for: UIControlEvents.touchUpInside)
        popup = KLCPopup(contentView: calenderView , showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popup.show()
    }
    
    @objc func btn_SaveToAction(_ sender: UIButton)
    {
        popup.dismiss(true)
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = tableView.cellForRow(at: cell_indexPath as IndexPath) as! SearchOrderTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        tableViewCell.viewToDate.txtFieldName.text = dateFormatter.string(from: calenderPickerView.date)
        
    }
    
    @objc func DatePickerToDate(_ sender : UIButton)
    {
        view.endEditing(true)
        var calenderView = UIView()
        calenderView = Bundle.main.loadNibNamed("DatePickerView", owner: self, options: nil)?[0] as! UIView
        calenderView.layer.cornerRadius = 10.0
        calenderView.layer.masksToBounds = true
        self.calenderPickerView = (calenderView.viewWithTag(3)! as! UIDatePicker)
        self.calenderPickerView.datePickerMode = UIDatePickerMode.date
        //  self.calenderPickerView.maximumDate = Date()
        let CloseButton = calenderView.viewWithTag(1) as! UIButton
        CloseButton.addTarget(self, action: #selector(self.btn_CloseAction(_:)), for: UIControlEvents.touchUpInside)
        let SaveButton = calenderView.viewWithTag(2) as! UIButton
        SaveButton.addTarget(self, action: #selector(self.btn_SaveToAction(_:)), for: UIControlEvents.touchUpInside)
        popup = KLCPopup(contentView: calenderView , showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popup.show()
    }
    
    @objc func btn_SaveFromAction(_ sender: UIButton)
    {
        popup.dismiss(true)
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = tableView.cellForRow(at: cell_indexPath as IndexPath) as! SearchOrderTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        tableViewCell.viewFromDate.txtFieldName.text = dateFormatter.string(from: calenderPickerView.date)
        
    }
    
    @objc func btn_CloseAction(_ sender: UIButton)
    {
        popup.dismiss(true)
    }
    
    @objc func btn_SearchAction(_ sender: UIButton)
    {
        popup.dismiss(true)
        view.endEditing(true)
        var parameters = [String:AnyObject]()
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = tableView.cellForRow(at: cell_indexPath as IndexPath) as! SearchOrderTableViewCell
        if tableViewCell.viewFromDate.txtFieldName.text! == "From Date"
        {
            tableViewCell.viewFromDate.txtFieldName.text! = ""
        }
        if tableViewCell.viewToDate.txtFieldName.text! == "To Date"
        {
            tableViewCell.viewToDate.txtFieldName.text! = ""
        }
       
        if tableViewCell.btnSelectMiles.titleLabel?.text! == "   Select Miles"
        {
            if self.statusId == 0
            {
                 parameters = ["work_order_number": tableViewCell.viewWordOrderNo.txtFieldName.text! , "from_date": tableViewCell.viewFromDate.txtFieldName.text! , "to_date": tableViewCell.viewToDate.txtFieldName.text!, "client": "" ,"per_page":"","miles":""] as [String:AnyObject]
            }
            else
            {
                 parameters = ["work_order_number": tableViewCell.viewWordOrderNo.txtFieldName.text! , "from_date": tableViewCell.viewFromDate.txtFieldName.text! , "to_date": tableViewCell.viewToDate.txtFieldName.text!, "client":  self.statusId ,"per_page":"","miles":""] as [String:AnyObject]
            }
        }
        else
        {
            if self.statusId == 0
            {
                parameters = ["work_order_number": tableViewCell.viewWordOrderNo.txtFieldName.text! , "from_date": tableViewCell.viewFromDate.txtFieldName.text! , "to_date": tableViewCell.viewToDate.txtFieldName.text!, "client": "" ,"per_page":"","miles":Int((tableViewCell.btnSelectMiles.titleLabel?.text!)!)!] as [String:AnyObject]
            }
            else
            {
               parameters = ["work_order_number": tableViewCell.viewWordOrderNo.txtFieldName.text! , "from_date": tableViewCell.viewFromDate.txtFieldName.text! , "to_date": tableViewCell.viewToDate.txtFieldName.text!, "client":  self.statusId ,"per_page":"","miles":Int((tableViewCell.btnSelectMiles.titleLabel?.text!)!)!] as [String:AnyObject]
            }
        }
       print(parameters)
        WebAPI().callJSONWebApi(API.searchWorkOrderListing, withHTTPMethod: .post, forPostParameters: parameters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            let data = serviceResponse["data"] as? [String:Any]
            self.getWorkListData = data!["work_orders"] as! [String:Any]
            self.getStatusName = data!["clients"] as! [AnyObject]
             self.getSearchListDetails = self.getWorkListData["data"] as! [AnyObject]
            self.statusId = 0
            if self.getSearchListDetails.count != 0
            {
                self.locationManager.delegate = self
                self.markerArray.removeAll()
                self.selfMarker.position.latitude = 0
                self.selfMarker.position.latitude = 0
                print(self.getSearchListDetails.count)
                if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
                {
                    self.locationManager.startUpdatingLocation()
                }
                else
                {
                    self.locationManager.requestWhenInUseAuthorization()
                }
            }
            else
            {
                self.locationManager.delegate = self
                self.markerArray.removeAll()
                self.selfMarker.position.latitude = 0
                self.selfMarker.position.latitude = 0
                self.locationManager.startUpdatingLocation()
            }
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
        })
    }
    
    @objc func btn_ResetAction(_ sender: UIButton)
    {
        view.endEditing(true)
        getWorkList()
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = tableView.cellForRow(at: cell_indexPath as IndexPath) as! SearchOrderTableViewCell
        tableViewCell.btnSelectMiles.setTitle("   Select Miles", for: .normal)
        self.milesName.setTitle("   Select Miles", for: .normal)
        self.statusName.setTitle("   Client name", for: .normal)
    }

    @objc func btnApplyAction(_ sender : UIButton)
    {
        if ((self.getSearchListDetails[sender.tag])["payment_rate_type"] as? Int)! == 3
        {
            self.workOrderId =  ((self.getSearchListDetails[sender.tag])["work_order_id"] as! Int)
            let nav = (appdelegate.storyBoard)?.instantiateViewController(withIdentifier: "BlendedApplyViewController") as! BlendedApplyViewController
            nav.workOrderId = self.workOrderId
             nav.navigate = "SearchWorkOrderDetail"
             nav.statusName = ((self.getSearchListDetails[sender.tag])["status_name"] as! String)
            nav.paymentRateType = String((self.getSearchListDetails[sender.tag])["payment_rate_type"] as! Int)
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.pushViewController(nav, animated: false)
        }
        else
        {
        self.workOrderId =  ((self.getSearchListDetails[sender.tag])["work_order_id"] as! Int)
        let nav = (appdelegate.storyBoard)?.instantiateViewController(withIdentifier: "ApplyWorkViewController") as! ApplyWorkViewController
        nav.workOrderId = self.workOrderId
            nav.navigate = "SearchWorkOrderDetail"
            nav.statusName = ((self.getSearchListDetails[sender.tag])["status_name"] as! String)
            nav.paymentRateType = String((self.getSearchListDetails[sender.tag])["payment_rate_type"] as! Int)
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.pushViewController(nav, animated: false)
        }
    }
    
     @objc func btnViewAction(_ sender : UIButton)
     {
        self.workOrderId =  ((self.getSearchListDetails[sender.tag])["work_order_id"] as! Int)
        let nav = (appdelegate.storyBoard)?.instantiateViewController(withIdentifier: "SearchOrderDetailViewController") as! SearchOrderDetailViewController
        nav.workOrderId = self.workOrderId
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.pushViewController(nav, animated: false)
     }
    
    @objc func btnApplyAlready(_ sender : UIButton)
    {
        AListAlertController.shared.presentAlertController(message: "You have already applied for this Work Order.", completionHandler: nil)
    }
    
    func loadMoreItems()
    {
        if !((self.getWorkListData)["next_page_url"] is NSNull)
        {
            WebAPI().callJSONWebApiPagination("\((self.getWorkListData)["next_page_url"] as! String)", withHTTPMethod: .post, forPostParameters: nil, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
                print(serviceResponse)
                let data = serviceResponse["data"] as? [String:Any]
                self.getWorkListData = data!["work_orders"] as! [String:Any]
                self.getStatusName = data!["statuses"] as! [AnyObject]
            //    self.getSearchListDetails = self.getWorkListData["data"] as! [AnyObject]
                self.getSearchListDetails.append(contentsOf: self.getWorkListData["data"] as! [AnyObject])
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
            })
        }
    }

}

class LocationMarker : GMSMarker
{
    var tag : Int!
}


