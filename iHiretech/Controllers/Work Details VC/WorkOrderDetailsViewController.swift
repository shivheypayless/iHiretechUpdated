//
//  WorkOrderDetailsViewController.swift
//  iHiretech
//
//  Created by Admin on 22/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import KLCPopup
import AFViewShaker
import HCSStarRatingView
import KLCPopup

class WorkOrderDetailsViewController: UIViewController , UIWebViewDelegate{

    @IBOutlet var lblWorkOrderId: UILabel!
    @IBOutlet var lblOrderView: UILabel!
    @IBOutlet var tblListing: UITableView!
    @IBOutlet var tabsCollectionView: UICollectionView!
    var workOrderId = Int()
    var getWorkListData = [String:Any]()
    var chatDetails = [String:Any]()
    var ExpensesList = [AnyObject]()
    var documentList = [AnyObject]()
    var tabsTag = 1
    var calenderPickerView = UIDatePicker()
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let locationManager = CLLocationManager()
    var conversation = ["Hello","Hi.","How are you?","I'm doing great. What have you been upto these days?","Nothing much! Just the usual corporate work life.","Ohh I see. BTW why don't you visit us for a dinner or something with Sue and kids.","Yeah sure why not!","How does next Saturday Night sound to you.","Yeah will do, as long as Sue doesn't have any other plans for the night.","Sure, I'll even notify Aisha about it","Cool","Meet up soon.","Cya"]
    
    var expenseText = UITextField()
    var expensesDescription = UITextField()
    var selectExpenses = UIButton()
    var expensesTable = UITableView()
    var tabs = ["Work Order Details","Messages","Workspace","Payments"]
    
    var ratingText = UILabel()
    var ratingView = HCSStarRatingView()
    var popup = KLCPopup()
    var calenderView = UIView()
    var comment = UITextField()
    var collapsedSections = NSMutableSet()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblOrderView.layer.cornerRadius = 3
        self.lblOrderView.layer.masksToBounds = true
        
