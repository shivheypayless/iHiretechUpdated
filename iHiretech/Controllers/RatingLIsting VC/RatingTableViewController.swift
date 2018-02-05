//
//  RatingTableViewController.swift
//  iHiretech
//
//  Created by Admin on 18/01/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import KLCPopup
import SWRevealViewController

class RatingTableViewController: UITableViewController {
    var frmSrc = String()
     var appdelegate = UIApplication.shared.delegate as! AppDelegate
     var ratingList = [AnyObject]()
     var customerId = Int()
     var popup = KLCPopup()
     var calenderPickerView = UIDatePicker()
    var collapsedSections = NSMutableSet()
    var workOrderId = Int()
    var noDataFound = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        collapsedSections.add(1)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
        self.navigationItem.title = "Rating List"
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let button2 =  UIBarButtonItem(image: UIImage(named: "img_Notification"), style: .plain, target: self, action: #selector(SearchWorkOrderTableViewController.btnNotificationAction))
        let button3 =  UIBarButtonItem(image: UIImage(named: "img_Chat"), style: .plain, target: self, action: #selector(SearchWorkOrderTableViewController.btnChatAction))
        let button4 =  UIBarButtonItem(image: UIImage(named: "img_Back"), style: .plain, target: self, action: #selector(SearchWorkOrderTableViewController.btnbackAction))
        self.navigationItem.setRightBarButtonItems([button2,button3], animated: true)
          button3.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = button4
         self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.tableView.register(UINib(nibName: "RatingFilterTableViewCell", bundle: nil) , forCellReuseIdentifier: "RatingFilterTableViewCell")
        self.tableView.register(UINib(nibName: "RateListTableViewCell", bundle: nil) , forCellReuseIdentifier: "RateListTableViewCell")
        self.tableView.separatorStyle = .none
        
        getRatingList()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    func getRatingList()
    {
        let parameter = ["id": self.customerId] as [String:Any]
        WebAPI().callJSONWebApi(API.ratingTechnicianList, withHTTPMethod: .get, forPostParameters: parameter, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            let data = serviceResponse["data"] as? [String:Any]
            self.ratingList = data!["rating_list"] as! [AnyObject]
            if self.ratingList.count == 0
            {
                let label = UILabel(frame: CGRect(x: 16, y: 540, width: 200, height: 21))
                label.textAlignment = NSTextAlignment.center
                label.text = "No Search Found"
                self.view.addSubview(label)
            }
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
            
        })
        
    }
    
    @objc func btnNotificationAction(_ sender: UIButton)
    {
        let nav = (appdelegate.storyBoard)?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        nav.frmSrc = "Rating"
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
    
    @objc func btnChatAction(_ sender: UIButton)
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
        if self.frmSrc == "LeftMenu"
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            let nav = UINavigationController(rootViewController: destination)
            nav.navigationBar.isHidden = true
            self.revealViewController().setFront(nav, animated: true)
        }
        else
        {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
       //  self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0
        {
             return collapsedSections.contains(section) ? 0 :  1
        }
        else
        {
            return self.ratingList.count
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
          let cell = tableView.dequeueReusableCell(withIdentifier: "RatingFilterTableViewCell", for: indexPath) as! RatingFilterTableViewCell
            cell.btnOneStar.addTarget(self, action: #selector(self.btn_OneStarAction(_ :)), for: .touchUpInside)
            cell.btnTwoStar.addTarget(self, action: #selector(self.btn_TwoStarAction(_ :)), for: .touchUpInside)
            cell.btnThreeStar.addTarget(self, action: #selector(self.btn_ThreeStarAction(_ :)), for: .touchUpInside)
            cell.btnFourStar.addTarget(self, action: #selector(self.btn_FourStarAction(_ :)), for: .touchUpInside)
            cell.btnFiveStar.addTarget(self, action: #selector(self.btn_FiveStarAction(_ :)), for: .touchUpInside)
            cell.btnSearch.addTarget(self, action: #selector(self.btn_SearchAction(_ :)), for: .touchUpInside)
            cell.btnFromDate.addTarget(self, action: #selector(self.DatePickerToDate(_:)), for: .touchUpInside)
            cell.btnTodate.addTarget(self, action: #selector(self.self.DatePickerToTime(_:)), for: .touchUpInside)
          return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RateListTableViewCell", for: indexPath) as! RateListTableViewCell
            cell.lblName.text = (self.ratingList[indexPath.row]["usersDetails"] as? String)!
            if let n = NumberFormatter().number(from: (self.ratingList[indexPath.row]["rating"] as! String)) {
                let f = CGFloat(truncating: n)
                cell.viewRating.value = f
                cell.viewRating.filledStarImage = #imageLiteral(resourceName: "img_OrangeStar")
                cell.viewRating.halfStarImage = #imageLiteral(resourceName: "img_HalfStarOrng")
            }
            let img_url = (self.ratingList[indexPath.row]["userpic"] as! String)
            if img_url == "" {
                
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        cell.imgProfilePic.image = UIImage(named: "img_selectProfilePic")
                    }
                }
                
            }
            else
            {
                DispatchQueue.global(qos: .background).async {
                    let data = try? Data(contentsOf: URL(string: img_url)!)
                    if data != nil {
                        DispatchQueue.main.async {
                             cell.imgProfilePic.image = UIImage(data: data!)
                        }
                    }
                }
            }
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
                return headerViewArray
            }
            else
            {
                let headerViewArray = Bundle.main.loadNibNamed("SearchResultHeaderView", owner: self, options: nil)?[0] as! UIView
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
        return UITableViewAutomaticDimension
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
                if self.ratingList.count == 0
                {
                    self.noDataFound.text = ""
                    self.noDataFound = UILabel(frame: CGRect(x: 16, y: 110, width: 200, height: 16))
                   // label.textAlignment = NSTextAlignment.center
                    self.noDataFound.text = "No Search Found"
                    self.noDataFound.textColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                    self.view.addSubview(self.noDataFound)
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
                if self.ratingList.count == 0
                {
                    self.noDataFound.text = ""
                    self.noDataFound = UILabel(frame: CGRect(x: 16, y: 580, width: 200, height: 16))
                    // label.textAlignment = NSTextAlignment.center
                    self.noDataFound.text = "No Search Found"
                    self.noDataFound.textColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                    self.view.addSubview(self.noDataFound)
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
    
    @objc func btn_OneStarAction(_ sender: UIButton)
    {
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = self.tableView.cellForRow(at: cell_indexPath as IndexPath) as! RatingFilterTableViewCell
        tableViewCell.imgOne.image = #imageLiteral(resourceName: "img_RadioOn")
        tableViewCell.imgTwo.image = #imageLiteral(resourceName: "img_RadioOff")
        tableViewCell.imgThree.image = #imageLiteral(resourceName: "img_RadioOff")
        tableViewCell.imgFour.image = #imageLiteral(resourceName: "img_RadioOff")
        tableViewCell.imgFive.image = #imageLiteral(resourceName: "img_RadioOff")
    }
    @objc func btn_TwoStarAction(_ sender: UIButton)
    {
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = self.tableView.cellForRow(at: cell_indexPath as IndexPath) as! RatingFilterTableViewCell
        tableViewCell.imgOne.image = #imageLiteral(resourceName: "img_RadioOff")
        tableViewCell.imgTwo.image = #imageLiteral(resourceName: "img_RadioOn")
        tableViewCell.imgThree.image = #imageLiteral(resourceName: "img_RadioOff")
        tableViewCell.imgFour.image = #imageLiteral(resourceName: "img_RadioOff")
        tableViewCell.imgFive.image = #imageLiteral(resourceName: "img_RadioOff")
    }
    @objc func btn_ThreeStarAction(_ sender: UIButton)
    {
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = self.tableView.cellForRow(at: cell_indexPath as IndexPath) as! RatingFilterTableViewCell
        tableViewCell.imgOne.image = #imageLiteral(resourceName: "img_RadioOff")
        tableViewCell.imgTwo.image = #imageLiteral(resourceName: "img_RadioOff")
        tableViewCell.imgThree.image = #imageLiteral(resourceName: "img_RadioOn")
        tableViewCell.imgFour.image = #imageLiteral(resourceName: "img_RadioOff")
        tableViewCell.imgFive.image = #imageLiteral(resourceName: "img_RadioOff")
    }
    @objc func btn_FourStarAction(_ sender: UIButton)
    {
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = self.tableView.cellForRow(at: cell_indexPath as IndexPath) as! RatingFilterTableViewCell
        tableViewCell.imgOne.image = #imageLiteral(resourceName: "img_RadioOff")
        tableViewCell.imgTwo.image = #imageLiteral(resourceName: "img_RadioOff")
        tableViewCell.imgThree.image = #imageLiteral(resourceName: "img_RadioOff")
        tableViewCell.imgFour.image = #imageLiteral(resourceName: "img_RadioOn")
        tableViewCell.imgFive.image = #imageLiteral(resourceName: "img_RadioOff")
    }
    @objc func btn_FiveStarAction(_ sender: UIButton)
    {
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = self.tableView.cellForRow(at: cell_indexPath as IndexPath) as! RatingFilterTableViewCell
        tableViewCell.imgOne.image = #imageLiteral(resourceName: "img_RadioOff")
        tableViewCell.imgTwo.image = #imageLiteral(resourceName: "img_RadioOff")
        tableViewCell.imgThree.image = #imageLiteral(resourceName: "img_RadioOff")
        tableViewCell.imgFour.image = #imageLiteral(resourceName: "img_RadioOff")
        tableViewCell.imgFive.image = #imageLiteral(resourceName: "img_RadioOn")
    }
    
     @objc func btn_SearchAction(_ sender: UIButton)
    {
        var rate = Int()
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = self.tableView.cellForRow(at: cell_indexPath as IndexPath) as! RatingFilterTableViewCell
       // tableViewCell.viewToDate.txtFieldName.text
        if tableViewCell.imgOne.image == #imageLiteral(resourceName: "img_RadioOn")
        {
            rate = 1
        }
        else if tableViewCell.imgTwo.image == #imageLiteral(resourceName: "img_RadioOn")
        {
            rate = 2
        }
        else if tableViewCell.imgThree.image == #imageLiteral(resourceName: "img_RadioOn")
        {
            rate = 3
        }
        else if tableViewCell.imgFour.image == #imageLiteral(resourceName: "img_RadioOn")
        {
            rate = 4
        }
        else if tableViewCell.imgFive.image == #imageLiteral(resourceName: "img_RadioOn")
        {
            rate = 5
        }
        else
        {
            rate = 0
        }
        let parameter = ["customer_id": self.customerId , "from_date":tableViewCell.viewFromDate.txtFieldName.text!,"to_date": tableViewCell.viewToDate.txtFieldName.text!,"rating": rate] as [String:Any]
        WebAPI().callJSONWebApi(API.filterRatingList, withHTTPMethod: .post, forPostParameters: parameter, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            let data = serviceResponse["data"] as? [String:Any]
            self.ratingList = data!["rating_list"] as! [AnyObject]
            if self.ratingList.count == 0
            {
                self.noDataFound = UILabel(frame: CGRect(x: 16, y: 580, width: 200, height: 16))
              //  label.textAlignment = NSTextAlignment.center
                self.noDataFound.text = "No Search Found"
                self.noDataFound.textColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                self.view.addSubview(self.noDataFound)
            }
            self.tableView.reloadData()
        })
    }
    
    @objc func DatePickerToDate(_ sender : UIGestureRecognizer)
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
        SaveButton.addTarget(self, action: #selector(self.btn_SaveDateToOutAction(_:)), for: UIControlEvents.touchUpInside)
        popup = KLCPopup(contentView: calenderView , showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popup.show()
    }
    
    @objc func btn_SaveDateToOutAction(_ sender: UIButton)
    {
        popup.dismiss(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = self.tableView.cellForRow(at: cell_indexPath as IndexPath) as! RatingFilterTableViewCell
        tableViewCell.viewFromDate.txtFieldName.text = dateFormatter.string(from: calenderPickerView.date)
    //    (self.checkOutView.viewWithTag(3) as! UILabel).text! = dateFormatter.string(from: calenderPickerView.date)
    }
    
    @objc func btn_CloseAction(_ sender: UIButton)
    {
        popup.dismiss(true)
    }
    
    @objc func DatePickerToTime(_ sender : UIGestureRecognizer)
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
        SaveButton.addTarget(self, action: #selector(self.btn_SaveTimeOutAction(_:)), for: UIControlEvents.touchUpInside)
        popup = KLCPopup(contentView: calenderView , showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popup.show()
    }
    
    @objc func btn_SaveTimeOutAction(_ sender: UIButton)
    {
        popup.dismiss(true)
        let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "MM-dd-YYYY"
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = self.tableView.cellForRow(at: cell_indexPath as IndexPath) as! RatingFilterTableViewCell
        tableViewCell.viewToDate.txtFieldName.text = dateFormatter.string(from: calenderPickerView.date)
       // (self.checkOutView.viewWithTag(5) as! UILabel).text! = dateFormatter.string(from: calenderPickerView.date)
    }
    
 
}
