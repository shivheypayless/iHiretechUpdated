//
//  ChatViewController.swift
//  iHiretech
//
//  Created by Admin on 31/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

typealias actionWithServiceResponseRead = ((_ serviceResponse: [String:Any])-> Void)

typealias getMarkRead = (String) -> Void

class ChatViewController: UIViewController {

    @IBOutlet var lblNoDataFound: UILabel!
    @IBOutlet var tblChat: UITableView!
    var frmSrc = String()
    var noDataFound = UILabel()
    var getAllData = [String:Any]()
    var notificationList = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoDataFound.isHidden = true
        getNotificationList { (userDetails) in
          //  self.markMessageAsRead()
        }
        self.tblChat.register(UINib(nibName: "ChatListTableViewCell", bundle: nil) , forCellReuseIdentifier: "ChatListTableViewCell")
        self.tblChat.estimatedRowHeight = 90
        self.tblChat.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
       // chatRoom.setupNetworkCommunication()
        if self.notificationList.count == 0
        {
        self.lblNoDataFound.isHidden = false
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getNotificationList(details : @escaping getMarkRead)
    {
        WebAPI().callJSONWebApi(API.getChatNotificationList, withHTTPMethod: .post, forPostParameters: nil, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            self.notificationList = serviceResponse["data"] as! [AnyObject]
            if self.notificationList.count != 0
            {
                 self.noDataFound.isHidden = true
          //  self.getAllData =
        //    self.notificationList = self.getAllData["data"] as! [AnyObject]
            self.tblChat.dataSource = self
            self.tblChat.delegate = self
            self.tblChat.reloadData()
            details("done")
                self.lblNoDataFound.isHidden = true
            }
          else
           {
              self.lblNoDataFound.isHidden = false
            }
        })
    }

    
    @IBAction func btn_NotificationAction(_ sender: UIBarButtonItem)
    {
        let nav = self.storyboard!.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
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
    
    @IBAction func btn_backAction(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
  
    @objc func textDidChange(_ sender: UITextField) {
      //  SocketIOManager.sharedInstance.sendDataToEvent(.typing, data: [:])
    }
    
}

extension ChatViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath) as! ChatListTableViewCell
        cell.lblOrderTitle.text = ((self.notificationList[indexPath.row]["work_order_details"] as! [String:AnyObject])["work_order_title"] as? String)!
        cell.lblOrderId.text = ((self.notificationList[indexPath.row]["work_order_details"] as! [String:AnyObject])["work_order_number"] as? String)!
//        if indexPath.row == self.getAllData.count - 1 { // last cell
//            //if totalItems > privateList.count { //removing totalItems for always service call
//            loadMoreItems()
//            //}
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let param = ["work_order_id": ((self.notificationList[indexPath.row]["work_order_details"] as! [String:AnyObject])["work_order_id"] as! Int)] as [String:Any]
        WebAPI().callJSONWebApi(API.markUserMsgRead, withHTTPMethod: .get, forPostParameters: param, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)

        })
    if ((self.notificationList[indexPath.row]["work_order_details"] as! [String:AnyObject])["status_id"] as! Int) == 1
    {
        let nav = self.storyboard!.instantiateViewController(withIdentifier: "SearchOrderDetailViewController") as! SearchOrderDetailViewController
        nav.workOrderId = ((self.notificationList[indexPath.row]["work_order_details"] as! [String:AnyObject])["work_order_id"] as! Int)
        nav.socketId = (self.notificationList[indexPath.row]["from_id"] as! String)
        nav.tabsTag = 2
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
        let nav = self.storyboard!.instantiateViewController(withIdentifier: "WorkOrderDetailsViewController") as! WorkOrderDetailsViewController
        nav.workOrderId = ((self.notificationList[indexPath.row]["work_order_details"] as! [String:AnyObject])["work_order_id"] as! Int)
        nav.socketId = (self.notificationList[indexPath.row]["from_id"] as! String)
        nav.tabsTag = 2
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
       
//
    }
    
    func loadMoreItems()
    {
        WebAPI().callJSONWebApiPagination("\((self.getAllData)["next_page_url"] as! String)", withHTTPMethod: .post, forPostParameters: nil, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            let data = serviceResponse["data"] as! [String:Any]
            self.getAllData = data["pagination_link"] as! [String:Any]
            self.tblChat.reloadData()
        })
    }
}

