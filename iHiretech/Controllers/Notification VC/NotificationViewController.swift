//
//  NotificationViewController.swift
//  iHiretech
//
//  Created by Admin on 31/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet var tblNotification: UITableView!
    var frmSrc = String()
    var notificationList = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
              getNotificationList()
        self.tblNotification.register(UINib(nibName: "NotificationTableViewCell", bundle: nil) , forCellReuseIdentifier: "NotificationTableViewCell")
        self.tblNotification.estimatedRowHeight = 90
        self.tblNotification.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    
    
    
    @IBAction func btn_ChatAction(_ sender: UIBarButtonItem)
    {
        let nav = self.storyboard!.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
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
    
    @IBAction func btn_BackAction(_ sender: UIBarButtonItem)
    {
        if self.frmSrc == "SearchWork"
        {
            let destination = SearchWorkOrderTableViewController(style: .plain)
           // destination.storyBoard = self.storyboard
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.pushViewController(destination, animated: false)
        }
        else if self.frmSrc == "MyWork"
        {
            let destination = MyWorkOrderTableViewController(style: .plain)
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.pushViewController(destination, animated: false)
        }
        else if self.frmSrc == "Rating"
        {
            let destination = RatingTableViewController(style: .plain)
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.pushViewController(destination, animated: false)
        }
        else
        {
        let destination = self.storyboard!.instantiateViewController(withIdentifier: "DashBoardViewController") as! DashBoardViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.pushViewController(destination, animated: false)
        }
    }
    
    func getNotificationList()
    {
        WebAPI().callJSONWebApi(API.getNotificationList, withHTTPMethod: .get, forPostParameters: nil, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
           let data = serviceResponse["data"] as! [String:Any]
            let list = data["pagination_link"] as! [String:Any]
            var allData = list["data"] as! [AnyObject]
            for i in 0...allData.count-1
            {
                if ((allData[i])["type"] as! String) == "App\\Notifications\\WorkOrderActivtiy"
                {
                    self.notificationList.append(allData[i])
                }
            }
            self.tblNotification.reloadData()
        })
    }
}

extension NotificationViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.lblOrderTitle.text = ((self.notificationList[indexPath.row])["work_order_activity"] as! String)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: ((self.notificationList[indexPath.row])["updated_at"] as! String))!
        dateFormatter.dateFormat = "dd MMM"
        cell.lblOrderDate.text = dateFormatter.string(from: date)
        cell.lblOrderId.text = ((self.notificationList[indexPath.row])["workOrderNumber"] as! String)
        if  ((self.notificationList[indexPath.row])["read_at"]) is NSNull
        {
            cell.viewSuper.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        }
        else
        {
            cell.viewSuper.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  ((self.notificationList[indexPath.row])["read_at"]) is NSNull
        {
          //   cell.viewSuper.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        }
        else
        {
            
        }
        let nav = self.storyboard!.instantiateViewController(withIdentifier: "WorkOrderDetailsViewController") as! WorkOrderDetailsViewController
        nav.workOrderId = ((self.notificationList[indexPath.row])["work_order_id"] as! Int)
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
