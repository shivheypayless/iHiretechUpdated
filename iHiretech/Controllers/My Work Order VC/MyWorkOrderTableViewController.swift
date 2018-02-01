//
//  MyWorkOrderTableViewController.swift
//  iHiretech
//
//  Created by HPL on 30/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import KLCPopup

class MyWorkOrderTableViewController: UITableViewController {
    
    var collapsedSections = NSMutableSet()
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    var frmSrc = String()
    var popup = KLCPopup()
    var upDwnArrow = UIImageView()
    var statusTableView = UITableView()
    var calenderPickerView = UIDatePicker()
    var getStatusName = [AnyObject]()
    var getWorkListData = [String:Any]()
    var getSearchListDetails = [AnyObject]()
    var workOrderData = [String:Any]()
    var statusName = UIButton()
    var statusId = Int()
    var statusTableCnst = NSLayoutConstraint()
    var workOrderId = Int()
    var noDataFOund = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        self.navigationItem.title = "My Work Order"
        self.navigationItem.titleView?.tintColor = UIColor.white
        self.statusTableCnst.constant = 0
      //  self.tableView.estimatedRowHeight = 340
      //  self.tableView.rowHeight = 384.0
         self.tableView.register(UINib(nibName: "WorkOrderTableViewCell", bundle: nil) , forCellReuseIdentifier: "WorkOrderTableViewCell")
        self.tableView.register(UINib(nibName: "SearchWorkOrderTableViewCell", bundle: nil) , forCellReuseIdentifier: "SearchWorkOrderTableViewCell")
        self.tableView.separatorStyle = .none
        collapsedSections.add(1)
         getWorkList()
        
