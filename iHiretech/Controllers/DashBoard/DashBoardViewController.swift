//
//  DashBoardViewController.swift
//  iHiretech
//
//  Created by Admin on 26/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SWRevealViewController

class DashBoardViewController: UIViewController {
  
    @IBOutlet var tblProfile: UITableView!
    @IBOutlet var btnMenuAction: UIBarButtonItem!
    var getProfileDetailsDict = [String:Any]()
    
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
        
        getProfileDetails()
        
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
            cell.lblSubTitle.text = self.subTitleDetails[indexPath.row]
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
        (headerViewArray.viewWithTag(4) as! UILabel).text = (self.getProfileDetailsDict)["universal_id"] as? String
        
        let img_url =  (getProfileDetailsDict)["profile_picture"]!
        if img_url as? String != nil
        {
            DispatchQueue.global(qos: .background).async {
                let data = try? Data(contentsOf: URL(string: img_url as! String)!)
                if data != nil {
                    DispatchQueue.main.async {
                        (headerViewArray.viewWithTag(2) as! UIImageView).image = UIImage(data: data!)
                    }
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
    
    func getProfileDetails()
    {
        WebAPI().callJSONWebApi(API.getTechnicianProfileDetails, withHTTPMethod: .get, forPostParameters: nil, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            let data = serviceResponse["data"] as? [String:Any]
            self.getProfileDetailsDict = data!["user"] as! [String:Any]
            print(self.getProfileDetailsDict)
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
           self.tblProfile.delegate = self
            self.tblProfile.dataSource = self
            self.tblProfile.layer.add(transition, forKey: nil)
            self.tblProfile.reloadData()
        })
    }
    
}