        self.tblListing.estimatedRowHeight = 140
        self.tblListing.rowHeight = UITableViewAutomaticDimension
         self.tblListing.register(UINib(nibName: "SearchServiceTableViewCell", bundle: nil) , forCellReuseIdentifier: "SearchServiceTableViewCell")
         self.tblListing.register(UINib(nibName: "CustomerRateTableViewCell", bundle: nil) , forCellReuseIdentifier: "CustomerRateTableViewCell")
         self.tblListing.register(UINib(nibName: "WorkOrderInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "WorkOrderInformationTableViewCell")
         self.tblListing.register(UINib(nibName: "ScheduleInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "ScheduleInformationTableViewCell")
         self.tblListing.register(UINib(nibName: "LocationInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "LocationInformationTableViewCell")
         self.tblListing.register(UINib(nibName: "PayRateInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "PayRateInformationTableViewCell")
        self.tblListing.register(UINib(nibName: "DocumentsTableViewCell", bundle: nil) , forCellReuseIdentifier: "DocumentsTableViewCell")
        self.tblListing.register(UINib(nibName: "OwnerTableViewCell", bundle: nil) , forCellReuseIdentifier: "OwnerTableViewCell")
        self.tblListing.register(UINib(nibName: "OtherUserTableViewCell", bundle: nil) , forCellReuseIdentifier: "OtherUserTableViewCell")
        self.tblListing.register(UINib(nibName: "WorkspaceTableViewCell", bundle: nil) , forCellReuseIdentifier: "WorkspaceTableViewCell")
        self.tblListing.register(UINib(nibName: "LabourPaymentTableViewCell", bundle: nil) , forCellReuseIdentifier: "LabourPaymentTableViewCell")
        self.tblListing.register(UINib(nibName: "ExpensesInfoTableViewCell", bundle: nil) , forCellReuseIdentifier: "ExpensesInfoTableViewCell")
        self.tblListing.register(UINib(nibName: "EarningTableViewCell", bundle: nil) , forCellReuseIdentifier: "EarningTableViewCell")
        self.tblListing.register(UINib(nibName: "TotalPaymentTableViewCell", bundle: nil) , forCellReuseIdentifier: "TotalPaymentTableViewCell")
       
         self.tblListing.separatorStyle = .none
           self.tabsCollectionView.register(UINib(nibName: "TabOrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TabOrderCollectionViewCell")
        
        if let flowLayout = tabsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
       
        self.tabsCollectionView.delegate = self
        self.tabsCollectionView.dataSource = self
        
       // collapsedSections.add(1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

         getWorkList()
    }
    
    func getWorkList()
    {
        let parameters = ["id": self.workOrderId] as! [String:AnyObject]
        WebAPI().callJSONWebApi(API.workOrderDetails, withHTTPMethod: .post, forPostParameters: parameters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            self.chatDetails = serviceResponse["data"] as! [String : Any]
            self.getWorkListData = self.chatDetails["workOrderData"] as! [String:Any]
            self.lblWorkOrderId.text = "(ID: \(((self.getWorkListData)["work_order_number"] as? String)!) )"
            let cap = ((self.getWorkListData)["status_name"] as! String)
            let finalString = cap.capitalized
            self.lblOrderView.text = "  \(finalString)   "
            self.ExpensesList = (self.getWorkListData["tech_expenses"] as! [AnyObject])
            self.documentList = (self.getWorkListData["work_oder_document"] as! [AnyObject])
            self.tblListing.dataSource = self
            self.tblListing.delegate = self
            self.tblListing.reloadData()
        })
    }

    @IBAction func btn_Back(_ sender: UIBarButtonItem) {
       self.navigationController?.popViewController(animated: true)
    }
  
}

extension WorkOrderDetailsViewController : UICollectionViewDelegate , UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabOrderCollectionViewCell", for: indexPath) as! TabOrderCollectionViewCell
        cell.lblTabName.text = self.tabs[indexPath.row]
        if self.tabsTag == 1 && indexPath.row == 0
        {
             cell.scrollVIew.isHidden = false
        }
        else if self.tabsTag == 2 && indexPath.row == 1
        {
            cell.scrollVIew.isHidden = false
        }
        else if self.tabsTag == 3 && indexPath.row == 2
        {
            cell.scrollVIew.isHidden = false
        }
        else if self.tabsTag == 4 && indexPath.row == 3
        {
            cell.scrollVIew.isHidden = false
        }
        else
        {
            cell.scrollVIew.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TabOrderCollectionViewCell
      
        if cell.scrollVIew.isHidden == true
        {
            cell.scrollVIew.isHidden = false
        }
        else
        {
            cell.scrollVIew.isHidden = true
        }
        if indexPath.row == 0
        {
            self.tabsTag = 1
        }
        if indexPath.row == 1
        {
            self.tabsTag = 2
        }
        if indexPath.row == 2
        {
            self.tabsTag = 3
        }
        if indexPath.row == 3
        {
            self.tabsTag = 4
        }
        self.tabsCollectionView.reloadData()
        self.tblListing.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
   
}

extension WorkOrderDetailsViewController : UITableViewDelegate , UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblListing
        {
        if self.tabsTag == 1
        {
           return 8
        }
        else if self.tabsTag == 4
        {
            return 4
        }
            else if self.tabsTag == 2
        {
            return 0
        }
        else
        {
            return 1
        }
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblListing
        {
         if self.tabsTag == 4 && section == 1
         {
            return self.ExpensesList.count
        }
            else if self.tabsTag == 1 && section == 7
         {
            return self.documentList.count
         }
            else if self.tabsTag == 2
         {
            return self.conversation.count
         }
        else
         {
            return 1
         }
        }
        else
        {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblListing
        {
       if self.tabsTag == 1
       {
        if indexPath.section == 0
        {
             let cell = tableView.dequeueReusableCell(withIdentifier: "SearchServiceTableViewCell", for: indexPath) as! SearchServiceTableViewCell
            cell.lblLocation.text = ((self.getWorkListData)["location_address_line_1"] as? String)!+" "+((self.getWorkListData)["location_address_line_2"] as? String)!
            cell.lblOrderId.text = ((self.getWorkListData)["work_order_number"] as? String)!
            cell.lblServiceTitle.text = (((self.getWorkListData)["work_order_title"]) as? String)!
            cell.lblClientName.text = (((self.getWorkListData)["clients"]) as! [String:Any])["client_name"] as? String
            cell.lblManagerName.text = (((self.getWorkListData)["manager"]) as! [String:Any])["first_name"] as? String
            let technicianProcess = ((self.getWorkListData)["technician_process"] as! [String:Any])
            if ((technicianProcess)["Applied"] as? Bool) == true
            {
                cell.btnApply.setTitle("Already Applied", for: .normal)
            }
            else
            {
                cell.btnApply.addTarget(self, action: #selector(self.btnApplyAction(_ :)), for: .touchUpInside)
            }
            return cell
        }
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerRateTableViewCell", for: indexPath) as! CustomerRateTableViewCell
            cell.lblContactNo.text = ((self.getWorkListData)["location_contact_phone_number"] as? String)!
            cell.lblLocation.text = ((self.getWorkListData)["location_country"] as? String)!
            let information = self.chatDetails["chatWith"] as! [String:Any]
            cell.lblName.text = ((information)["first_name"] as? String)!+" "+((information)["last_name"] as? String)!
            cell.lblEmail.text = (((self.getWorkListData)["created_data"]) as! [String:Any])["email"] as? String
            cell.btnRating.addTarget(self, action: #selector(RatingAction(_ :)), for: .touchUpInside)
            
            return cell
        }
        else if indexPath.section == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOrderInformationTableViewCell", for: indexPath) as! WorkOrderInformationTableViewCell
//             cell.webViewHtml.delegate = self
            do {
                let attributedString = try? NSAttributedString(data: "   \((self.getWorkListData)["work_order_description"] as! String)".data(using: .unicode) ?? Data(), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                 cell.lblHtml.attributedText = attributedString
            } catch {
                print(error)
            }
            
            return cell
        }
        else if indexPath.section == 3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOrderInformationTableViewCell", for: indexPath) as! WorkOrderInformationTableViewCell
         
            do {
                let attributedString = try? NSAttributedString(data: "   \((self.getWorkListData)["additional_expenses"] as! String)".data(using: .unicode) ?? Data(), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                cell.lblHtml.attributedText = attributedString
            } catch {
                print(error)
            }
            
            return cell
        }
        else if indexPath.section == 4
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleInformationTableViewCell", for: indexPath) as! ScheduleInformationTableViewCell
            cell.lblDate.text = ((self.getWorkListData)["schedule_exact_date"] as? String)!
            cell.lblTime.text = ((self.getWorkListData)["schedule_exact_time"] as? String)!
            return cell
        }
        else if indexPath.section == 5
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationInformationTableViewCell", for: indexPath) as! LocationInformationTableViewCell
            cell.lblLocationName.text = ((self.getWorkListData)["location_contact_name"] as? String)!
            cell.lblAddress.text = ((self.getWorkListData)["location_address_line_1"] as? String)!+", "+((self.getWorkListData)["location_address_line_2"] as? String)!+", "+((self.getWorkListData)["location_country"] as? String)!+", "+((self.getWorkListData)["location_state"] as? String)!+", "+((self.getWorkListData)["location_city"] as? String)!
            cell.lblEmail.text = ((self.getWorkListData)["location_contact_email"] as? String)!
            cell.lblCOntactNo.text = ((self.getWorkListData)["location_contact_phone_number"] as? String)!
            return cell
        }
        else if indexPath.section == 6
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayRateInformationTableViewCell", for: indexPath) as! PayRateInformationTableViewCell
            let information = self.chatDetails["chatWith"] as! [String:Any]
            cell.lblPaymentType.text = ((information)["first_name"] as? String)!
            cell.lblMaxRate.text = String(describing: (information)["per_hour_max_hours"] as? Int)
            cell.lblHourlyRate.text = String(describing:(information)["per_hour_rate"] as? Float)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentsTableViewCell", for: indexPath) as! DocumentsTableViewCell
            cell.lblDocumentName.text = ((self.documentList[indexPath.row])["work_order_document_path"] as! String)
            return cell
        }
    }
        else if self.tabsTag == 2
       {
        if indexPath.row % 2 == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerTableViewCell", for: indexPath) as! OwnerTableViewCell
              cell.lblText.text = self.conversation[indexPath.row]
           // cell.lblText.text = chatHistory[indexPath.row]["message"] as? String
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherUserTableViewCell", for: indexPath) as! OtherUserTableViewCell
             cell.lblText.text = self.conversation[indexPath.row]
            return cell
        }
       }
       else if self.tabsTag == 4
       {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabourPaymentTableViewCell", for: indexPath) as! LabourPaymentTableViewCell
            cell.lblLabourAmount.text = "$ \((self.chatDetails)["labour_amount"] as! Double)"
            cell.lblTotalExpenses.text = "$ \(String(describing: self.chatDetails["total_expenses"] as! Int))"
            cell.lblTotalWOrkingHrs.text = "\((self.chatDetails)["total_hours"] as! Double) hrs"
            cell.btnAddExpenses.addTarget(self, action: #selector(btn_AddExpenses(_ :)), for: .touchUpInside)
            return cell
        }
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpensesInfoTableViewCell", for: indexPath) as! ExpensesInfoTableViewCell
            cell.lblType.text = ((self.ExpensesList[indexPath.row])["expense_type"] as! String)
            cell.lblAmount.text = ((self.ExpensesList[indexPath.row])["expense_amount"] as! String)
            cell.lblTotalAmount.text = ((self.ExpensesList[indexPath.row])["expense_amount"] as! String)
            cell.lblDescription.text = ((self.ExpensesList[indexPath.row])["expense_description"] as! String)
            cell.lblStatus.text = ""
            return cell
        }
        else if indexPath.section == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EarningTableViewCell", for: indexPath) as! EarningTableViewCell
            cell.lblPerHraRate.text =  "\((self.getWorkListData)["per_hour_rate"] as? String ?? "")"
            cell.lblMaxRate.text =  "\((self.getWorkListData)["per_hour_max_hours"] as? String ?? "")"
            cell.lblAmount.text = "\((self.getWorkListData)["temp_amount"] as? String ?? "")"
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalPaymentTableViewCell", for: indexPath) as! TotalPaymentTableViewCell
            cell.lblTotalPayment.text = ""
            if ((self.getWorkListData)["ihiretech_fee"] as? String) != ""
            {
               cell.lblFees.text = ((self.getWorkListData)["ihiretech_fee"] as? String)!
            }
            cell.lblTechnicianpayment.text = ""
            return cell
        }
       }
       else
       {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkspaceTableViewCell", for: indexPath) as! WorkspaceTableViewCell

         cell.btnCheckInDate.addTarget(self, action: #selector(self.DatePickerToDateIn(_:)), for: .touchUpInside)
         cell.btnCheckInTime.addTarget(self, action: #selector(self.self.DatePickerToTimeIn(_:)), for: .touchUpInside)
         cell.btnCheckOutDate.addTarget(self, action: #selector(self.DatePickerToDate(_:)), for: .touchUpInside)
         cell.btnCheckOutTime.addTarget(self, action: #selector(self.self.DatePickerToTime(_:)), for: .touchUpInside)
        let information = self.getWorkListData["checkin_checkout"] as! [String:Any]
       
         cell.btnCheckIn.addTarget(self, action: #selector(self.UpdateCheckIn(_:)), for: .touchUpInside)
         cell.btnCheckOut.addTarget(self, action: #selector(self.UpdateCheckOut(_:)), for: .touchUpInside)
        
        if ((information)["checkin_date"] as? String) != nil
        {
            cell.lblDate.text = ((information)["checkin_date"] as? String)!
            cell.img_CheckIn.image = UIImage(named : "img_CheckReminder")
            if ((self.getWorkListData)["status_name"] as! String) == "approved"
            {
                cell.btnCheckIn.isHidden = true
                cell.btnCheckOut.isHidden = true
                cell.cnstrntLocationTrackingButtonHeight.constant = 0
                self.tblListing.beginUpdates()
                self.tblListing.endUpdates()
            }
            else
            {
                cell.btnCheckIn.isHidden = false
                cell.btnCheckOut.isHidden = false
               cell.cnstrntLocationTrackingButtonHeight.constant = 30
               self.tblListing.beginUpdates()
               self.tblListing.endUpdates()
                cell.btnStartTracking.addTarget(self, action: #selector(self.startUpdatingLocationAfterCheckin(_:)), for: .touchUpInside)
            }
        }
        else
         {
            cell.img_CheckIn.image = UIImage(named : "img_UnCheckReminder")
         }
        if ((information)["checkin_time"] as? String) != nil
        {
            cell.lblTime.text = ((information)["checkin_time"] as? String)!
        }
        
        if ((information)["checkout_date"] as? String) != nil
        {
            cell.lblCheckOutDate.text! = ((information)["checkout_date"] as? String)!
            cell.imgCheckOut.image = UIImage(named : "img_CheckReminder")
        }
        else
        {
            cell.imgCheckOut.image = UIImage(named : "img_UnCheckReminder")
        }
        if ((information)["checkout_time"] as? String) != nil
        {
            cell.lblCheckoutTime.text = ((information)["checkout_time"] as? String)!
        }
        
        return cell
       }
    }
        else
        {
          let cell = tableView.dequeueReusableCell(withIdentifier: "StatesTableViewCell", for: indexPath) as! StatesTableViewCell
            let expensesListing = ["Material","Transportation"]
         //    cell.lblState.text = "Material"
            cell.lblState.text = expensesListing[indexPath.row]
            return cell
        }
 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView != self.tblListing
        {
            let cell = tableView.cellForRow(at: indexPath) as! StatesTableViewCell
            self.expensesTable.isHidden = true
            self.selectExpenses.setTitle("  \(String(describing: cell.lblState.text!))", for: .normal)
        }
    }

    
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if tableView == self.tblListing
    {
    if self.tabsTag == 1
    {
    let headerViewArray = Bundle.main.loadNibNamed("SearchViewExpandableView", owner: self, options: nil)?[0] as! UIView
    if section == 0
    {
        (headerViewArray.viewWithTag(4) as! UILabel).text = "Service Information"
    }
    else if section == 1
    {
        (headerViewArray.viewWithTag(4) as! UILabel).text = "About Customer Information"
    }
    else if section == 2
    {
        (headerViewArray.viewWithTag(4) as! UILabel).text = "Full Work Order Description"
    }
    else if section == 3
    {
        (headerViewArray.viewWithTag(4) as! UILabel).text = "Additional Information"
    }
    else if section == 4
    {
        (headerViewArray.viewWithTag(4) as! UILabel).text = "Service Schedule"
    }
    else if section == 5
    {
        (headerViewArray.viewWithTag(4) as! UILabel).text = "Location"
    }
    else if section == 6
    {
        (headerViewArray.viewWithTag(4) as! UILabel).text = "Service Pay Rate and Info"
    }
    else if section == 7
    {
        (headerViewArray.viewWithTag(4) as! UILabel).text = "Work Order Related Document"
    }
                let image = (headerViewArray.viewWithTag(2) as! UIImageView).isHidden = true
                (headerViewArray.viewWithTag(1) as! UIView).layer.borderWidth = 1
                (headerViewArray.viewWithTag(1) as! UIView).layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor

                return headerViewArray
    }
    else if self.tabsTag == 2
    {
        return nil
    }
    else if self.tabsTag == 3
    {
        let headerViewArray = Bundle.main.loadNibNamed("CheckInView", owner: self, options: nil)?[0] as! UIView
        (headerViewArray.viewWithTag(4) as! UILabel).text = "Task"
        let image = (headerViewArray.viewWithTag(2) as! UIImageView).isHidden = true
        (headerViewArray.viewWithTag(7) as! UIView).layer.borderWidth = 1
        (headerViewArray.viewWithTag(7) as! UIView).layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        (headerViewArray.viewWithTag(8) as! UIView).layer.borderWidth = 1
        (headerViewArray.viewWithTag(8) as! UIView).layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        return headerViewArray
    }
    else
    {
        
        if section == 0
        {
            let headerViewArray = Bundle.main.loadNibNamed("SearchViewExpandableView", owner: self, options: nil)?[0] as! UIView
            (headerViewArray.viewWithTag(4) as! UILabel).text = "Labour Payment"
            let image = (headerViewArray.viewWithTag(2) as! UIImageView).isHidden = true
            (headerViewArray.viewWithTag(1) as! UIView).layer.borderWidth = 1
            (headerViewArray.viewWithTag(1) as! UIView).layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
            return headerViewArray
        }
        else if section == 1
        {
            let headerViewArray = Bundle.main.loadNibNamed("ExpensesHeadersView", owner: self, options: nil)?[0] as! UIView
            headerViewArray.frame = CGRect(x:0, y:0, width: view.frame.width, height:150)
            (headerViewArray.viewWithTag(1) as! UIView).layer.borderWidth = 1
            (headerViewArray.viewWithTag(1) as! UIView).layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
            return headerViewArray
        }
        else if section == 2
        {
            let headerViewArray = Bundle.main.loadNibNamed("SearchViewExpandableView", owner: self, options: nil)?[0] as! UIView
            (headerViewArray.viewWithTag(4) as! UILabel).text = "Earnings"
            let image = (headerViewArray.viewWithTag(2) as! UIImageView).isHidden = true
            (headerViewArray.viewWithTag(1) as! UIView).layer.borderWidth = 1
            (headerViewArray.viewWithTag(1) as! UIView).layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
            return headerViewArray
        }
        else
        {
            let headerViewArray = Bundle.main.loadNibNamed("SearchViewExpandableView", owner: self, options: nil)?[0] as! UIView
            (headerViewArray.viewWithTag(4) as! UILabel).text = "Total Payment"
            let image = (headerViewArray.viewWithTag(2) as! UIImageView).isHidden = true
            (headerViewArray.viewWithTag(1) as! UIView).layer.borderWidth = 1
            (headerViewArray.viewWithTag(1) as! UIView).layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
            return headerViewArray
        }
        // (headerViewArray.viewWithTag(4) as! UILabel).text = "Payment"
    }
    }
    else
    {
        return nil
    }
}
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == tblListing
        {
        if self.tabsTag == 4 && section == 1
        {
           let headerViewArray = Bundle.main.loadNibNamed("ExpensesFooterView", owner: self, options: nil)?[0] as! UIView
             (headerViewArray.viewWithTag(1) as! UIView).layer.borderWidth = 1
            (headerViewArray.viewWithTag(1) as! UIView).layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
            return headerViewArray
        }
        else
        {
            return nil
        }
        }
        else
        {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if tableView == tblListing
        {
         if self.tabsTag == 4 && section == 1
        {
            return 129.0
        }
        else
        {
            return 47.0
        }
        }
        else
        {
            return 0
        }
    }
    
   
   func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if tableView == tblListing
        {
         if self.tabsTag == 4 && section == 1
        {
            return 111.0
        }
        else
        {
           return 0
        }
        }
        else
            {
                return 0
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tblListing
        {
        return UITableViewAutomaticDimension
        }
        else
        {
            return 40
        }
    }
    
    @objc func extendSection(_ sender : UIGestureRecognizer)
    {
        // self.collapsableTableView.reloadData()
        let section = sender.view!.tag
        print(section)
            self.tblListing.beginUpdates()
            let shouldCollapse: Bool = collapsedSections.contains(section)
            if shouldCollapse
            {
                (sender.view!.viewWithTag(2) as! UIImageView).image = UIImage(named: "plus")
                (sender.view!.viewWithTag(2) as! UIImageView).layoutIfNeeded()
                let numOfRows = tblListing.numberOfRows(inSection: section)
                let indexPaths:[NSIndexPath] = self.indexPathsForSection(section: section, withNumberOfRows: numOfRows)
                self.tblListing.deleteRows(at: indexPaths as [IndexPath], with: .fade)
                collapsedSections.add(section)
            }
            else
            {
                (sender.view!.viewWithTag(2) as! UIImageView).image = UIImage(named: "minus")
                (sender.view!.viewWithTag(2) as! UIImageView).layoutIfNeeded()
                 let numOfRows = tblListing.numberOfRows(inSection: section)
                let indexPaths: [NSIndexPath] = self.indexPathsForSection(section: section, withNumberOfRows: numOfRows)
                self.tblListing.insertRows(at: indexPaths as [IndexPath], with: .fade)
                collapsedSections.remove(section)
                print(collapsedSections)
            }
            self.tblListing.reloadData()
         //   self.tblListing.endUpdates()
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
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = self.tblListing.cellForRow(at: cell_indexPath as IndexPath) as! WorkspaceTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        tableViewCell.lblCheckOutDate.text = dateFormatter.string(from: calenderPickerView.date)
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
        self.calenderPickerView.datePickerMode = UIDatePickerMode.time
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
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = self.tblListing.cellForRow(at: cell_indexPath as IndexPath) as! WorkspaceTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        tableViewCell.lblCheckoutTime.text = dateFormatter.string(from: calenderPickerView.date)
    }
    
    @objc func DatePickerToDateIn(_ sender : UIGestureRecognizer)
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
        SaveButton.addTarget(self, action: #selector(self.btn_SaveDateToInAction(_:)), for: UIControlEvents.touchUpInside)
        popup = KLCPopup(contentView: calenderView , showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popup.show()
    }
    
    @objc func btn_SaveDateToInAction(_ sender: UIButton)
    {
        popup.dismiss(true)
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = self.tblListing.cellForRow(at: cell_indexPath as IndexPath) as! WorkspaceTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        tableViewCell.lblDate.text = dateFormatter.string(from: calenderPickerView.date)
    }
    
    
    @objc func DatePickerToTimeIn(_ sender : UIGestureRecognizer)
    {
        view.endEditing(true)
        var calenderView = UIView()
        calenderView = Bundle.main.loadNibNamed("DatePickerView", owner: self, options: nil)?[0] as! UIView
        calenderView.layer.cornerRadius = 10.0
        calenderView.layer.masksToBounds = true
        self.calenderPickerView = (calenderView.viewWithTag(3)! as! UIDatePicker)
        self.calenderPickerView.datePickerMode = UIDatePickerMode.time
        //  self.calenderPickerView.maximumDate = Date()
        let CloseButton = calenderView.viewWithTag(1) as! UIButton
        CloseButton.addTarget(self, action: #selector(self.btn_CloseAction(_:)), for: UIControlEvents.touchUpInside)
        let SaveButton = calenderView.viewWithTag(2) as! UIButton
        SaveButton.addTarget(self, action: #selector(self.btn_SaveTimeInAction(_:)), for: UIControlEvents.touchUpInside)
        popup = KLCPopup(contentView: calenderView , showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popup.show()
    }
    
    @objc func btn_SaveTimeInAction(_ sender: UIButton)
    {
        popup.dismiss(true)
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = self.tblListing.cellForRow(at: cell_indexPath as IndexPath) as! WorkspaceTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        tableViewCell.lblTime.text = dateFormatter.string(from: calenderPickerView.date)
    }
    
    @objc func btn_AddExpenses(_ sender: UIButton)
    {
        view.endEditing(true)
        var calenderView = UIView()
        calenderView = Bundle.main.loadNibNamed("AddExpensesView", owner: self, options: nil)?[0] as! UIView
        calenderView.layer.cornerRadius = 10.0
        calenderView.layer.masksToBounds = true
        self.expenseText = calenderView.viewWithTag(4) as! UITextField
        self.expensesDescription = calenderView.viewWithTag(5) as! UITextField
        self.expensesTable = calenderView.viewWithTag(2) as! UITableView
        self.expensesTable.layer.borderWidth = 1
        self.expensesTable.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.expensesTable.register(UINib(nibName: "StatesTableViewCell", bundle: nil) , forCellReuseIdentifier: "StatesTableViewCell")
        self.expensesTable.delegate = self
        self.expensesTable.dataSource = self
        self.expensesTable.isHidden = true
        self.selectExpenses = calenderView.viewWithTag(1) as! UIButton
        self.selectExpenses.addTarget(self, action: #selector(self.btn_OpenTable(_ :)), for: .touchUpInside)
        (calenderView.viewWithTag(3) as! UIView).layer.borderWidth = 1
        (calenderView.viewWithTag(3) as! UIView).layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.expensesDescription.layer.borderWidth = 1
        self.expensesDescription.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.selectExpenses.layer.borderWidth = 1
        self.selectExpenses.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        let CloseButton = calenderView.viewWithTag(6) as! UIButton
        CloseButton.addTarget(self, action: #selector(self.btn_CloseAction(_:)), for: UIControlEvents.touchUpInside)
        let SaveButton = calenderView.viewWithTag(7) as! UIButton
        SaveButton.addTarget(self, action: #selector(self.btn_SubmitExpenses(_:)), for: UIControlEvents.touchUpInside)
        popup = KLCPopup(contentView: calenderView , showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popup.show()
    }
    
    @objc func btn_OpenTable(_ sender : UIButton)
    {
       self.expensesTable.isHidden = false
       self.expensesTable.delegate = self
       self.expensesTable.dataSource = self
       self.expensesTable.reloadData()
    }
    
    @objc func btn_SubmitExpenses(_ sender : UIButton)
    {
       
        if self.expenseText.text! == "" && self.selectExpenses.titleLabel?.text! == "  Select"
        {
             self.selectExpenses.titleLabel?.textColor = UIColor.red
             self.expenseText.attributedPlaceholder = NSMutableAttributedString(string: "Enter expense amount",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        }
        else if self.selectExpenses.titleLabel?.text! == "  Select"
        {
            self.selectExpenses.titleLabel?.textColor = UIColor.red
        }
        else if self.expenseText.text! == ""
       {
          self.expenseText.attributedPlaceholder = NSMutableAttributedString(string: "Enter expense amount",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
       }
       
        else if self.expenseText.text! != "" && self.selectExpenses.titleLabel?.text! != "  Select"
       {
         let parameters = ["work_order_id": self.workOrderId ,"expense_type": (self.selectExpenses.titleLabel?.text!)!,"expense_amount":Int(self.expenseText.text!)! , "expense_description":self.expensesDescription.text!] as [String:AnyObject]
        WebAPI().callJSONWebApi(API.addExpenses, withHTTPMethod: .post, forPostParameters: parameters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            self.popup.dismiss(true)
            if let message = serviceResponse["msg"] as? String
            {
                AListAlertController.shared.presentAlertController(message: message, completionHandler: nil)
            }
        })
       }
        
    }
    
    func StopSendingLocation()
     {
          appdelegate.locationObjectAllocation(workOrderID: self.workOrderId, status: 0)
     }
    
    @objc func UpdateCheckIn(_ sender: UIButton)
    {
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = self.tblListing.cellForRow(at: cell_indexPath as IndexPath) as! WorkspaceTableViewCell
       
        if tableViewCell.lblDate.text! != "Select Date" && tableViewCell.lblTime.text! != "Select Time"
        {
              tableViewCell.img_CheckIn.image = UIImage(named : "img_CheckReminder")
            tableViewCell.viewCheckInDate.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
            tableViewCell.viewCheckInTime.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
            let parameters = ["work_order_id": self.workOrderId ,"checkin_date": tableViewCell.lblDate.text!,"checkin_time":tableViewCell.lblTime.text!] as [String:AnyObject]
           
        WebAPI.shared.callJSONWebApi(API.checkIn, withHTTPMethod: .post, forPostParameters: parameters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            if let message = serviceResponse["msg"] as? String
            {
                AListAlertController.shared.presentAlertController(message: message)
                {
                    tableViewCell.cnstrntLocationTrackingButtonHeight.constant = 30
                    self.tblListing.beginUpdates()
                    self.tblListing.endUpdates()
                }
            }
        })
        }
        else
        {
            if tableViewCell.lblDate.text! == "Select Date"
            {
            let viewShaker = AFViewShaker(view: tableViewCell.viewCheckInDate)
            tableViewCell.viewCheckInDate.layer.borderColor = UIColor.red.cgColor
            print(tableViewCell.viewCheckInDate)
            viewShaker?.shake()
            return
            }
            else if tableViewCell.lblTime.text! == "Select Time"
            {
                let viewShaker = AFViewShaker(view: tableViewCell.viewCheckInTime)
                tableViewCell.viewCheckInTime.layer.borderColor = UIColor.red.cgColor
                print(tableViewCell.viewCheckInTime)
                viewShaker?.shake()
            }
            else
            {
                 tableViewCell.viewCheckInDate.layer.borderColor = UIColor.red.cgColor
                 tableViewCell.viewCheckInTime.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    @objc func startUpdatingLocationAfterCheckin(_ sender: UIButton)
    {
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = self.tblListing.cellForRow(at: cell_indexPath as IndexPath) as! WorkspaceTableViewCell
        if tableViewCell.btnStartTracking.titleLabel?.text == "Start Tracking Location"
        {
             tableViewCell.btnStartTracking.setTitle("Pause Tracking Location", for: .normal)
            self.locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
                self.locationManager.startUpdatingLocation()
                self.startUpdatingLocation()
        }
        else
        {
            self.locationManager.requestWhenInUseAuthorization()
        }
        }
        else
        {
             tableViewCell.btnStartTracking.setTitle("Start Tracking Location", for: .normal)
             self.StopSendingLocation()
        }
    }
    
    @objc func UpdateCheckOut(_ sender: UIButton)
    {
        let cell_indexPath = NSIndexPath(row: 0, section: 0)
        let tableViewCell = self.tblListing.cellForRow(at: cell_indexPath as IndexPath) as! WorkspaceTableViewCell
        tableViewCell.imgCheckOut.image = UIImage(named : "img_CheckReminder")
        if tableViewCell.lblCheckOutDate.text! != "Select Date" && tableViewCell.lblCheckoutTime.text! != "Select Time"
        {
            tableViewCell.img_CheckIn.image = UIImage(named : "img_CheckReminder")
            tableViewCell.viewCheckOutDate.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
            tableViewCell.viewCheckOutTIme.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        let parameters = ["work_order_id": self.workOrderId ,"checkout_date": tableViewCell.lblCheckOutDate.text!,"checkout_time":tableViewCell.lblCheckoutTime.text!] as [String:AnyObject]
        WebAPI().callJSONWebApi(API.checkOut, withHTTPMethod: .post, forPostParameters: parameters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            if let message = serviceResponse["msg"] as? String
            {
                 AListAlertController.shared.presentAlertController(message: message)
                 {
                    tableViewCell.cnstrntLocationTrackingButtonHeight.constant = 0
                    self.tblListing.beginUpdates()
                    self.tblListing.endUpdates()
                    self.StopSendingLocation()
                 }
            }
        })
        }
        else
        {
            if tableViewCell.lblCheckOutDate.text! == "Select Date"
            {
                let viewShaker = AFViewShaker(view: tableViewCell.viewCheckOutDate)
                tableViewCell.viewCheckOutDate.layer.borderColor = UIColor.red.cgColor
                print(tableViewCell.viewCheckOutDate)
                viewShaker?.shake()
                return
            }
            else if tableViewCell.lblCheckoutTime.text! == "Select Time"
            {
                let viewShaker = AFViewShaker(view: tableViewCell.viewCheckOutTIme)
                tableViewCell.viewCheckOutTIme.layer.borderColor = UIColor.red.cgColor
                print(tableViewCell.viewCheckOutTIme)
                viewShaker?.shake()
            }
            else
            {
                tableViewCell.viewCheckOutDate.layer.borderColor = UIColor.red.cgColor
                tableViewCell.viewCheckOutTIme.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
  func startUpdatingLocation()
  {
      appdelegate.locationObjectAllocation(workOrderID: self.workOrderId, status: 1)
  }
    
    @objc func RatingAction(_ sender : UIGestureRecognizer)
    {
        view.endEditing(true)
        calenderView = Bundle.main.loadNibNamed("RatingView", owner: self, options: nil)?[0] as! UIView
        calenderView.layer.cornerRadius = 10.0
        calenderView.layer.masksToBounds = true
        ratingText =  calenderView.viewWithTag(6) as! UILabel
        ratingText.text = "0/5"
        
        comment = calenderView.viewWithTag(7) as! UITextField
        comment.layer.borderWidth = 1
        comment.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        ratingView = calenderView.viewWithTag(1) as! HCSStarRatingView
        ratingView.addTarget(self, action: #selector(self.btn_StartAction), for: .valueChanged)
        let CloseButton = calenderView.viewWithTag(8) as! UIButton
        CloseButton.addTarget(self, action: #selector(self.btn_CloseAction(_:)), for: UIControlEvents.touchUpInside)
        let SaveButton = calenderView.viewWithTag(9) as! UIButton
        SaveButton.addTarget(self, action: #selector(self.btn_RateNow(_:)), for: UIControlEvents.touchUpInside)
        popup = KLCPopup(contentView: calenderView , showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popup.show()
    }
    
    func updateRating()
    {
       
        let parameters = ["id": self.workOrderId , "rating": ratingView.value , "comment": comment.text!] as [String:AnyObject]
        WebAPI().callJSONWebApi(API.workOrderDetails, withHTTPMethod: .post, forPostParameters: parameters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            if let message = serviceResponse["msg"] as? String
            {
                AListAlertController.shared.presentAlertController(message: message)
                {
                }
            }
        })
    }

    
    @objc func btn_RateNow(_ sender: UIButton)
    {
        if self.ratingText.text! != "0/5" && self.comment.text! != ""
        {
            updateRating()
            popup.dismiss(true)
        }
        else  if self.ratingText.text! == "0/5"
        {
            
        }
        
    }
    
    @objc func btn_StartAction()
    {
        print(ratingView.value)
        self.ratingText.text! = "\(String(describing: ratingView.value))/5"
    }
    
    @objc func btnApplyAction(_ sender: UIButton)
    {
        if ((self.getWorkListData)["payment_rate_type"] as? String)! == "3"
        {
            let nav = self.storyboard!.instantiateViewController(withIdentifier: "BlendedApplyViewController") as! BlendedApplyViewController
            nav.workOrderId = self.workOrderId
            nav.statusName = ((self.getWorkListData)["status_name"] as! String)
            nav.paymentRateType = ((self.getWorkListData)["payment_rate_type"] as? String)!
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
            let nav = self.storyboard!.instantiateViewController(withIdentifier: "ApplyWorkViewController") as! ApplyWorkViewController
            nav.workOrderId = self.workOrderId
            nav.statusName = ((self.getWorkListData)["status_name"] as! String)
            nav.paymentRateType = ((self.getWorkListData)["payment_rate_type"] as? String)!
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
    
}

extension WorkOrderDetailsViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            self.startUpdatingLocation()
        }
        else if status == .denied
        {
             AListAlertController.shared.presentAlertController(message: "GPS location is disabled. Please enable it from settings to get current location.")
             {
                UIApplication.shared.openURL(URL(string: "App-Prefs:root=Privacy&path=LOCATION")!)
             }
            
        }
    }
}


