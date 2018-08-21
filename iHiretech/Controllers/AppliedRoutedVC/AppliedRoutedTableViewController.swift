//
//  AppliedRoutedTableViewController.swift
//  iHiretech
//
//  Created by Admin on 20/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class AppliedRoutedTableViewController: UITableViewController {

     var appdelegate = UIApplication.shared.delegate as! AppDelegate
    var getWorkListData = [String:Any]()
    var getSearchListDetails = [AnyObject]()
    var noDataFound = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Applied/Routed Work Order"
         self.navigationItem.titleView?.tintColor = UIColor.white
        
        self.tableView.register(UINib(nibName: "WorkOrderTableViewCell", bundle: nil) , forCellReuseIdentifier: "WorkOrderTableViewCell")
        self.tableView.separatorStyle = .none
        
        let button4 =  UIBarButtonItem(image: UIImage(named: "img_Back"), style: .plain, target: self, action: #selector(btnbackAction))
        
        self.navigationItem.leftBarButtonItem = button4
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getWorkList()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
         self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWorkList()
    {
        WebAPI().callJSONWebApi(API.appliedRoutedOrderListing, withHTTPMethod: .get, forPostParameters: nil, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            let data = serviceResponse["data"] as? [String:Any]
            self.getWorkListData = data!["work_orders"] as! [String:Any]
            self.getSearchListDetails = self.getWorkListData["data"] as! [AnyObject]
          
            if self.getSearchListDetails.count == 0
            {
                print(self.getSearchListDetails.count)
                if self.getSearchListDetails.count == 0
                {
                     self.noDataFound.textAlignment = .center
                    self.noDataFound = UILabel(frame: CGRect(x: self.view.center.x - (60), y: 60, width: 150, height: 12))
                     self.noDataFound.text = "No Search Found"
                     self.noDataFound.textColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                    self.view.addSubview( self.noDataFound)
                }
            }
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
        })
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.getSearchListDetails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOrderTableViewCell", for: indexPath) as! WorkOrderTableViewCell
        if self.getSearchListDetails.count != 0
        {
            cell.lblWorkOrderId.text = "#\(String(describing: (self.getSearchListDetails[indexPath.row])["work_order_number"] as! String)) "
            if !((self.getSearchListDetails[indexPath.row])["status_name"] is NSNull)
            {
            cell.lblStatus.text = " \(String(describing: (self.getSearchListDetails[indexPath.row])["status_name"] as! String)) "
            }
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
            cell.btnDetailView.tag = indexPath.row
            cell.btnDetailView.addTarget(self, action: #selector(btn_RejectAction(_:)), for: .touchUpInside)
            cell.btnCancel.tag = indexPath.row
            if ((self.getSearchListDetails[indexPath.row])["tech_applied_status"] as? String) != nil
            {
                let image = UIImage(named: "img_ApplyOrder")
                cell.btnCancel.setImage(image, for: .normal)
                 cell.btnCancel.removeTarget(nil, action: nil, for: .allEvents)
                cell.btnCancel.addTarget(self, action: #selector(self.btnApplyAlready(_:)), for: .touchUpInside)
            }
      
            else if ((self.getSearchListDetails[indexPath.row])["status_name"] as? String) == "routing"
            {
                let image = UIImage(named: "img_ApproveArrow")
                cell.btnCancel.setImage(image, for: .normal)
                 cell.btnCancel.removeTarget(nil, action: nil, for: .allEvents)
                cell.btnCancel.tag = indexPath.row
                cell.btnCancel.addTarget(self, action: #selector(self.btnApplyAction(_:)), for: .touchUpInside)
            }
            
           else if ((self.getSearchListDetails[indexPath.row])["tech_applied_status"] as? String) == "Applied"
            {
                let image = UIImage(named: "img_Apply")
                cell.btnCancel.setImage(image, for: .normal)
                cell.btnCancel.removeTarget(nil, action: nil, for: .allEvents)
                cell.btnCancel.tag = indexPath.row
                cell.btnCancel.addTarget(self, action: #selector(self.btnApplyAction(_:)), for: .touchUpInside)
            }
            else
            {
            }
            let detail = UIImage(named: "img_View")
            cell.btnPrint.setImage(detail, for: .normal)
            cell.btnPrint.addTarget(self, action: #selector(self.btnViewAction(_:)), for: .touchUpInside)
            if indexPath.row == self.getSearchListDetails.count - 1 { // last cell
                //if totalItems > privateList.count { //removing totalItems for always service call
                loadMoreItems()
                //}
            }
        }
        return cell
      
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 408.0
    }

    @objc func btn_RejectAction(_ sender: UIButton)
    {
        let  paramerters = ["work_order_id": ((self.getSearchListDetails[sender.tag])["work_order_id"] as! Int)] as [String : Any]
        WebAPI().callJSONWebApi(API.rejectWorkOrder, withHTTPMethod: .post, forPostParameters: paramerters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            if let message = serviceResponse["msg"] as? String
            {
                AListAlertController.shared.presentAlertController(message: serviceResponse["msg"] as! String, completionHandler: nil)
                self.getWorkList()
            }
        })
    }
    
     @objc func btnApplyAction(_ sender: UIButton)
    {
        if ((self.getSearchListDetails[sender.tag])["payment_rate_type"] as? Int)! == 3
        {
            let nav = (appdelegate.storyBoard)?.instantiateViewController(withIdentifier: "BlendedApplyViewController") as! BlendedApplyViewController
            nav.workOrderId = ((self.getSearchListDetails[sender.tag])["work_order_id"] as! Int)
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
            let nav = (appdelegate.storyBoard)?.instantiateViewController(withIdentifier: "ApplyWorkViewController") as! ApplyWorkViewController
            nav.workOrderId = ((self.getSearchListDetails[sender.tag])["work_order_id"] as! Int)
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
        let nav = (appdelegate.storyBoard)?.instantiateViewController(withIdentifier: "SearchOrderDetailViewController") as! SearchOrderDetailViewController
        nav.workOrderId = ((self.getSearchListDetails[sender.tag])["work_order_id"] as! Int)
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
            WebAPI().callJSONWebApiPagination("\((self.getWorkListData)["next_page_url"] as! String)", withHTTPMethod: .get, forPostParameters: nil, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
                print(serviceResponse)
                let data = serviceResponse["data"] as? [String:Any]
                self.getWorkListData = data!["work_orders"] as! [String:Any]
            //    self.getSearchListDetails = self.getWorkListData["data"] as! [AnyObject]
                self.getSearchListDetails.append(contentsOf: self.getWorkListData["data"] as! [AnyObject])
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
            })
        }
    }


}
