//
//  SearchOrderDetailViewController.swift
//  iHiretech
//
//  Created by Admin on 14/01/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import KLCPopup
import HCSStarRatingView

class SearchOrderDetailViewController: UIViewController {

    @IBOutlet var viewMsgBorder: UIView!
    @IBOutlet var cnstViewChatBottom: NSLayoutConstraint!
    @IBOutlet var viewChat: UIView!
    @IBOutlet var txtSendMsg: UITextField!
    @IBOutlet var tblListing: UITableView!
    @IBOutlet var tabCollectionView: UICollectionView!
    @IBOutlet var lblOrderId: UILabel!
    @IBOutlet var lblStatus: UIButton!
    var workOrderId = Int()
    var getWorkListData = [String:Any]()
    var chatDetails = [String:Any]()
    var ExpensesList = [AnyObject]()
    var documentList = [AnyObject]()
    var tabsTag = 1
    var chatHistory = [AnyObject]()
   var socketId = String()
    var custManager = 1
    var sendMessageId = String()
    
    var timer: Timer!
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
    var tabs = ["Work Order Details","Messages"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewMsgBorder.layer.borderWidth = 1
        self.viewMsgBorder.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.viewMsgBorder.layer.cornerRadius = 3
        self.viewMsgBorder.layer.masksToBounds = true
        
        self.lblStatus.layer.cornerRadius = 3
        self.lblStatus.layer.masksToBounds = true
        
        self.tblListing.estimatedRowHeight = 140
        self.tblListing.rowHeight = UITableViewAutomaticDimension
        self.cnstViewChatBottom.constant = -35
        self.tblListing.register(UINib(nibName: "ServiceInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "ServiceInformationTableViewCell")
        self.tblListing.register(UINib(nibName: "CustomerInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "CustomerInformationTableViewCell")
        self.tblListing.register(UINib(nibName: "WorkOrderInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "WorkOrderInformationTableViewCell")
        self.tblListing.register(UINib(nibName: "ScheduleInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "ScheduleInformationTableViewCell")
        self.tblListing.register(UINib(nibName: "LocationInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "LocationInformationTableViewCell")
        self.tblListing.register(UINib(nibName: "PayRateInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "PayRateInformationTableViewCell")
       self.tblListing.register(UINib(nibName: "OwnerTableViewCell", bundle: nil) , forCellReuseIdentifier: "OwnerTableViewCell")
       self.tblListing.register(UINib(nibName: "OtherUserTableViewCell", bundle: nil) , forCellReuseIdentifier: "OtherUserTableViewCell")
        self.tblListing.register(UINib(nibName: "DocumentsTableViewCell", bundle: nil) , forCellReuseIdentifier: "DocumentsTableViewCell")
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
        self.tblListing.separatorStyle = .none
      
//        if let flowLayout = tabCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
//        }
      }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabCollectionView.register(UINib(nibName: "TabOrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TabOrderCollectionViewCell")
       
        getWorkList()
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            cnstViewChatBottom.constant = keyboardHeight - viewChat.frame.height + 40
            
        }
    }
    @objc
    func keyboardWillHide(_ notification: Notification) {
        
        cnstViewChatBottom.constant = 0
    }
    
    func getWorkList()
    {
        let parameters = ["id": self.workOrderId] as! [String:AnyObject]
        WebAPI().callJSONWebApi(API.workOrderDetails, withHTTPMethod: .post, forPostParameters: parameters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            self.chatDetails = serviceResponse["data"] as! [String : Any]
            self.getWorkListData = self.chatDetails["workOrderData"] as! [String:Any]
          //  self.lblOrderId.text = "( ID: \(((self.getWorkListData)["work_order_number"] as? String)!))"
            let cap = ((self.getWorkListData)["status_name"] as! String)
            let finalString = cap.uppercased()
            self.ExpensesList = (self.getWorkListData["tech_expenses"] as! [AnyObject])
            self.documentList = (self.getWorkListData["work_oder_document"] as! [AnyObject])
            DispatchQueue.main.async {
                self.lblOrderId.text = "( ID: \(((self.getWorkListData)["work_order_number"] as? String)!) )"
                 self.lblStatus.setTitle("  \(finalString)  ", for: .normal)
                self.tblListing.delegate = self
                self.tblListing.dataSource = self
                self.tblListing.reloadData()
                self.tabCollectionView.delegate = self
                self.tabCollectionView.dataSource = self
                self.tabCollectionView.reloadData()
            }
        })
    }
    
    func getChatHistoryManager()
    {
        self.socketId = ((((self.getWorkListData)["manager"]) as! [String:Any])["socket_id"] as! String)
        let parameter = ["with_users_id":((((self.getWorkListData)["manager"]) as! [String:Any])["socket_id"] as! String),"work_order_id":workOrderId] as [String:AnyObject]
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
        print(String(describing: chatDetail["socket_id"]!))
        self.socketId = String(describing: chatDetail["socket_id"]!)
        let parameter = ["with_users_id": self.socketId,"work_order_id":workOrderId] as [String:AnyObject]
        //chatTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
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

    
    @IBAction func btn_BackAction(_ sender: UIBarButtonItem) {
         self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_CameraAction(_ sender: UIButton) {
    }
    
    @IBAction func btn_SendMessage(_ sender: UIButton) {
         self.view.endEditing(true)
        guard !txtSendMsg.text!.isEmpty else {
            return
        }
        let param = ["message": txtSendMsg.text!] as [String:Any]
        SocketIOManager.sharedInstance.sendDataToEvent(.message, data: param)
        let parameter = ["to_id" : self.sendMessageId,
                         "work_order_id" : self.workOrderId,
                         "message": txtSendMsg.text!] as [String:AnyObject]
        
        WebAPI().callJSONWebApiWithoutLoader(API.sendMessageChat, withHTTPMethod: .post, forPostParameters: parameter, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
        })
        
        txtSendMsg.text = nil
    }
   
}

extension SearchOrderDetailViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tabs.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        else
        {
            cell.swipeView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TabOrderCollectionViewCell
        
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
             self.cnstViewChatBottom.constant = -55
            self.viewChat.isHidden = true
        }
        if indexPath.row == 1
        {
            self.tabsTag = 2
             self.cnstViewChatBottom.constant = 0
            self.viewChat.isHidden = false
            getChatHistory()
        }
        self.tabCollectionView.reloadData()
        self.tblListing.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0
        {
            return CGSize(width: 150, height: self.tabCollectionView.frame.height)
        }
        else
        {
            return CGSize(width: 100, height: self.tabCollectionView.frame.height)
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension SearchOrderDetailViewController : UITableViewDelegate , UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.tabsTag == 1
        {
            return 8
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if self.tabsTag == 1 && section == 7
        {
            return self.documentList.count
        }
      else if self.tabsTag == 2
      {
            return !isTyping ? self.chatHistory.count : self.chatHistory.count + 1
      }
        else
      {
           return self.getWorkListData.count > 0 ? 1 : 0
      }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.tabsTag == 1
        {
            if indexPath.section == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceInformationTableViewCell", for: indexPath) as! ServiceInformationTableViewCell
                cell.lblLocation.text = ((self.getWorkListData)["location_address_line_1"] as? String)!+" "+((self.getWorkListData)["location_address_line_2"] as? String)!
                cell.lblOrderId.text = ((self.getWorkListData)["work_order_number"] as? String)!
                cell.lblServiceTitle.text = (((self.getWorkListData)["work_order_title"]) as? String)!
                cell.lblClientName.text = (((self.getWorkListData)["clients"]) as! [String:Any])["client_name"] as? String
                cell.lblManagerName.text = ((((self.getWorkListData)["manager"]) as! [String:Any])["first_name"] as? String)!+" "+((((self.getWorkListData)["manager"]) as! [String:Any])["last_name"] as? String)!
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
                return cell
            }
            else if indexPath.section == 1
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerInformationTableViewCell", for: indexPath) as! CustomerInformationTableViewCell
                cell.lblContactNo.text = ((self.getWorkListData)["location_contact_phone_number"] as? String)!
                cell.lblLocation.text = ((self.getWorkListData)["location_country"] as? String)!
                let information = self.chatDetails["chatWith"] as! [String:Any]
                self.sendMessageId = (information["socket_id"] as? String)!
                cell.lblName.text = ((information)["first_name"] as? String)!+" "+((information)["last_name"] as? String)!
                cell.lblEmail.text = (((self.getWorkListData)["created_data"]) as! [String:Any])["email"] as? String
                if (!(self.chatDetails["avg_rating"] is NSNull))
                {
                cell.viewStarRating.value = (self.chatDetails["avg_rating"] as? CGFloat)!
                cell.viewStarRating.filledStarImage = #imageLiteral(resourceName: "img_OrangeStar")
                cell.viewStarRating.halfStarImage = #imageLiteral(resourceName: "img_HalfStarOrng")
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
                    //    print(afterEqualsTo)
                    }
                    let imageData = String(afterEqualsTo).data(using: String.Encoding.utf8)
                    var profileImage = Data()
                    if let decodedData = NSData(base64Encoded: imageData!, options: .ignoreUnknownCharacters) {
               //         print(decodedData)
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
                if !((self.getWorkListData)["schedule_exact_date"] is NSNull)
                {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-DD"
                    let date = dateFormatter.date(from: ((self.getWorkListData)["schedule_exact_date"] as! String))
                    dateFormatter.dateFormat = "MM-DD-YYYY"
                    cell.lblDate.text = dateFormatter.string(from: date!)
                    // cell.lblDate.text = ((self.getWorkListData)["schedule_exact_date"] as? String)!
                }
                if !((self.getWorkListData)["schedule_exact_time"] is NSNull)
                {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss"
                    let date = dateFormatter.date(from: ((self.getWorkListData)["schedule_exact_time"] as! String))
                    dateFormatter.dateFormat = "HH:mm a"
                    cell.lblTime.text = dateFormatter.string(from: date!)
                    //  cell.lblTime.text = ((self.getWorkListData)["schedule_exact_time"] as? String)!
                }
              //  cell.lblDate.text = ((self.getWorkListData)["schedule_exact_date"] as? String)!
              //  cell.lblTime.text = ((self.getWorkListData)["schedule_exact_time"] as? String)!
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
                if ((self.getWorkListData)["payment_rate_type"] as? Int) == 1
                {
                    cell.lblPaymentType.text = "Fixed"
                    cell.lblTileHourlyrate.text = "Fixed Rate"
                    cell.cnstLblMaxHoursHeight.constant = 0
                    cell.cnstValueMaxhrsheight.constant = 0
                    if !((self.getWorkListData)["fixed_pay_amount"] is NSNull)
                    {
                        cell.lblHourlyRate.text = "$ \((self.getWorkListData)["fixed_pay_amount"] as! String)"
                    }
                    else
                    {
                        cell.lblHourlyRate.text = "-"
                    }
                }
                else if ((self.getWorkListData)["payment_rate_type"] as? Int) == 2
                {
                    cell.lblPaymentType.text = "Per hour"
                    cell.lblTileHourlyrate.text = "Per hour rate"
                    cell.lblTitleMaxHrs.text = "Per hour Rate Max Hours :"
                    cell.lblTitleMaxHrs.isHidden = false
                    cell.cnstLblMaxHoursHeight.constant = 15
                    cell.cnstValueMaxhrsheight.constant = 15
                    if !((self.getWorkListData)["per_hour_max_hours"] is NSNull)
                    {
                        cell.lblMaxRate.text = "\(String((self.getWorkListData)["per_hour_max_hours"] as! Int)) hrs"
                    }
                    else
                    {
                        cell.lblMaxRate.text = "-"
                    }
                    if !((self.getWorkListData)["per_hour_rate"] is NSNull)
                    {
                        cell.lblHourlyRate.text = "$ \((self.getWorkListData)["per_hour_rate"] as! String)"
                    }
                    else
                    {
                        cell.lblHourlyRate.text = "-"
                    }
                }
                else
                {
                    cell.lblPaymentType.text = "Blended"
                    cell.lblTileHourlyrate.text = "Pay Amount :"
                    cell.lblHourlyRate.text = "$ \((self.getWorkListData)["blended_rate_amount_first"] as! String), For Hours : \((self.getWorkListData)["blended_rate_hours_first"] as! Int) Hrs"
                    cell.lblTitleMaxHrs.text = "Then Pay Amount :"
                    cell.lblMaxRate.text = "$ \((self.getWorkListData)["blended_rate_amount_second"] as! String), For Hours Upto : \((self.getWorkListData)["blended_rate_hours_second"] as! Int) Hrs"
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
       else
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
//            if (UserDefaults.standard.object(forKey: "SocketId") as? String)! == (chatHistory[indexPath.row]["from_id"] as? String)!
//            {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerTableViewCell", for: indexPath) as! OwnerTableViewCell
//                cell.lblText.text = (chatHistory[indexPath.row]["msg_string"] as? String)!
//                 self.sendMessageId = (chatHistory[indexPath.row]["to_id"] as? String)!
//                cell.lblTime.text = UTCToLocal(date: ((self.chatHistory[indexPath.row])["created_at"] as! String))
//                return cell
//            }
//            else
//            {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherUserTableViewCell", for: indexPath) as! OtherUserTableViewCell
//                cell.lblText.text = (chatHistory[indexPath.row]["msg_string"] as? String)!
//                cell.lblTime.text = UTCToLocal(date: ((self.chatHistory[indexPath.row])["created_at"] as! String))
//                //       self.sendMessageId = (chatHistory[indexPath.row]["to_id"] as? String)!
//                return cell
//            }
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
        else
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
             //       print(decodedData)
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
    
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if self.tabsTag == 2
        {
            return 70.0
        }
        else
        {
            return 47.0
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
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
    
    @objc func CustomerRatingDetail(_ sender: UIButton)
    {
        let destination = RatingTableViewController(style: .plain)
        destination.customerId = Int((self.getWorkListData)["customer_id"] as! String)!
        let nav = UINavigationController(rootViewController: destination)
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.revealViewController().setFront(nav, animated: true)
    }
    
    @objc func btnChatView(_ sender: UIButton)
    {
        self.tabsTag = 2
        self.custManager = 1
         self.cnstViewChatBottom.constant = 0
        self.tabCollectionView.reloadData()
        self.tblListing.reloadData()
        getChatHistory()
    }
    
    @objc func btnChatViewManager(_ sender: UIButton)
    {
        self.tabsTag = 2
        self.custManager = 2
        self.tabCollectionView.reloadData()
        self.cnstViewChatBottom.constant = 0
        getChatHistoryManager()
    }
    
    @objc func getDocument(_ sender: UIButton) {
        let downloadUrl = "https://dev.techadox.com/api/technician/work_order_document/\(((self.documentList[sender.tag])["work_order_document_id"] as! Int))"
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
        destination.url = URL(string: downloadUrl)!
        self.navigationController?.pushViewController(destination, animated: true)
        
    }
}

extension SearchOrderDetailViewController: SocketIOManagerDelegate {
    func usersTyping(_ data: [String : Any]) {
      
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
                //    "work_order_id" : chatMessage["work_order_id"] as! Int
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

