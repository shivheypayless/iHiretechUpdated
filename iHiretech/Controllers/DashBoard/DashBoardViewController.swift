//
//  DashBoardViewController.swift
//  iHiretech
//
//  Created by Admin on 26/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SWRevealViewController
import SystemConfiguration
import MIBadgeButton_Swift

typealias actionWithServiceResponseImage = ((_ serviceResponse: [String:Any])-> Void)

typealias getUserDetails = (String) -> Void
class DashBoardViewController: UIViewController {
  
  
    @IBOutlet var tblProfile: UITableView!
    @IBOutlet var btnMenuAction: UIBarButtonItem!
    var getProfileDetailsDict = [String:Any]()
    var getProfileUserdata = [String:Any]()
    var getCompleteData = [String:Any]()
    var profileImage = Data()
    var btnNotification : MIBadgeButton!
    var btnChat : MIBadgeButton!
    var profileDetailsAray = ["Profession Title:","Profession Summary:","Skills:","Certificates:","Equipments:","Licensees:","Experience:","Phone No:","Email:","Address:"]
    var subTitleDetails = ["Smith Johnson","New","Analog Line , AT&T Phone System - verify correct settings on PBX","No Data","No Data","No Data","5 Years","381-324-432 EXT :123","smith@example.com","213 Hanover Street, New York, NY,USA,1001"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationController?.navigationBar.barTintColor = UIColor(red: 150/255, green: 119/255, blue: 0/255, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        btnMenuAction.target = self.revealViewController()
        btnMenuAction.action = #selector(SWRevealViewController.revealToggle(_:))
       self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        getProfileDetails { (userDetails) in
            self.getProfilePic()
        }
        let rightView = UIView(frame: CGRect(x: 0, y: 20, width: 100, height: 25))
        
        rightView.backgroundColor = UIColor.clear
        
        btnChat = MIBadgeButton(frame: CGRect(x: 40, y: 0, width: 18, height:20))
        btnChat.badgeBackgroundColor = UIColor.black
        btnChat.imageView?.image = UIImage(named: "img_Chat")
        btnChat.setBackgroundImage(UIImage(named: "img_Chat"), for: .normal)
        btnChat.tag=101
        btnChat.addTarget(self, action: #selector(btn_ChatAction(_ :)), for: UIControlEvents.touchUpInside)
        rightView.addSubview(btnChat)
        
        btnNotification = MIBadgeButton(frame: CGRect(x: 80, y: 0,width: 18, height: 20))
         btnNotification.badgeBackgroundColor = UIColor.black
        btnNotification.setBackgroundImage(UIImage(named: "img_Notification"), for: .normal)
        btnNotification.imageView?.image = UIImage(named: "img_Notification")
        btnNotification.tag=102
        btnNotification.addTarget(self, action: #selector(btn_NotificationAction(_ :)), for: UIControlEvents.touchUpInside)
        rightView.addSubview(btnNotification)
        
        let rightBtn = UIBarButtonItem(customView: rightView)
        self.navigationItem.rightBarButtonItem = rightBtn
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getUnreadCount), name: NSNotification.Name(rawValue: "MessageReceived"), object: nil)
        
      //  self.btnNoti = MIBadgeButton()
        self.tblProfile.estimatedRowHeight = 60
        self.tblProfile.rowHeight = UITableViewAutomaticDimension
         self.tblProfile.register(UINib(nibName: "profileDetailsTableViewCell", bundle: nil) , forCellReuseIdentifier: "profileDetailsTableViewCell")
        self.tblProfile.register(UINib(nibName: "AttactmentTableViewCell", bundle: nil) , forCellReuseIdentifier: "AttactmentTableViewCell")
    
      
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
    
    @objc func getUnreadCount()
    {
        if self.btnChat.badgeString == "0"
        {
            self.btnChat.badgeString = ""
        }
        else
        {
            self.btnChat.badgeString = "\((self.getCompleteData["message_count"] as! Int) + 1)"
        }
    }

    @objc func btn_NotificationAction(_ sender: UIBarButtonItem)
    {
       if self.btnChat.badgeString != "0"
       {
         self.btnChat.badgeString = "\((self.getCompleteData["message_count"] as! Int) - 1)"
       }
        else
       {
        self.btnChat.badgeString = ""
        }
        WebAPI().callJSONWebApi(API.markAllAsRead, withHTTPMethod: .get, forPostParameters: nil, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
        })
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
    
    @objc func btn_ChatAction(_ sender: UIBarButtonItem)
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
    
}

extension DashBoardViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return profileDetailsAray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttactmentTableViewCell", for: indexPath) as! AttactmentTableViewCell
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileDetailsTableViewCell", for: indexPath) as! profileDetailsTableViewCell
             cell.lblTitle.text = self.profileDetailsAray[indexPath.row]
            if indexPath.row == 0
            {
                if let tech = (self.getProfileDetailsDict["tech_meta"] as? [String:Any])
                {
                cell.lblSubTitle.text = (self.getProfileDetailsDict["tech_meta"]! as! [String:Any])["professional_title"] as? String
                }
            }
            else if indexPath.row == 1
            {
                 if let tech = (self.getProfileDetailsDict["tech_meta"] as? [String:Any])
                 {
                cell.lblSubTitle.text = (self.getProfileDetailsDict["tech_meta"]! as! [String:Any])["professional_summary"] as? String
                }
            }
            else if indexPath.row == 3
            {
                let skillsArray = (self.getCompleteData["certification"] as? [String])!
                if skillsArray.count != 0
                {
                for i in 0...(skillsArray.count)-1
                {
                     if skillsArray.count-1 == i
                    {
                        cell.lblSubTitle.text!.append("\(String(describing: skillsArray[i]))")
                    }
                    else
                    {
                        cell.lblSubTitle.text!.append("\(String(describing: skillsArray[i])) ,")
                    }
                }
                }
            }
            else if indexPath.row == 4
            {
                let skillsArray = (self.getCompleteData["equipment"] as? [String])!
                if skillsArray.count != 0
                {
                for i in 0...(skillsArray.count)-1
                {
                     if skillsArray.count-1 == i
                    {
                        cell.lblSubTitle.text!.append("\(String(describing: skillsArray[i]))")
                    }
                    else
                    {
                        cell.lblSubTitle.text!.append("\(String(describing: skillsArray[i])) ,")
                    }
                }
                }
            }
            else if indexPath.row == 5
            {
                let skillsArray = (self.getCompleteData["license"] as? [String])!
                if skillsArray.count != 0
                {
                for i in 0...(skillsArray.count)-1
                {
                    if skillsArray.count-1 == i
                    {
                        cell.lblSubTitle.text!.append("\(String(describing: skillsArray[i]))")
                    }
                    else
                    {
                        cell.lblSubTitle.text!.append("\(String(describing: skillsArray[i])) ,")
                    }
                }
                }
            }
            else if indexPath.row == 6
            {
                if let tech = (self.getProfileDetailsDict["tech_meta"] as? [String:Any])
                {
                    
                cell.lblSubTitle.text = (self.getProfileDetailsDict["tech_meta"]! as! [String:Any])["experience"] as? String
                }
            }
            else if indexPath.row == 7
            {
                if let contact = (((self.getProfileDetailsDict)["contact_number_1"]) as? String)
                {
                    let endIndex = (((self.getProfileDetailsDict)["contact_number_1"]!) as? String)!.index((((self.getProfileDetailsDict)["contact_number_1"]!) as? String)!.endIndex, offsetBy: -8)
                let truncated = (((self.getProfileDetailsDict)["contact_number_1"]!) as? String)!.substring(to: endIndex)
                print(truncated)
                cell.lblSubTitle.text = truncated
                }
            }
            else if indexPath.row == 8
            {
               cell.lblSubTitle.text = (self.getProfileUserdata)["email"] as? String
            }
            else if indexPath.row == 9
            {
                if let address = (((self.getProfileDetailsDict)["address_line_1"]) as? String)
                {
                 cell.lblSubTitle.text = "\(((self.getProfileDetailsDict)["address_line_1"]!) as! String) , \(((self.getProfileDetailsDict)["address_line_2"]!) as! String)"
                }
            }
        
            cell.imgDetail.image = UIImage(named: self.profileDetailsAray[indexPath.row])
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerViewArray = Bundle.main.loadNibNamed("ProfileView", owner: self, options: nil)?[0] as! UIView
        let editView = headerViewArray.viewWithTag(1)!
        (headerViewArray.viewWithTag(3) as! UILabel).text = (((self.getProfileDetailsDict)["first_name"]!)as? String)!+" "+(((self.getProfileDetailsDict)["last_name"]!) as? String)!
        UserDefaults.standard.setValue((((self.getProfileDetailsDict)["first_name"]!)as! String)+" "+(((self.getProfileDetailsDict)["last_name"]!) as! String), forKey: "ProfileName")
        (headerViewArray.viewWithTag(4) as! UILabel).text = (self.getProfileDetailsDict)["universal_id"] as? String
        UserDefaults.standard.setValue((((self.getProfileDetailsDict)["universal_id"]!) as! String), forKey: "Id")
        UserDefaults.standard.setValue((((self.getProfileDetailsDict)["city"]!) as! String), forKey: "Location")
        UserDefaults.standard.setValue((((self.getProfileDetailsDict)["socket_id"]!) as! String), forKey: "SocketId")
        UserDefaults.standard.setValue(((self.getProfileDetailsDict)["user_id"] as! String), forKey: "UserId")
         (headerViewArray.viewWithTag(2) as! UIImageView).layer.cornerRadius =  (headerViewArray.viewWithTag(2) as! UIImageView).frame.size.height/2
         (headerViewArray.viewWithTag(2) as! UIImageView).layer.masksToBounds = true
         (headerViewArray.viewWithTag(2) as! UIImageView).layoutIfNeeded()
        
   //     let img_url =  (getProfileDetailsDict)["profile_picture"]!
        if self.profileImage != nil
        {
             DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        (headerViewArray.viewWithTag(2) as! UIImageView).image = UIImage(data: self.profileImage)
                    }
            }
        }
        else
        {
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    (headerViewArray.viewWithTag(2) as! UIImageView).image = UIImage(named: "img_EditProfilePic")
                }
            }
       
        }
       // (headerViewArray.viewWithTag(2) as! UIImageView).image = UIImage(named: "plus")
        
        var tap = UITapGestureRecognizer()
        tap =  UITapGestureRecognizer(target: self, action: #selector(self.EditView))
        editView.addGestureRecognizer(tap)
        return headerViewArray
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 240.0
    }
    
    @objc func EditView()
    {
        let destination = self.storyboard!.instantiateViewController(withIdentifier: "PersonalDetailsViewController") as! PersonalDetailsViewController
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
    
    func getProfileDetails(details : @escaping getUserDetails)
    {
        WebAPI().callJSONWebApi(API.getTechnicianProfileDetails, withHTTPMethod: .get, forPostParameters: nil, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            
            self.getCompleteData = serviceResponse["data"] as! [String:Any]
            self.getProfileDetailsDict = self.getCompleteData["UserProfile"] as! [String:Any]
       //     print(self.getProfileDetailsDict["tech_meta"]!)
            self.getProfileUserdata = self.getCompleteData["user"] as! [String:Any]
          //  UserDefaults.standard.setValue((self.getCompleteData["message_count"] as! Int), forKey: "UnreadAlertMsg")
            if self.getCompleteData["message_count"] as! Int == 0
            {
                self.btnChat.badgeString = ""
            }
            else
            {
            self.btnChat.badgeString = "\(self.getCompleteData["message_count"] as! Int)"
            }
            if self.getCompleteData["notification_count"] as! Int == 0
           {
               self.btnNotification.badgeString = ""
           }
            else
            {
                self.btnNotification.badgeString = "\(self.getCompleteData["notification_count"] as! Int)"
            }
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            self.tblProfile.layer.add(transition, forKey: nil)
             details("Done")
        })
    }
    
    func getProfilePic()
    {
        WebAPI().callJSONWebApi(API.getProfilePic, withHTTPMethod: .get, forPostParameters: nil, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            let data = serviceResponse["data"]
            if (data is [String:Any])
            {
                let mediaFile = (data as! [String:Any])["encoded"] as! String
                 var afterEqualsTo = String()
                if let index = (mediaFile.range(of: ",")?.upperBound)
                {
                    afterEqualsTo = String(mediaFile.suffix(from: index))
                  //  print(afterEqualsTo)
                }

            let imageData = String(afterEqualsTo).data(using: String.Encoding.utf8)
            
           if let decodedData = NSData(base64Encoded: imageData!, options: .ignoreUnknownCharacters) {
               print(decodedData)
            self.profileImage = decodedData as Data
            }
            }
            self.tblProfile.delegate = self
            self.tblProfile.dataSource = self
             self.tblProfile.reloadData()
        })
    }

}

