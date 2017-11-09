//
//  MyWorkOrderTableViewController.swift
//  iHiretech
//
//  Created by HPL on 30/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class MyWorkOrderTableViewController: UITableViewController {
    
    var collapsedSections = NSMutableSet()
     var appdelegate = UIApplication.shared.delegate as! AppDelegate
    var frmSrc = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationItem.title = "My Work Order"
        self.navigationItem.titleView?.tintColor = UIColor.white
        
         self.tableView.register(UINib(nibName: "WorkOrderTableViewCell", bundle: nil) , forCellReuseIdentifier: "WorkOrderTableViewCell")
        self.tableView.register(UINib(nibName: "SearchWorkOrderTableViewCell", bundle: nil) , forCellReuseIdentifier: "SearchWorkOrderTableViewCell")
        self.tableView.separatorStyle = .none
        collapsedSections.add(1)
        
      
        
        let button2 =  UIBarButtonItem(image: UIImage(named: "img_Notification"), style: .plain, target: self, action: #selector(btnNotificationAction))
        
        let button3 =  UIBarButtonItem(image: UIImage(named: "img_Chat"), style: .plain, target: self, action: #selector(btnChatAction))
        
        let button4 =  UIBarButtonItem(image: UIImage(named: "img_Back"), style: .plain, target: self, action: #selector(btnbackAction))
        
        self.navigationItem.setRightBarButtonItems([button2,button3], animated: true)
        self.navigationItem.leftBarButtonItem = button4
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
         return collapsedSections.contains(section) ? 0 :  1
        }
        else
        {
            return 2
        }
    }
   
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
          let cell = tableView.dequeueReusableCell(withIdentifier: "SearchWorkOrderTableViewCell", for: indexPath) as! SearchWorkOrderTableViewCell
          return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOrderTableViewCell", for: indexPath) as! WorkOrderTableViewCell
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0
        {
          let headerViewArray = Bundle.main.loadNibNamed("SearchViewExpandableView", owner: self, options: nil)?[0] as! UIView
            (headerViewArray.viewWithTag(1) as! UIView).layer.borderWidth = 1
            (headerViewArray.viewWithTag(1) as! UIView).layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
            var tap = UITapGestureRecognizer()
            tap =  UITapGestureRecognizer(target: self, action: #selector(self.extendSection))
            headerViewArray.addGestureRecognizer(tap)
            headerViewArray.tag = section
//          headerViewArray.layer.borderWidth = 1
//          headerViewArray.layer.borderColor = UIColor.lightGray.cgColor
          return headerViewArray
        }
        else
        {
            let headerViewArray = Bundle.main.loadNibNamed("SearchResultHeaderView", owner: self, options: nil)?[0] as! UIView
            
//            headerViewArray.layer.borderWidth = 1
//            headerViewArray.layer.borderColor = UIColor.lightGray.cgColor
            return headerViewArray
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
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
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
   {
    if indexPath.section == 0
    {
        return 384
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
    
    func closeSection(_ sender : Int)
    {
        self.tableView.beginUpdates()
        let numOfRows = tableView.numberOfRows(inSection: sender)
        let indexPaths:[NSIndexPath] = self.indexPathsForSection(section: sender, withNumberOfRows: numOfRows)
        self.tableView.deleteRows(at: indexPaths as [IndexPath], with: .fade)
        collapsedSections.add(sender)
        self.tableView.endUpdates()
        self.tableView.reloadData()
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
