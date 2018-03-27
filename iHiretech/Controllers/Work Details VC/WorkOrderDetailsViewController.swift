//
//  WorkOrderDetailsViewController.swift
//  iHiretech
//
//  Created by Admin on 22/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import AFViewShaker
import HCSStarRatingView//
import KLCPopup
import Alamofire

typealias getChatDetails = (String) -> Void

class WorkOrderDetailsViewController: UIViewController , UIWebViewDelegate , URLSessionDownloadDelegate{
   
    @IBOutlet var viewMsgBorder: UIView!
    @IBOutlet var cnstViewChatBottom: NSLayoutConstraint!
    @IBOutlet var txtSendMsg: UITextField!
    @IBOutlet var viewChat: UIView!
    @IBOutlet var lblOrderView: UIButton!
    @IBOutlet var lblWorkOrderId: UILabel!
    @IBOutlet var tblListing: UITableView!
    @IBOutlet var tabsCollectionView: UICollectionView!
    var workOrderId = Int()
    var getWorkListData = [String:Any]()
    var chatDetails = [String:Any]()
    var chatHistory = [AnyObject]()
    var ExpensesList = [AnyObject]()
    var documentList = [AnyObject]()
    var tabsTag = 1
    var calenderPickerView = UIDatePicker()
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let locationManager = CLLocationManager()
    var session: URLSession!//(configuration: .default)
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
    
