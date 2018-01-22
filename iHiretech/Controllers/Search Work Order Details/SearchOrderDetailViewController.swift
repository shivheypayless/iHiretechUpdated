//
//  SearchOrderDetailViewController.swift
//  iHiretech
//
//  Created by Admin on 14/01/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import KLCPopup


class SearchOrderDetailViewController: UIViewController {

    @IBOutlet var tblListing: UITableView!
    @IBOutlet var tabCollectionView: UICollectionView!
    @IBOutlet var lblOrderId: UILabel!
    @IBOutlet var lblStatus: UILabel!
    var workOrderId = Int()
    var getWorkListData = [String:Any]()
    var chatDetails = [String:Any]()
    var ExpensesList = [AnyObject]()
    var documentList = [AnyObject]()
    var tabsTag = 1
   
    var conversation = ["Hello","Hi.","How are you?","I'm doing great. What have you been upto these days?","Nothing much! Just the usual corporate work life.","Ohh I see. BTW why don't you visit us for a dinner or something with Sue and kids.","Yeah sure why not!","How does next Saturday Night sound to you.","Yeah will do, as long as Sue doesn't have any other plans for the night.","Sure, I'll even notify Aisha about it","Cool","Meet up soon.","Cya"]
    
    
    var tabs = ["Work Order Details","Messages"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblStatus.layer.cornerRadius = 3
        self.lblStatus.layer.masksToBounds = true
        
        self.tblListing.estimatedRowHeight = 140
        self.tblListing.rowHeight = UITableViewAutomaticDimension
       
        self.tblListing.register(UINib(nibName: "ServiceInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "ServiceInformationTableViewCell")
        self.tblListing.register(UINib(nibName: "CustomerInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "CustomerInformationTableViewCell")
        self.tblListing.register(UINib(nibName: "WorkOrderInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "WorkOrderInformationTableViewCell")
        self.tblListing.register(UINib(nibName: "ScheduleInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "ScheduleInformationTableViewCell")
        self.tblListing.register(UINib(nibName: "LocationInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "LocationInformationTableViewCell")
        self.tblListing.register(UINib(nibName: "PayRateInformationTableViewCell", bundle: nil) , forCellReuseIdentifier: "PayRateInformationTableViewCell")
        self.tblListing.register(UINib(nibName: "DocumentsTableViewCell", bundle: nil) , forCellReuseIdentifier: "DocumentsTableViewCell")
       
        self.tblListing.separatorStyle = .none
        self.tabCollectionView.register(UINib(nibName: "TabOrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TabOrderCollectionViewCell")
        
        if let flowLayout = tabCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
        
        self.tabCollectionView.delegate = self
        self.tabCollectionView.dataSource = self

        // Do any additional setup after loading the view.
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
            self.lblOrderId.text = "(ID: \(((self.getWorkListData)["work_order_number"] as? String)!))"
            let cap = ((self.getWorkListData)["status_name"] as! String)
            let finalString = cap.capitalized
            self.lblStatus.text = "  \(finalString)   "
            self.ExpensesList = (self.getWorkListData["tech_expenses"] as! [AnyObject])
            self.documentList = (self.getWorkListData["work_oder_document"] as! [AnyObject])
            self.tblListing.dataSource = self
            self.tblListing.delegate = self
            self.tblListing.reloadData()
        })
    }


    @IBAction func btn_NotifictionAction(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func btn_ChatAction(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func btn_BackAction(_ sender: UIBarButtonItem) {
         self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchOrderDetailViewController : UICollectionViewDelegate , UICollectionViewDataSource
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
       
        self.tabCollectionView.reloadData()
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

extension SearchOrderDetailViewController : UITableViewDelegate , UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.tabsTag == 1
        {
            return 8
        }
      else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if self.tabsTag == 1 && section == 7
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
                cell.lblManagerName.text = (((self.getWorkListData)["manager"]) as! [String:Any])["first_name"] as? String
            
                return cell
            }
            else if indexPath.section == 1
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerInformationTableViewCell", for: indexPath) as! CustomerInformationTableViewCell
                cell.lblContactNo.text = ((self.getWorkListData)["location_contact_phone_number"] as? String)!
                cell.lblLocation.text = ((self.getWorkListData)["location_country"] as? String)!
                let information = self.chatDetails["chatWith"] as! [String:Any]
                cell.lblName.text = ((information)["first_name"] as? String)!+" "+((information)["last_name"] as? String)!
                cell.lblEmail.text = (((self.getWorkListData)["created_data"]) as! [String:Any])["email"] as? String
               
                
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
       else
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
            return nil
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
        if self.tabsTag == 4 && section == 1
        {
            return 129.0
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
}

