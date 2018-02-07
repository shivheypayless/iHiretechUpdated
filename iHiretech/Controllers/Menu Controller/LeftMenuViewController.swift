//
//  LeftMenuViewController.swift
//  iHiretech
//
//  Created by Admin on 26/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SWRevealViewController
import HCSStarRatingView

class LeftMenuViewController: UIViewController {

    @IBOutlet var viewStar: HCSStarRatingView!
    @IBOutlet var tblMenuOptions: UITableView!
    @IBOutlet var lblUserId: UILabel!
    @IBOutlet var lblUserJob: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblProfileName: UILabel!
    @IBOutlet var imgProfilePic: UIImageView!
    var profileImage = Data()
    var LeftMenuArray = ["Work Order", "Profile", "Notification","User Setting"]
    var menuWithinOption = [["My Work Order","Search Work Order","Applied / Routed Work Order"],[],[],["Change Password","Logout"]]
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
  //  var no : Array = [3,0,0,2]
    var collapsedSections = NSMutableSet()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblMenuOptions.tableFooterView = UIView()
        appdelegate.storyBoard = self.storyboard!
    //    if (!(self.chatDetails["avg_rating"] is NSNull))
     //   {
      //      if let n = NumberFormatter().number(from: (self.chatDetails["avg_rating"] as! String)) {
            //    let f = CGFloat(truncating: "n")
            //    viewStar.value = f
                viewStar.filledStarImage = #imageLiteral(resourceName: "img_OrangeStar")
                viewStar.halfStarImage = #imageLiteral(resourceName: "img_HalfStarOrng")
        //    }
     //   }
        if UserDefaults.standard.object(forKey: "Id") as? String != nil
        {
            self.lblUserId.text! = (UserDefaults.standard.object(forKey: "Id") as? String)!
            self.lblLocation.text! = (UserDefaults.standard.object(forKey: "Location") as? String)!
            self.lblProfileName.text! = (UserDefaults.standard.object(forKey: "ProfileName") as? String)!
        }
        imgProfilePic.layer.cornerRadius =  imgProfilePic.frame.size.height/2
        imgProfilePic.layer.masksToBounds = true
        imgProfilePic.layoutIfNeeded()
        getProfilePic()
     
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        // self.collapsableTableView.reloadData()
        collapsedSections = NSMutableSet()
        for i in 0...LeftMenuArray.count-1
        {
            collapsedSections.add(i)
        }
        
        tblMenuOptions.delegate = self
        tblMenuOptions.dataSource = self
        tblMenuOptions.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_DetailRating(_ sender: UIButton)
    {
        let destination = RatingTableViewController(style: .plain)
        destination.frmSrc = "LeftMenu"
        // destination.storyBoard = self.storyboard
         destination.customerId = Int(UserDefaults.standard.object(forKey: "UserId") as! String)!
        let nav = UINavigationController(rootViewController: destination)
        nav.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
        nav.navigationBar.tintColor = UIColor.white
        nav.navigationBar.isTranslucent = false
        self.revealViewController().setFront(nav, animated: true)
           self.revealViewController().revealToggle(animated: true)

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
                 //   print(afterEqualsTo)
                }
            let imageData = String(afterEqualsTo).data(using: String.Encoding.utf8)
            
            if let decodedData = NSData(base64Encoded: imageData!, options: .ignoreUnknownCharacters) {
                print(decodedData)
                self.profileImage = decodedData as Data
                if self.imgProfilePic != nil
                {
                    DispatchQueue.global(qos: .background).async {
                        DispatchQueue.main.async {
                            self.imgProfilePic.image = UIImage(data: self.profileImage)
                        }
                    }
                }
              
            }
            else
            {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        self.imgProfilePic.image = UIImage(named: "img_EditProfilePic")
                    }
                }
                
            }
            }
        })
    }
}