   var checkInView = UIView()
   var checkOutView = UIView()
   var sendMessageId = String()
   var socketId = String()
    var custManager = 1
    var isTyping = false {
        didSet {
            guard oldValue != isTyping else {
                return
            }
            guard isTyping else {
                self.tblListing.reloadData()
                return
            }
            let lastIndexPath = self.tblListing.indexPathsForVisibleRows!.sorted(by: { $0.row < $1.row }).last!
            
            self.tblListing.reloadData()
            guard lastIndexPath.row == chatHistory.count - 1 else {
                return
            }
            self.tblListing.scrollToRow(at: IndexPath(row: lastIndexPath.row + 1, section: 0) , at: .bottom, animated: false)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        self.viewMsgBorder.layer.borderWidth = 1
        self.viewMsgBorder.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.viewMsgBorder.layer.cornerRadius = 2
        self.viewMsgBorder.layer.masksToBounds = true
        self.lblOrderView.layer.cornerRadius = 3
        self.lblOrderView.layer.masksToBounds = true
        self.cnstViewChatBottom.constant = -35
        self.txtSendMsg.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
        self.tblListing.estimatedRowHeight = 140
        self.tblListing.rowHeight = UITableViewAutomaticDimension
        //  self.tabsCollectionView.delegate = self
        //  self.tabsCollectionView.dataSource = self
        self.tblListing.register(UINib(nibName: "SearchServiceTableViewCell", bundle: nil) , forCellReuseIdentifier: "SearchServiceTableViewCell")
        self.tblListing.register(UINib(nibName: "CustomerRateTableViewCell", bundle: nil) , forCellReuseIdentifier: "CustomerRateTableViewCell")
        self.tblListing.register(UINib(nibName: "WorkOrderInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "WorkOrderInformationTableViewCell")
        self.tblListing.register(UINib(nibName: "ScheduleInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "ScheduleInformationTableViewCell")
        self.tblListing.register(UINib(nibName: "LocationInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "LocationInformationTableViewCell")
        self.tblListing.register(UINib(nibName: "PayRateInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "PayRateInformationTableViewCell")
        self.tblListing.register(UINib(nibName: "DocumentsTableViewCell", bundle: nil) , forCellReuseIdentifier: "DocumentsTableViewCell")
        self.tblListing.register(UINib(nibName: "OwnerTableViewCell", bundle: nil) , forCellReuseIdentifier: "OwnerTableViewCell")
        self.tblListing.register(UINib(nibName: "OtherUserTableViewCell", bundle: nil) , forCellReuseIdentifier: "OtherUserTableViewCell")
        self.tblListing.register(UINib(nibName: "TaskListTableViewCell", bundle: nil) , forCellReuseIdentifier: "TaskListTableViewCell")
        self.tblListing.register(UINib(nibName: "LabourPaymentTableViewCell", bundle: nil) , forCellReuseIdentifier: "LabourPaymentTableViewCell")
        self.tblListing.register(UINib(nibName: "ExpensesInfoTableViewCell", bundle: nil) , forCellReuseIdentifier: "ExpensesInfoTableViewCell")
        self.tblListing.register(UINib(nibName: "EarningTableViewCell", bundle: nil) , forCellReuseIdentifier: "EarningTableViewCell")
        self.tblListing.register(UINib(nibName: "FixPayTableViewCell", bundle: nil) , forCellReuseIdentifier: "FixPayTableViewCell")
        self.tblListing.register(UINib(nibName: "BlendedRateTableViewCell", bundle: nil) , forCellReuseIdentifier: "BlendedRateTableViewCell")
        self.tblListing.register(UINib(nibName: "TotalPaymentTableViewCell", bundle: nil) , forCellReuseIdentifier: "TotalPaymentTableViewCell")
        
        self.tblListing.separatorStyle = .none
     
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabsCollectionView.register(UINib(nibName: "TabOrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TabOrderCollectionViewCell")
//        if let flowLayout = tabsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
//        }
       
        getWorkList()
    }
 
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
       
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if self.tabsTag == 1
            {
                self.popup.frame.origin.y = self.popup.frame.origin.y - 50
                self.popup.show()
            }
            else if self.tabsTag == 4
            {
                self.popup.frame.origin.y = self.popup.frame.origin.y - 105
                self.popup.show()
            }
            else
            {
              cnstViewChatBottom.constant = keyboardHeight - viewChat.frame.height + 40
            }
        }
    }
    @objc
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if self.tabsTag == 1
            {
              self.popup.frame.origin.y = self.view.center.y
              self.popup.show(atCenter: self.view.center, in: self.view)
            }
            else
            {
                 cnstViewChatBottom.constant = 0
            }
        }
    }
    
    func getWorkList()
    {
        let parameters = ["id": self.workOrderId] as! [String:AnyObject]
        WebAPI().callJSONWebApi(API.workOrderDetails, withHTTPMethod: .post, forPostParameters: parameters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
           // print(serviceResponse)
            self.chatDetails = serviceResponse["data"] as! [String : Any]
            self.getWorkListData = self.chatDetails["workOrderData"] as! [String:Any]
           
            let cap = ((self.getWorkListData)["status_name"] as! String)
            let finalString = cap.uppercased()
          
            self.ExpensesList = (self.getWorkListData["tech_expenses"] as! [AnyObject])
            self.documentList = (self.getWorkListData["work_oder_document"] as! [AnyObject])
            
            DispatchQueue.main.async {
                self.lblWorkOrderId.text = "( ID: \(((self.getWorkListData)["work_order_number"] as? String)!) )"
                self.lblOrderView.setTitle(" \(finalString) ", for: .normal)
                self.tblListing.reloadData()
                self.tabsCollectionView.delegate = self
                self.tabsCollectionView.dataSource = self
                self.tabsCollectionView.reloadData()
            }
        })
    }
    
    func getChatHistoryManager()
    {
        self.socketId = ((((self.getWorkListData)["manager"]) as! [String:Any])["socket_id"] as! String)
        let parameter = ["with_users_id": self.socketId,"work_order_id":workOrderId] as [String:AnyObject]
        WebAPI.shared.callJSONWebApiWithoutLoader(.getChatHistory, withHTTPMethod: .post, forPostParameters: parameter, shouldIncludeAuthorizationHeader: true) { (serviceResponse) in
            print(serviceResponse)
            let Data = serviceResponse["data"] as! [String:AnyObject]
            self.chatHistory = Data["messages"] as! [AnyObject]
           
            self.tblListing.dataSource = self
            self.tblListing.delegate = self
            self.tblListing.reloadData()
          
            SocketIOManager.sharedInstance.socketIOManagerDelegate = self
            guard self.chatHistory.count > 0 else {
                return
            }
            self.tblListing.scrollToRow(at: IndexPath(row: self.chatHistory.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
    func getChatHistory()
    {
        let chatDetail = self.chatDetails["chatWith"] as! [String:Any]
      //  print(String(describing: chatDetail["socket_id"]!))
        self.socketId = chatDetail["socket_id"] as! String
        let parameter = ["with_users_id": self.socketId,"work_order_id":workOrderId] as [String:AnyObject]
        WebAPI.shared.callJSONWebApiWithoutLoader(.getChatHistory, withHTTPMethod: .post, forPostParameters: parameter, shouldIncludeAuthorizationHeader: true) { (serviceResponse) in
            print(serviceResponse)
            let Data = serviceResponse["data"] as! [String:AnyObject]
            self.chatHistory = Data["messages"] as! [AnyObject]
            
             self.tblListing.dataSource = self
             self.tblListing.delegate = self
             self.tblListing.reloadData()
            SocketIOManager.sharedInstance.socketIOManagerDelegate = self
            guard self.chatHistory.count > 0 else {
                return
            }
            // DispatchQueue.main.async {
            self.tblListing.scrollToRow(at: IndexPath(row: self.chatHistory.count - 1, section: 0), at: .bottom, animated: false)
         //   }
        }
    }

    @IBAction func btn_Back(_ sender: UIBarButtonItem) {
       self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btn_CameraAction(_ sender: UIButton) {
    }
    
    @IBAction func btn_SendMessageAction(_ sender: UIButton) {
        self.view.endEditing(true)
        guard !txtSendMsg.text!.isEmpty else {
            return
        }
        let param = ["message": txtSendMsg.text!] as [String:Any]
        SocketIOManager.sharedInstance.sendDataToEvent(.message, data: param)
        let parameter = ["to_id" : self.sendMessageId,
                         "work_order_id" : self.workOrderId,
                         "message": txtSendMsg.text!] as [String:AnyObject]
        
        WebAPI().callJSONWebApi(API.sendMessageChat, withHTTPMethod: .post, forPostParameters: parameter, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
        })
        
        txtSendMsg.text = nil
    }
    
}

extension WorkOrderDetailsViewController : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tabs.count
    }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
     {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabOrderCollectionViewCell", for: indexPath) as! TabOrderCollectionViewCell
        cell.lblTabName.text = self.tabs[indexPath.row]
        if self.tabsTag == 1 && indexPath.row == 0
        {
             cell.swipeView.isHidden = false
        }
        else if self.tabsTag == 2 && indexPath.row == 1
        {
            cell.swipeView.isHidden = false
            let chatDetail = self.chatDetails["chatWith"] as! [String:Any]
         
              if (self.socketId != "") && (!(chatDetail["socket_id"] is NSNull)) && ((chatDetail["socket_id"] as! String) == self.socketId)
            {
                    getChatHistory()
                    self.cnstViewChatBottom.constant = 0
            }
                else
            {
                getChatHistoryManager()
                self.cnstViewChatBottom.constant = 0
            }
        }
        else if self.tabsTag == 3 && indexPath.row == 2
        {
            cell.swipeView.isHidden = false
        }
        else if self.tabsTag == 4 && indexPath.row == 3
        {
            cell.swipeView.isHidden = false
        }
        else
        {
            cell.swipeView.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TabOrderCollectionViewCell
       self.view.endEditing(true)
        if cell.swipeView.isHidden == true
        {
            cell.swipeView.isHidden = false
        }
        else
        {
            cell.swipeView.isHidden = true
        }
        if indexPath.row == 0
        {
            self.tabsTag = 1
            self.cnstViewChatBottom.constant = -45
        }
        if indexPath.row == 1
        {
            self.tabsTag = 2
            self.cnstViewChatBottom.constant = 0
               getChatHistory()
        }
        if indexPath.row == 2
        {
            self.tabsTag = 3
            self.cnstViewChatBottom.constant = -45
         //    self.viewChat.isHidden = true
        }
        if indexPath.row == 3
        {
            self.tabsTag = 4
            self.cnstViewChatBottom.constant = -45
         //    self.viewChat.isHidden = true
        }
        self.tabsCollectionView.reloadData()
        self.tblListing.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      //  return CGSize(width: self.tabsCollectionView.frame.width/2, height: self.tabsCollectionView.frame.height)
        if indexPath.row == 0
        {
            return CGSize(width: 150, height: self.tabsCollectionView.frame.height)
        }
        else if indexPath.row == 1
        {
            return CGSize(width: 100, height: self.tabsCollectionView.frame.height)
        }
        else if indexPath.row == 2
        {
            return CGSize(width: 100, height: self.tabsCollectionView.frame.height)
        }
        else
        {
            return CGSize(width: 100, height: self.tabsCollectionView.frame.height)
        }
     
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
        else if self.tabsTag == 3
        {
            return 1
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
             return !isTyping ? self.chatHistory.count : self.chatHistory.count + 1
         }
            else if self.tabsTag == 3
         {
              return (self.getWorkListData["work_order_tasks"] as! [AnyObject]).count
         }
        else
         {
            return self.getWorkListData.count > 0 ? 1 : 0
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
            cell.lblManagerName.text = ((((self.getWorkListData)["manager"]) as! [String:Any])["first_name"] as? String)!+" "+((((self.getWorkListData)["manager"]) as! [String:Any])["last_name"] as? String)!
            let technicianProcess = ((self.getWorkListData)["technician_process"] as! [String:Any])
            let skillsArray = (self.getWorkListData["workSkill"] as? [String])!
            if skillsArray.count != 0
            {
                for i in 0...(skillsArray.count)-1
                {
                    if skillsArray.count-1 == i
                    {
                        cell.lblSkills.text! = ""
                        cell.lblSkills.text!.append("\(String(describing: skillsArray[i]))")
                    }
                    else
                    {
                        cell.lblSkills.text! = ""
                        cell.lblSkills.text!.append("\(String(describing: skillsArray[i])) ,")
                    }
                }
            }
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
            self.sendMessageId = (information["socket_id"] as? String)!
            cell.lblName.text = ((information)["first_name"] as? String)!+" "+((information)["last_name"] as? String)!
            cell.lblEmail.text = (((self.getWorkListData)["created_data"]) as! [String:Any])["email"] as? String
            cell.btnRating.addTarget(self, action: #selector(RatingAction(_ :)), for: .touchUpInside)
            if (!(self.chatDetails["avg_rating"] is NSNull))
            {
            if let n = NumberFormatter().number(from: String(self.chatDetails["avg_rating"] as! Int)) {
                let f = CGFloat(truncating: n)
                cell.viewRating.value = f
                cell.viewRating.filledStarImage = #imageLiteral(resourceName: "img_OrangeStar")
                cell.viewRating.halfStarImage = #imageLiteral(resourceName: "img_HalfStarOrng")
            }
            }
            cell.btnCustomerDetails.addTarget(self, action: #selector(self.CustomerRatingDetail(_ :)), for: .touchUpInside)
            cell.btnChat.addTarget(self, action: #selector(self.btnChatView(_ :)), for: .touchUpInside)
            if (((self.getWorkListData)["created_by"]) as? String) !=  (((self.getWorkListData)["manager_id"]) as? String)
            {
                cell.btnChatWithManager.isHidden = false
                cell.btnChatWithManager.addTarget(self, action: #selector(self.btnChatViewManager(_ :)), for: .touchUpInside)
            }
            else
            {
                cell.btnChatWithManager.isHidden = true
            }
            if ((((self.getWorkListData)["created_data"]) as! [String:Any])["userpic"] is NSNull)
            {
                cell.imgProfile.image = UIImage(named: "img_EditProfilePic")
            }
            else
            {
                
                let mediaFile = ((((self.getWorkListData)["created_data"]) as! [String:Any])["userpic"] as? String)!
                var afterEqualsTo = String()
                if let index = (mediaFile.range(of: ",")?.upperBound)
                {
                    afterEqualsTo = String(mediaFile.suffix(from: index))
                    print(afterEqualsTo)
                }
                
               
                let imageData = String(afterEqualsTo).data(using: String.Encoding.utf8)
                var profileImage = Data()
                if let decodedData = NSData(base64Encoded: imageData!, options: .ignoreUnknownCharacters) {
                     profileImage = decodedData as Data
                }
                if profileImage != nil
                {
                    DispatchQueue.global(qos: .background).async {
                        DispatchQueue.main.async {
                            cell.imgProfile.image = UIImage(data: profileImage)
                        }
                    }
                }
                else
                {
                    DispatchQueue.global(qos: .background).async {
                        DispatchQueue.main.async {
                            cell.imgProfile.image = UIImage(named: "img_EditProfilePic")
                        }
                    }

                }
            }
            return cell
        }
        else if indexPath.section == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOrderInformationTableViewCell", for: indexPath) as! WorkOrderInformationTableViewCell
            do {
               let attributedString = try? NSAttributedString(data: ((self.getWorkListData)["work_order_description"] as! String).data(using: .unicode) ?? Data(), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
              
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
            if !((self.getWorkListData)["per_hour_max_hours"] is NSNull)
            {
               cell.lblMaxRate.text = String((self.getWorkListData)["per_hour_max_hours"] as! Int)
            }
            else
            {
                 cell.lblMaxRate.text = "-"
            }
            if !((self.getWorkListData)["per_hour_rate"] is NSNull)
            {
              cell.lblHourlyRate.text = ((self.getWorkListData)["per_hour_rate"] as! String)
            }
            else
            {
                cell.lblHourlyRate.text = "-"
            }
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentsTableViewCell", for: indexPath) as! DocumentsTableViewCell
            cell.lblDocumentName.text = ((((self.getWorkListData)["document_name"]) as! [AnyObject])[indexPath.row] as! String)
            cell.imgDocument.tag = indexPath.row
            cell.imgDocument.addTarget(self, action: #selector(self.getDocument(_:)), for: .touchUpInside)
            return cell
        }
    }
        else if self.tabsTag == 2
       {
        if (UserDefaults.standard.object(forKey: "SocketId") as? String)! == (chatHistory[indexPath.row]["from_id"] as? String)!
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerTableViewCell", for: indexPath) as! OwnerTableViewCell
            cell.lblText.text = (chatHistory[indexPath.row]["msg_string"] as? String)!
             self.sendMessageId = (chatHistory[indexPath.row]["to_id"] as? String)!
            cell.lblTime.text = UTCToLocal(date: ((self.chatHistory[indexPath.row])["created_at"] as! String))
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherUserTableViewCell", for: indexPath) as! OtherUserTableViewCell
          //   cell.lblText.text = self.conversation[indexPath.row]
            cell.lblText.text = (chatHistory[indexPath.row]["msg_string"] as? String)!
            cell.lblTime.text = UTCToLocal(date: ((self.chatHistory[indexPath.row])["created_at"] as! String))
     //       self.sendMessageId = (chatHistory[indexPath.row]["to_id"] as? String)!
            return cell
        }
       }
       else if self.tabsTag == 4
       {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabourPaymentTableViewCell", for: indexPath) as! LabourPaymentTableViewCell
            cell.lblLabourAmount.text = "$ \(String(describing: self.chatDetails["labour_amount"] as! Double))"
            cell.lblTotalExpenses.text = "$ \((self.chatDetails)["totalTechnicianExpenses"] as! String)"
            cell.lblTotalWOrkingHrs.text = "\((self.chatDetails)["total_hours"] as! Double) hrs"
            cell.btnAddExpenses.addTarget(self, action: #selector(btn_AddExpenses(_ :)), for: .touchUpInside)
            return cell
        }
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpensesInfoTableViewCell", for: indexPath) as! ExpensesInfoTableViewCell
            cell.lblType.text = ((self.ExpensesList[indexPath.row])["expense_type"] as! String)
            cell.lblAmount.text = "$ \((self.ExpensesList[indexPath.row])["expense_amount"] as! String)"
            cell.lblTotalAmount.text = "$ \((self.ExpensesList[indexPath.row])["tech_total_expenses"] as! String)"
            cell.lblDescription.text = ((self.ExpensesList[indexPath.row])["expense_description"] as! String)
            if (((self.ExpensesList[indexPath.row])["status"] as? Int)! == -1)
            {
                cell.lblStatus.text = " Rejected "
            }
            else if(((self.ExpensesList[indexPath.row])["status"] as? Int) == 1)
            {
                cell.lblStatus.text = " Approved "
            }
            else
            {
            cell.lblStatus.text = " Pending Approval "
            }
            return cell
        }
        else if indexPath.section == 2
        {
            if ((self.getWorkListData)["payment_rate_type"] as? Int) == 2
            {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EarningTableViewCell", for: indexPath) as! EarningTableViewCell
            cell.lblPerHraRate.text =  "\((self.getWorkListData)["per_hour_rate"] as? String ?? "")"
            if (!((self.getWorkListData)["per_hour_max_hours"] is NSNull))
            {
              cell.lblMaxRate.text =  "\((self.getWorkListData)["per_hour_max_hours"] as! Int)"
            }
            if (!((self.chatDetails)["labour_amount"] is NSNull))
            {
             cell.lblAmount.text = "$ \(String(describing: (self.chatDetails)["labour_amount"] as! Double))"
            }
            cell.lblTotalEarning.text = "$ \(String(describing: (self.chatDetails)["labour_amount"] as! Double))"
            return cell
            }
            else if ((self.getWorkListData)["payment_rate_type"] as? Int) == 1
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FixPayTableViewCell", for: indexPath) as! FixPayTableViewCell
                if (!((self.getWorkListData)["fixed_pay_amount"] is NSNull))
                {
                   cell.lblFixAmount.text = ((self.getWorkListData)["fixed_pay_amount"] as? String)!
                }
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BlendedRateTableViewCell", for: indexPath) as! BlendedRateTableViewCell
                cell.lblFirstPayableAmt.text = (((self.chatDetails)["blender"] as! [String:Any])["amountPayable1"] as? String)!
                cell.lblSecndAmtPayable.text = (((self.chatDetails)["blender"] as! [String:Any])["amountPayable2"] as? String)!
                cell.lblFirstMaxHours.text = (((self.chatDetails)["blender"] as! [String:Any])["maxHours1"] as? String)!
                cell.lblsecndMaxhrs.text = (((self.chatDetails)["blender"] as! [String:Any])["maxHours2"] as? String)!
                cell.lblFirstClockedHrs.text = (((self.chatDetails)["blender"] as! [String:Any])["clockedHours1"] as? String)!
                cell.lblScndClocedHrs.text = String(((self.chatDetails)["blender"] as! [String:Any])["clockedHours2"] as! Double)
                cell.lblFirstAmtEarnd.text = String(((self.chatDetails)["blender"] as! [String:Any])["amountEarned1"] as! Double)
                cell.lblScndAmtEarned.text = String(((self.chatDetails)["blender"] as! [String:Any])["amountEarned2"] as! Double)
                cell.lblTotalEarning.text = "$ \((self.chatDetails)["labour_amount"] as! Double)"
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalPaymentTableViewCell", for: indexPath) as! TotalPaymentTableViewCell
            cell.lblTotalPayment.text = "$ \((self.chatDetails)["totalTechnicianPayment"] as! String)"
            if ((self.chatDetails)["fee"] as? String) != ""
            {
                cell.lblFees.text = "$ \(String((self.chatDetails)["fee"] as! Double))"
            }
            cell.lblTechnicianpayment.text = "$ \((self.chatDetails)["technicianPayment"] as! String)"
            return cell
        }
       }
       else
       {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListTableViewCell", for: indexPath) as! TaskListTableViewCell
        cell.lblTask.text = (((self.getWorkListData["work_order_tasks"] as! [AnyObject])[indexPath.row])["task_name"] as! String)
        cell.btnCompleteTask.tag = indexPath.row
        if ((self.getWorkListData)["status_name"] as! String) == "paid"
        {
            cell.btnCompleteTask.isHidden = true
        }
        else
        {
            cell.btnCompleteTask.isHidden = false
           cell.btnCompleteTask.addTarget(self, action: #selector(btn_CompletedtaskList(_ :)), for: .touchUpInside)
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
         let headerViewArray = Bundle.main.loadNibNamed("ChatUserView", owner: self, options: nil)?[0] as! UIView
       if self.custManager == 1
        {
            let information = self.chatDetails["chatWith"] as! [String:Any]
            (headerViewArray.viewWithTag(2) as! UILabel).text = ((information)["first_name"] as? String)!+" "+((information)["last_name"] as? String)!
        }
        else
       {
           (headerViewArray.viewWithTag(2) as! UILabel).text = ((((self.getWorkListData)["manager"]) as! [String:Any])["first_name"] as? String)!+" "+((((self.getWorkListData)["manager"]) as! [String:Any])["last_name"] as? String)!
        }
        (headerViewArray.viewWithTag(1) as! UIImageView).layer.cornerRadius =  (headerViewArray.viewWithTag(1) as! UIImageView).frame.size.height/2
        (headerViewArray.viewWithTag(1) as! UIImageView).layer.masksToBounds = true
        (headerViewArray.viewWithTag(1) as! UIImageView).layoutIfNeeded()
        if ((((self.getWorkListData)["manager"]) as! [String:Any])["pic"] is NSNull)
        {
            (headerViewArray.viewWithTag(1) as! UIImageView).image = UIImage(named: "img_EditProfilePic")
        }
        else
        {
            let mediaFile = (((self.getWorkListData)["manager"]) as! [String:Any])["pic"] as! String
            var afterEqualsTo = String()
            if let index = (mediaFile.range(of: ",")?.upperBound)
            {
                afterEqualsTo = String(mediaFile.suffix(from: index))
               // print(afterEqualsTo)
            }
            
            let imageData = String(afterEqualsTo).data(using: String.Encoding.utf8)
            var profileImage = Data()
            if let decodedData = NSData(base64Encoded: imageData!, options: .ignoreUnknownCharacters) {
             //   print(decodedData)
                profileImage = decodedData as Data
            }
            if profileImage != nil
            {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        (headerViewArray.viewWithTag(1) as! UIImageView).image = UIImage(data: profileImage)
                    }
                }
            }
            else
            {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        (headerViewArray.viewWithTag(1) as! UIImageView).image = UIImage(named: "img_EditProfilePic")
                    }
                }
                
            }
        }
       //(headerViewArray.viewWithTag(1) as! UIImageView).image = UIImage(named : "img_CheckReminder")
        return headerViewArray
    }
    else if self.tabsTag == 3
    {
        let headerViewArray = Bundle.main.loadNibNamed("CheckInView", owner: self, options: nil)?[0] as! UIView
        self.checkInView = headerViewArray
        (headerViewArray.viewWithTag(4) as! UIButton).addTarget(self, action: #selector(self.DatePickerToDateIn(_:)), for: .touchUpInside)
        (headerViewArray.viewWithTag(6) as! UIButton).addTarget(self, action: #selector(self.self.DatePickerToTimeIn(_:)), for: .touchUpInside)
        (headerViewArray.viewWithTag(2) as! UIButton).addTarget(self, action: #selector(self.UpdateCheckIn(_:)), for: .touchUpInside)
        (headerViewArray.viewWithTag(9) as! UIButton).layer.cornerRadius = 3
        (headerViewArray.viewWithTag(9) as! UIButton).layer.masksToBounds = true
        (headerViewArray.viewWithTag(9) as! UIButton).addTarget(self, action: #selector(self.startUpdatingLocationAfterCheckin(_:)), for: .touchUpInside)
        let information = self.getWorkListData["checkin_checkout"] as! [String:Any]
        if ((information)["checkin_date"] as? String) != nil
        {
           (headerViewArray.viewWithTag(3) as! UILabel).text = ((information)["checkin_date"] as? String)!
           (headerViewArray.viewWithTag(1) as! UIImageView).image = UIImage(named : "img_CheckReminder")
        }
        else
        {
            (headerViewArray.viewWithTag(1) as! UIImageView).image = UIImage(named : "img_UnCheckReminder")
        }
        if ((information)["checkin_time"] as? String) != nil
        {
            (headerViewArray.viewWithTag(5) as! UILabel).text = ((information)["checkin_time"] as? String)!
        }
        (headerViewArray.viewWithTag(2) as! UIButton).layer.cornerRadius = 3
        (headerViewArray.viewWithTag(2) as! UIButton).layer.masksToBounds = true
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
            if self.ExpensesList.count != 0
            {
             (headerViewArray.viewWithTag(10) as! UILabel).text = "Expenses"
            }
            else
            {
                (headerViewArray.viewWithTag(10) as! UILabel).text = "No Expenses Added"
            }
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
            (headerViewArray.viewWithTag(2) as! UILabel).text = "$ \((self.chatDetails)["total_expenses"] as! Double)"
            (headerViewArray.viewWithTag(3) as! UILabel).text = "$ \(String((self.chatDetails)["total_expenses_excess"] as! Double))"
            (headerViewArray.viewWithTag(4) as! UILabel).text = "$ \((self.chatDetails)["totalTechnicianExpenses"] as! String)"
            return headerViewArray
        }
          else  if self.tabsTag == 3
        {
            let headerViewArray = Bundle.main.loadNibNamed("CheckOutView", owner: self, options: nil)?[0] as! UIView
            self.checkOutView = headerViewArray
            let information = self.getWorkListData["checkin_checkout"] as! [String:Any]
            if ((information)["checkout_date"] as? String) != nil
            {
                (headerViewArray.viewWithTag(3) as! UILabel).text = ((information)["checkout_date"] as? String)!
                (headerViewArray.viewWithTag(1) as! UIImageView).image = UIImage(named : "img_CheckReminder")
            }
            else
            {
                (headerViewArray.viewWithTag(1) as! UIImageView).image = UIImage(named : "img_UnCheckReminder")
            }
            if ((information)["checkout_time"] as? String) != nil
            {
                (headerViewArray.viewWithTag(5) as! UILabel).text = ((information)["checkout_time"] as? String)!
            }
            (headerViewArray.viewWithTag(2) as! UIButton).layer.cornerRadius = 3
            (headerViewArray.viewWithTag(2) as! UIButton).layer.masksToBounds = true
             (headerViewArray.viewWithTag(2) as! UIButton).addTarget(self, action: #selector(self.UpdateCheckOut(_:)), for: .touchUpInside)
            (headerViewArray.viewWithTag(4) as! UIButton).addTarget(self, action: #selector(self.DatePickerToDate(_:)), for: .touchUpInside)
            (headerViewArray.viewWithTag(6) as! UIButton).addTarget(self, action: #selector(self.DatePickerToTime(_:)), for: .touchUpInside)
            (headerViewArray.viewWithTag(7) as! UIView).layer.borderWidth = 1
            (headerViewArray.viewWithTag(7) as! UIView).layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
            (headerViewArray.viewWithTag(8) as! UIView).layer.borderWidth = 1
            (headerViewArray.viewWithTag(8) as! UIView).layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
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
            else if self.tabsTag == 3
         {
            let information = self.getWorkListData["checkin_checkout"] as! [String:Any]
            if ((information)["checkin_date"] as? String) != nil
            {
               return 245.0
            }
            else
            {
                return 230.0
            }
         }
         else if self.tabsTag == 2
         {
            return 70.0
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
        else if self.tabsTag == 3
        {
                return 158.0
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
            if self.tabsTag == 3
            {
            if (self.getWorkListData["work_order_tasks"] as! [AnyObject]).count == 0
            {
                return 0
            }
                else
            {
                return UITableViewAutomaticDimension
            }
            }
            else
            {
               return UITableViewAutomaticDimension
            }
        }
        else
        {
            return 40
        }
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
        (self.checkOutView.viewWithTag(3) as! UILabel).text! = dateFormatter.string(from: calenderPickerView.date)
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
         (self.checkOutView.viewWithTag(5) as! UILabel).text! = dateFormatter.string(from: calenderPickerView.date)
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        (self.checkInView.viewWithTag(3) as! UILabel).text! = dateFormatter.string(from: calenderPickerView.date)
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        (self.checkInView.viewWithTag(5) as! UILabel).text! = dateFormatter.string(from: calenderPickerView.date)
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

        if (self.checkInView.viewWithTag(3) as! UILabel).text! != "Select Date" && (self.checkInView.viewWithTag(5) as! UILabel).text! != "Select Time"
        {
            (self.checkInView.viewWithTag(1) as! UIImageView).image = UIImage(named : "img_CheckReminder")
            (self.checkInView.viewWithTag(7))!.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
            (self.checkInView.viewWithTag(8))!.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
            let parameters = ["work_order_id": self.workOrderId ,"checkin_date": (self.checkInView.viewWithTag(3) as! UILabel).text!,"checkin_time":(self.checkInView.viewWithTag(5) as! UILabel).text! ] as [String:AnyObject]
           
        WebAPI.shared.callJSONWebApi(API.checkIn, withHTTPMethod: .post, forPostParameters: parameters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            if let message = serviceResponse["msg"] as? String
            {
                AListAlertController.shared.presentAlertController(message: message)
                {
                    self.tblListing.reloadData()
                   // self.tblListing.endUpdates()
                }
            }
        })
        }
        else
        {
            if (self.checkInView.viewWithTag(3) as! UILabel).text! == "Select Date"
            {
            let viewShaker = AFViewShaker(view: (self.checkInView.viewWithTag(7))!)
                (self.checkInView.viewWithTag(7))!.layer.borderColor = UIColor.red.cgColor
            viewShaker?.shake()
            return
            }
            else if (self.checkInView.viewWithTag(5) as! UILabel).text! == "Select Time"
            {
                let viewShaker = AFViewShaker(view: (self.checkInView.viewWithTag(8))!)
                (self.checkInView.viewWithTag(8))!.layer.borderColor = UIColor.red.cgColor
                viewShaker?.shake()
            }
            else
            {
                 (self.checkInView.viewWithTag(7))!.layer.borderColor = UIColor.red.cgColor
                 (self.checkInView.viewWithTag(8))!.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    @objc func startUpdatingLocationAfterCheckin(_ sender: UIButton)
    {
      
        if (self.checkInView.viewWithTag(9) as! UIButton).titleLabel?.text == "Start Location Tracking"
        {
             (self.checkInView.viewWithTag(9) as! UIButton).setTitle("Pause Location Tracking", for: .normal)
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
             (self.checkInView.viewWithTag(9) as! UIButton).setTitle("Start Location Tracking", for: .normal)
             self.StopSendingLocation()
        }
    }
    
    @objc func UpdateCheckOut(_ sender: UIButton)
    {
//        let cell_indexPath = NSIndexPath(row: 0, section: 0)
//        let tableViewCell = self.tblListing.cellForRow(at: cell_indexPath as IndexPath) as! WorkspaceTableViewCell
        (self.checkOutView.viewWithTag(1) as! UIImageView).image = UIImage(named : "img_CheckReminder")
      if (self.checkOutView.viewWithTag(3) as! UILabel).text! != "Select Date" && (self.checkOutView.viewWithTag(5) as! UILabel).text! != "Select Time"
        {
            (self.checkOutView.viewWithTag(1) as! UIImageView).image = UIImage(named : "img_CheckReminder")
            (self.checkOutView.viewWithTag(7))!.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
            (self.checkOutView.viewWithTag(8))!.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        let parameters = ["work_order_id": self.workOrderId ,"checkout_date": (self.checkOutView.viewWithTag(3) as! UILabel).text!,"checkout_time":(self.checkOutView.viewWithTag(5) as! UILabel).text!] as [String:AnyObject]
        WebAPI().callJSONWebApi(API.checkOut, withHTTPMethod: .post, forPostParameters: parameters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            if let message = serviceResponse["msg"] as? String
            {
                 AListAlertController.shared.presentAlertController(message: message)
                 {
                    self.tblListing.reloadData()
                   // self.tblListing.endUpdates()
                    self.StopSendingLocation()
                 }
            }
        })
        }
        else
        {
            if (self.checkOutView.viewWithTag(3) as! UILabel).text! == "Select Date"
            {
                let viewShaker = AFViewShaker(view: (self.checkOutView.viewWithTag(7))!)
                (self.checkOutView.viewWithTag(7))!.layer.borderColor = UIColor.red.cgColor
                viewShaker?.shake()
                return
            }
            else if (self.checkOutView.viewWithTag(5) as! UILabel).text! == "Select Time"
            {
                let viewShaker = AFViewShaker(view: (self.checkOutView.viewWithTag(8))!)
                (self.checkOutView.viewWithTag(8))!.layer.borderColor = UIColor.red.cgColor
                viewShaker?.shake()
            }
            else
            {
                (self.checkOutView.viewWithTag(7))!.layer.borderColor = UIColor.red.cgColor
                (self.checkOutView.viewWithTag(8))!.layer.borderColor = UIColor.red.cgColor
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
    
    @objc func btn_CompletedtaskList(_ sender: UIButton)
    {
        let parameters = ["work_order_id": self.workOrderId , "work_order_task_id": (((self.getWorkListData["work_order_tasks"] as! [AnyObject])[sender.tag])["work_order_task_id"] as! Int)] as [String:AnyObject]
        WebAPI().callJSONWebApi(API.completedTaskList, withHTTPMethod: .post, forPostParameters: parameters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            if let message = serviceResponse["msg"] as? String
            {
                AListAlertController.shared.presentAlertController(message: message, completionHandler: nil)
            }
        })
    }
    
    
     @objc func getDocument(_ sender: UIButton) {
        let downloadUrl = "https://app.ihiretech.hplbusiness.com/api/technician/work_order_document/\(((self.documentList[sender.tag])["work_order_document_id"] as! Int))"
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
        destination.url = URL(string: downloadUrl)!
        self.navigationController?.pushViewController(destination, animated: true)

    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let data = try! Data(contentsOf: location)
        print(data)
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.downloadsDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first!
        path.append("download.html")
        FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
        print(FileManager.default.contents(atPath: path)!)

    }
    
    @objc func CustomerRatingDetail(_ sender: UIButton)
    {
        let destination = RatingTableViewController(style: .plain)
        destination.customerId = Int((self.getWorkListData)["customer_id"] as! String)!
        destination.workOrderId = self.workOrderId
        let nav = UINavigationController(rootViewController: destination)
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.present(nav, animated: false, completion: nil)
     //   self.navigationController?.pushViewController(nav, animated: false)
    }
    
    @objc func btnChatView(_ sender: UIButton)
    {
        self.tabsTag = 2
        self.custManager = 1
         self.tabsCollectionView.reloadData()
        self.cnstViewChatBottom.constant = 0
        getChatHistory()
       
    }
   
    @objc func btnChatViewManager(_ sender: UIButton)
    {
        self.tabsTag = 2
        self.custManager = 2
        self.tabsCollectionView.reloadData()
        self.cnstViewChatBottom.constant = 0
        getChatHistoryManager()
    }
    
}

extension WorkOrderDetailsViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
       //     self.startUpdatingLocation()
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

extension WorkOrderDetailsViewController: SocketIOManagerDelegate {
    func usersTyping(_ data: [String : Any]) {
//        isTyping = true
//        timer?.invalidate()
//        if #available(iOS 10.0, *) {
//            timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (_) in
//          //      self.isTyping = false
//            })
//        } else {
//            // Fallback on earlier versions
//        }
    }
    
    func messageReceived(_ data: String) {
        print(data)
        let chatMessage = convertToDictionary(text: data)! as [String:AnyObject]
        print(chatMessage)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var orderId = String()
        if chatMessage["work_order_id"] is String
        {
            orderId = chatMessage["work_order_id"] as! String
        }
        else
        {
            orderId = String(describing: chatMessage["work_order_id"] as! Int)
        }
        if orderId == String(self.workOrderId)
        {
       let chat = [
            "msg_string": chatMessage["message"] as! String,
            "from_id" : chatMessage["msgFrom"] as! String,
            "to_id" : chatMessage["msgTo"] as! String,
            "created_at" : chatMessage["dateTime"] as! String
        ] as [String : Any]
        self.chatHistory.append(chat as AnyObject as AnyObject)
        print(self.chatHistory)
          let indexPaths = self.tblListing.indexPathsForVisibleRows?.sorted(by: { $0.row < $1.row })
          
        self.tblListing.reloadData()
        guard let lastIndexPath = indexPaths?.last  else {
            return
        }
        guard lastIndexPath.row == (isTyping ? chatHistory.count - 1 : chatHistory.count - 2) else {
            return
        }
        self.tblListing.scrollToRow(at: IndexPath(row: lastIndexPath.row + 1, section: 0) , at: .bottom, animated: false)
        }
    }
    
    @objc func textDidChange(_ sender: UITextField) {
      //  SocketIOManager.sharedInstance.sendDataToEvent(.typing, data: [:])
        print("Typing...")
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm a"
        
        return dateFormatter.string(from: dt!)
    }
    
}