        let button2 =  UIBarButtonItem(image: UIImage(named: "img_Notification"), style: .plain, target: self, action: #selector(btnNotificationAction))
        
        let button3 =  UIBarButtonItem(image: UIImage(named: "img_Chat"), style: .plain, target: self, action: #selector(btnChatAction))
        
        let button4 =  UIBarButtonItem(image: UIImage(named: "img_Back"), style: .plain, target: self, action: #selector(btnbackAction))
        
        self.navigationItem.setRightBarButtonItems([button2,button3], animated: true)
        self.navigationItem.leftBarButtonItem = button4
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    func getWorkList()
    {
        let parameters = ["work_order_number": "" , "from_date": "" , "to_date": "", "status":"" ,"per_page":""] as! [String:AnyObject]
        WebAPI().callJSONWebApi(API.workOrderListing, withHTTPMethod: .post, forPostParameters: parameters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            let data = serviceResponse["data"] as? [String:Any]
            self.getWorkListData = data!["work_orders"] as! [String:Any]
            self.getStatusName = data!["statuses"] as! [AnyObject]
            self.getSearchListDetails = self.getWorkListData["data"] as! [AnyObject]
      //       print(self.getSearchListDetails)
           
            if self.getSearchListDetails.count != 0
            {
                print(self.getSearchListDetails.count)
            }
            self.tableView.dataSource = self
            self.tableView.delegate = self
           self.tableView.reloadData()
        })
    }
    
    @objc func btnNotificationAction()
    {
        let nav = (appdelegate.storyBoard)?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        nav.frmSrc = "MyWork"
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
    
    @objc func btnChatAction()
    {
        let nav = (appdelegate.storyBoard)?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
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
        if tableView == self.tableView
        {
            return 2
        }
        else
        {
          return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.statusTableView
        {
            return self.getStatusName.count
        }
        else
        {
            if section == 0
            {
                return collapsedSections.contains(section) ? 0 :  1
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
            cell.lblState.text! = ((self.getStatusName[indexPath.row])["name"] as? String)!
            return cell
        }
        else
        {
            if indexPath.section == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchWorkOrderTableViewCell", for: indexPath) as! SearchWorkOrderTableViewCell
                cell.btnFromDate.addTarget(self, action: #selector(self.DatePickerFromDate(_:)), for: UIControlEvents.touchUpInside)
                cell.btnToDate.addTarget(self, action: #selector(self.DatePickerToDate(_:)), for: UIControlEvents.touchUpInside)
                cell.btnSelectStatus.addTarget(self, action: #selector(self.btnStatusAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnReset.addTarget(self, action: #selector(self.btn_ResetAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnSearch.addTarget(self, action: #selector(self.btn_SearchAction(_:)), for: UIControlEvents.touchUpInside)
//                cell.cntStatusHeight = self.statusTableCnst
                self.statusName =  cell.btnSelectStatus
//                self.statusTableCnst = cell.cntStatusHeight
////                self.statusTableCnst.constant = 0
                self.upDwnArrow.image = cell.UpDwnArrow.image
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
                    cell.lblWorkOrderDate.text = "\((self.getSearchListDetails[indexPath.row])["schedule_exact_date"] as? String ?? "2017-04-20") \((self.getSearchListDetails[indexPath.row])["schedule_exact_time"] as? String ?? "10:00")"
                    cell.lblCLientName.text = (((self.getSearchListDetails[indexPath.row])["clients"]) as! [String:Any])["client_name"] as? String
                    cell.lblManagerName.text = ((((self.getSearchListDetails[indexPath.row])["manager"]) as! [String:Any])["first_name"] as? String)!+" "+((((self.getSearchListDetails[indexPath.row])["manager"]) as! [String:Any])["last_name"] as? String)!
                 
                    if (((self.getSearchListDetails[indexPath.row])["work_order_status"] as! [String:Any])["is_routed"] as? String) == "1"
                    {
                       cell.lblRouted.isHidden = false
                       cell.lblRouted.text = " Routed "
                    }
                    else
                    {
                        cell.lblRouted.isHidden = true
                    }
                }
                cell.btnCancel?.removeFromSuperview()
                cell.btnDetailView.tag = indexPath.row
                cell.btnPrint.tag = indexPath.row
                
                cell.btnDetailView.addTarget(self, action: #selector(self.btnViewAction(_:)), for: .touchUpInside)
                 cell.btnPrint.addTarget(self, action: #selector(self.btnViewAction(_:)), for: .touchUpInside)
                return cell
            }
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView == self.statusTableView
        {
            let status = ((self.getStatusName[indexPath.row])["name"] as? String)!
            self.statusId = ((self.getStatusName[indexPath.row])["id"] as? Int)!
            self.statusName.titleLabel?.text = " \(status)"
            self.statusTableCnst.constant = 0
            self.tableView.rowHeight = 384.0
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            self.upDwnArrow.image = UIImage(named: "minus")
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.statusTableView
        {
            return nil
        }
        else
        {
            if section == 0
            {
                let headerViewArray = Bundle.main.loadNibNamed("SearchViewExpandableView", owner: self, options: nil)?[0] as! UIView
                (headerViewArray.viewWithTag(1) as! UIView).layer.borderWidth = 1
                (headerViewArray.viewWithTag(1) as! UIView).layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
                var tap = UITapGestureRecognizer()
                tap =  UITapGestureRecognizer(target: self, action: #selector(self.extendSection))
                headerViewArray.addGestureRecognizer(tap)
                headerViewArray.tag = section
                return headerViewArray
            }
            else
            {
                let headerViewArray = Bundle.main.loadNibNamed("SearchResultHeaderView", owner: self, options: nil)?[0] as! UIView
                return headerViewArray
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if tableView == self.statusTableView
        {
            return 0
        }
        else
        {
            if section == 0
            {
                return 47.0
            }
            else
            {
                return 55.0
            }
        }
        
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
   {
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
              return 384
            }
            else
            {
                return 468
            }
        }
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
        // self.collapsableTableView.reloadData()
        let section = sender.view!.tag
        if(section == 0)
        {
            self.tableView.beginUpdates()
            let shouldCollapse: Bool = !collapsedSections.contains(section)
            if shouldCollapse
            {
                if self.getSearchListDetails.count == 0
                {
                    self.noDataFOund.text = ""
                    self.noDataFOund = UILabel(frame: CGRect(x: 16, y: 110, width: 200, height: 14))
                  //  label.textAlignment = NSTextAlignment.center
                    self.noDataFOund.text = "No Search Found"
                    self.noDataFOund.textColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                    self.view.addSubview(self.noDataFOund)
                }
                (sender.view!.viewWithTag(2) as! UIImageView).image = UIImage(named: "plus")
                (sender.view!.viewWithTag(2) as! UIImageView).layoutIfNeeded()
                let numOfRows = tableView.numberOfRows(inSection: section)
                let indexPaths:[NSIndexPath] = self.indexPathsForSection(section: section, withNumberOfRows: numOfRows)
                self.tableView.deleteRows(at: indexPaths as [IndexPath], with: .fade)
                collapsedSections.add(section)
            }
            else
            {
                if self.getSearchListDetails.count == 0
                {
                    self.noDataFOund.text = ""
                self.noDataFOund = UILabel(frame: CGRect(x: 16, y: 490, width: 200, height: 16))
                self.noDataFOund.text = "No Search Found"
                self.noDataFOund.textColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                self.view.addSubview(self.noDataFOund)
                }
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
        let tableViewCell = tableView.cellForRow(at: cell_indexPath as IndexPath) as! SearchWorkOrderTableViewCell
//        self.tableView.rowHeight = 468.0
        statusTableCnst = tableViewCell.cntStatusHeight
        statusTableCnst.constant = 85.0
        self.upDwnArrow.image = UIImage(named: "plus")
        tableViewCell.statusTableView.layer.borderWidth = 1
        tableViewCell.statusTableView.layer.borderColor = UIColor.lightGray.cgColor
        self.statusTableView = tableViewCell.statusTableView
        self.statusTableView.register(UINib(nibName: "StatesTableViewCell", bundle: nil) , forCellReuseIdentifier: "StatesTableViewCell")
        self.statusTableView.delegate = self
        self.statusTableView.dataSource = self
        self.statusTableView.reloadData()
            tableView.reloadData()
        }
        else
        {
//            statusRow = 0
            statusTableCnst.constant = 0

            tableView.reloadData()
            self.upDwnArrow.image = UIImage(named: "minus")
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
        let tableViewCell = tableView.cellForRow(at: cell_indexPath as IndexPath) as! SearchWorkOrderTableViewCell
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
        let tableViewCell = tableView.cellForRow(at: cell_indexPath as IndexPath) as! SearchWorkOrderTableViewCell
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
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = tableView.cellForRow(at: cell_indexPath as IndexPath) as! SearchWorkOrderTableViewCell
        let parameters = ["work_order_number": tableViewCell.txtWorkOrderNo.txtFieldName.text! , "from_date": tableViewCell.viewFromDate.txtFieldName.text! , "to_date": tableViewCell.viewToDate.txtFieldName.text!, "status":  self.statusId ,"per_page":""] as! [String:AnyObject]
        WebAPI().callJSONWebApi(API.workOrderListing, withHTTPMethod: .post, forPostParameters: parameters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            let data = serviceResponse["data"] as? [String:Any]
            self.getWorkListData = data!["work_orders"] as! [String:Any]
            self.getStatusName = data!["statuses"] as! [AnyObject]
            self.getSearchListDetails = self.getWorkListData["data"] as! [AnyObject]
            //       print(self.getSearchListDetails)
            if self.getSearchListDetails.count == 0
            {
                    self.noDataFOund.isHidden = false
                    self.noDataFOund = UILabel(frame: CGRect(x: 16, y: 490, width: 200, height: 16))
                  //  self.noDataFOund.textAlignment = NSTextAlignment.center
                    self.noDataFOund.text = "No Search Found"
                    self.noDataFOund.textColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                    self.view.addSubview(self.noDataFOund)
            }
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
        })
    }
    
    @objc func btn_ResetAction(_ sender: UIButton)
    {
        popup.dismiss(true)
    }
    
    @objc func btnViewAction(_ sender : UIButton)
    {
       self.workOrderId =  ((self.getSearchListDetails[sender.tag])["work_order_id"] as! Int)
        print(self.workOrderId)
       let nav = (appdelegate.storyBoard)?.instantiateViewController(withIdentifier: "WorkOrderDetailsViewController") as! WorkOrderDetailsViewController
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


}