extension LeftMenuViewController: UITableViewDataSource, UITableViewDelegate
{
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return collapsedSections.contains(section) ? 0 :  menuWithinOption[section].count
       // return menuWithinOption[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuOptionTableViewCell", for: indexPath) as! LeftMenuOptionTableViewCell
        if indexPath.section == 0 || indexPath.section == 3
        {
            cell.imgExtendArrow.isHidden = false
        }
        else
        {
            cell.imgExtendArrow.isHidden = true
        }
        cell.lblMenuOption.text = menuWithinOption[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (UIDevice().userInterfaceIdiom == .phone)
        {
            return 60
        }
        else
        {
            return 80
        }
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                let destination = MyWorkOrderTableViewController(style: .plain)
              //  destination.storyBoard = self.storyboard
                let nav = UINavigationController(rootViewController: destination)
                nav.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                nav.navigationBar.tintColor = UIColor.white
                nav.navigationBar.isTranslucent = false
                self.revealViewController().setFront(nav, animated: true)
            }
            else if indexPath.row == 1
            {
                let destination = SearchWorkOrderTableViewController(style: .plain)
               // destination.storyBoard = self.storyboard
                let nav = UINavigationController(rootViewController: destination)
                nav.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                nav.navigationBar.tintColor = UIColor.white
                nav.navigationBar.isTranslucent = false
                self.revealViewController().setFront(nav, animated: true)
            }
            else if indexPath.row == 2
            {
                let destination = AppliedRoutedTableViewController(style: .plain)
                //  destination.storyBoard = self.storyboard
                let nav = UINavigationController(rootViewController: destination)
                nav.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                nav.navigationBar.tintColor = UIColor.white
                nav.navigationBar.isTranslucent = false
                self.revealViewController().setFront(nav, animated: true)
            }
        }
        else if indexPath.section == 1
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            let nav = UINavigationController(rootViewController: destination)
            nav.navigationBar.isHidden = true
            self.revealViewController().setFront(nav, animated: true)
        }
        else if indexPath.section == 2
        {
            let destination = self.storyboard!.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
            let nav = UINavigationController(rootViewController: destination)
             nav.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
            nav.navigationBar.tintColor = UIColor.white
            nav.navigationBar.isTranslucent = false
            self.revealViewController().setFront(nav, animated: true)
        }
        else if indexPath.section == 3
        {
            if indexPath.row == 0
            {
                let destination = self.storyboard!.instantiateViewController(withIdentifier: "ChangePaawordViewController") as! ChangePaawordViewController
                let nav = UINavigationController(rootViewController: destination)
                 nav.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                nav.navigationBar.tintColor = UIColor.white
                nav.navigationBar.isTranslucent = false
                self.revealViewController().setFront(nav, animated: true)
            }
            else if indexPath.row == 1
            {
                let destination = self.storyboard!.instantiateViewController(withIdentifier: "RootNavViewController") as! RootNavViewController
                UIApplication.shared.keyWindow!.rootViewController = destination
            }
        }
        self.closeSection(indexPath.section)
        self.revealViewController().revealToggle(animated: true)
        tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return LeftMenuArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerViewArray = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?[0] as! UIView
        (headerViewArray.viewWithTag(1) as! UILabel).text = LeftMenuArray[section]
        (headerViewArray.viewWithTag(2) as! UIImageView).image = UIImage(named: "plus")
        if section == 1 || section == 2
        {
            (headerViewArray.viewWithTag(2) as! UIImageView).image = nil
        }
        var tap = UITapGestureRecognizer()
        tap =  UITapGestureRecognizer(target: self, action: #selector(self.extendSection))
        headerViewArray.addGestureRecognizer(tap)
        headerViewArray.tag = section
        return headerViewArray
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 55.0
    }
    
    func closeSection(_ sender : Int)
    {
        self.tblMenuOptions.beginUpdates()
        let numOfRows = tblMenuOptions.numberOfRows(inSection: sender)
        let indexPaths:[NSIndexPath] = self.indexPathsForSection(section: sender, withNumberOfRows: numOfRows)
        self.tblMenuOptions.deleteRows(at: indexPaths as [IndexPath], with: .fade)
        collapsedSections.add(sender)
        self.tblMenuOptions.endUpdates()
        self.tblMenuOptions.reloadData()
    }
    
    @objc func extendSection(_ sender : UIGestureRecognizer)
    {
        // self.collapsableTableView.reloadData()
        let section = sender.view!.tag
        if(section == 1)
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            let nav = UINavigationController(rootViewController: destination)
            nav.navigationBar.isHidden = true
            self.revealViewController().setFront(nav, animated: true)
            self.revealViewController().revealToggle(animated: true)
        }
        else if section == 2
        {
            let destination = self.storyboard!.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
            let nav = UINavigationController(rootViewController: destination)
            nav.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
            nav.navigationBar.tintColor = UIColor.white
            nav.navigationBar.isTranslucent = false
            self.revealViewController().setFront(nav, animated: true)
            self.revealViewController().revealToggle(animated: true)
        }
        else
        {
            self.tblMenuOptions.beginUpdates()
            let shouldCollapse: Bool = !collapsedSections.contains(section)
            if shouldCollapse
            {
                (sender.view!.viewWithTag(2) as! UIImageView).image = UIImage(named: "plus")
                (sender.view!.viewWithTag(2) as! UIImageView).layoutIfNeeded()
                let numOfRows = tblMenuOptions.numberOfRows(inSection: section)
                let indexPaths:[NSIndexPath] = self.indexPathsForSection(section: section, withNumberOfRows: numOfRows)
                self.tblMenuOptions.deleteRows(at: indexPaths as [IndexPath], with: .fade)
                collapsedSections.add(section)
            }
            else
            {
                (sender.view!.viewWithTag(2) as! UIImageView).image = UIImage(named: "minus")
                (sender.view!.viewWithTag(2) as! UIImageView).layoutIfNeeded()
                let indexPaths: [NSIndexPath] = self.indexPathsForSection(section: section, withNumberOfRows: menuWithinOption[section].count)
                self.tblMenuOptions.insertRows(at: indexPaths as [IndexPath], with: .fade)
                collapsedSections.remove(section)
                print(collapsedSections)
            }
            self.tblMenuOptions.endUpdates()
        }
        // self.collapsableTableView.reloadData()
        //  self.revealViewController().revealToggleAnimated(true)
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
}
