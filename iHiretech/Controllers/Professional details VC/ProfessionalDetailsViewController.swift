//
//  ProfessionalDetailsViewController.swift
//  iHiretech
//
//  Created by Admin on 01/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import TagListView
import MobileCoreServices
import AFViewShaker

class ProfessionalDetailsViewController: UIViewController , UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate, TagListViewDelegate {

    @IBOutlet var viewUploadBackground: UIView!
    @IBOutlet var txtAreaDetailResume: UITextView!
    @IBOutlet var lblDocumentTwoname: UILabel!
    @IBOutlet var lblDocumentOneName: UILabel!
    @IBOutlet var lblResumeName: UILabel!
    @IBOutlet var cnstEquipment: NSLayoutConstraint!
    @IBOutlet var tblEquipment: UITableView!
    @IBOutlet var viewEquipment: TagListView!
    @IBOutlet var cnstCertificationHeight: NSLayoutConstraint!
    @IBOutlet var tblCertification: UITableView!
    @IBOutlet var viewCertification: TagListView!
    @IBOutlet var cnstSkillsHeight: NSLayoutConstraint!
    @IBOutlet var tblSkills: UITableView!
    @IBOutlet var viewSkillTag: TagListView!
    @IBOutlet var btnUploadDocument: UIButton!
    @IBOutlet var btnUploadResume: UIButton!
    @IBOutlet var btnChooseDoc: UIButton!
    @IBOutlet var viewUploadDocument: UIView!
    @IBOutlet var viewUploadDoc: UIView!
    @IBOutlet var viewUploadResume: UIView!
    @IBOutlet var viewTitle: EditTextView!
    @IBOutlet var viewLicenses: EditTextView!
    @IBOutlet var viewExperience: EditTextView!
    @IBOutlet var btnBackgrundUpload: UIButton!
    @IBOutlet var lblBackgrundUpload: UILabel!
    
    @IBOutlet var viewAccountNo: EditTextView!
    @IBOutlet var viewSSN: EditTextView!
    @IBOutlet var viewRoutingNumber: EditTextView!
    @IBOutlet var viewSummary: EditTextView!
    
    var getSkills = NSArray()
    var getCertificates = NSArray()
    var getEquipments = NSArray()
    var skills = String()
    var certificates = String()
    var equipments = String()
    var setSkillsArray = [String]()
    var setCertificates = [String]()
    var setEquipments = [String]()
    var resume : URL?
    var documentOne : URL?
    var documentTwo : URL?
      var documentThree : URL?
    var uploadDocTag = Int()
    var skillsId = [String]()
    var certificateId = [String]()
    var equipmentId = [String]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtAreaDetailResume.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        self.txtAreaDetailResume.layer.borderWidth = 1
        
        self.viewCertification.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        self.viewCertification.layer.borderWidth = 1
        
        self.viewUploadBackground.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        self.viewUploadBackground.layer.borderWidth = 1
        
        self.viewSkillTag.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        self.viewSkillTag.layer.borderWidth = 1
        
        self.viewEquipment.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        self.viewEquipment.layer.borderWidth = 1
        
        self.viewUploadResume.layer.borderWidth = 1
        self.viewUploadResume.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        
        self.viewUploadDoc.layer.borderWidth = 1
        self.viewUploadDoc.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        
        self.viewUploadDocument.layer.borderWidth = 1
        self.viewUploadDocument.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        
        self.btnChooseDoc.layer.cornerRadius = 3
        self.btnChooseDoc.layer.masksToBounds = true
        
        self.btnUploadResume.layer.cornerRadius = 3
        self.btnUploadResume.layer.masksToBounds = true
        
        self.btnUploadDocument.layer.cornerRadius = 3
        self.btnUploadDocument.layer.masksToBounds = true
        
        self.btnBackgrundUpload.layer.cornerRadius = 3
         self.btnBackgrundUpload.layer.masksToBounds = true
        getProfileDetails()
        
        viewSkillTag.clipsToBounds = true
        viewCertification.clipsToBounds = true
        viewEquipment.clipsToBounds = true
        
        self.tblSkills.register(UINib(nibName: "StatesTableViewCell", bundle: nil) , forCellReuseIdentifier: "StatesTableViewCell")
        self.tblCertification.register(UINib(nibName: "StatesTableViewCell", bundle: nil) , forCellReuseIdentifier: "StatesTableViewCell")
        self.tblEquipment.register(UINib(nibName: "StatesTableViewCell", bundle: nil) , forCellReuseIdentifier: "StatesTableViewCell")
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
    
//    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void
//     {
//        print("Tag pressed: \(title), \(sender)")
//        viewSkillTag.removeTagView(tagView)
//        self.setSkillsArray.remove(at: sender.tag)
//     }
    
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void
    {
        if sender.tag == 1
        {
             viewSkillTag.removeTagView(tagView)
            self.setSkillsArray.remove(at: tagView.tag)
            self.skillsId.remove(at: tagView.tag)
        }
        else if sender.tag == 2
        {
             viewCertification.removeTagView(tagView)
             self.setCertificates.remove(at: tagView.tag)
             self.certificateId.remove(at: tagView.tag)
        }
        else if sender.tag == 3
        {
             viewEquipment.removeTagView(tagView)
             self.setEquipments.remove(at: tagView.tag)
             self.equipmentId.remove(at: tagView.tag)
        }
    }
    
    
    func accessDocuments()
    {
        let documentPickerController = UIDocumentMenuViewController(documentTypes: [kUTTypePDF as String, kUTTypeJPEG as String, kUTTypePNG as String], in: .import)
        documentPickerController.delegate = self
        present(documentPickerController, animated: true, completion: nil)
    }
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if controller.documentPickerMode == .import {
            AListAlertController.shared.presentAlertController(message: "Successfully imported \(url.lastPathComponent)", completionHandler: nil)
            let fileName = url as URL
            print(fileName)
            print(url.lastPathComponent)
            if uploadDocTag == 4
            {
              //  uploadResumeName = url.lastPathComponent
                 resume = fileName
                lblResumeName.text = url.lastPathComponent
                print(resume!)
            }
           if uploadDocTag == 5
            {
         //       uploadDocOneName = url.lastPathComponent
                documentOne = fileName
                 lblDocumentOneName.text = url.lastPathComponent
                print(documentOne!)
            }
            if uploadDocTag == 6
            {
         //       uploadDocTwoName = url.lastPathComponent
                documentTwo = fileName
                lblDocumentTwoname.text = url.lastPathComponent
                print(documentTwo!)
            }
            
            if uploadDocTag == 7
            {
            //    uploadDocTwoName = url.lastPathComponent
                documentThree = fileName
                lblBackgrundUpload.text = url.lastPathComponent
                print(documentThree!)
            }
           
        }
    }
    
    func stringArrayToNSData(array: [String]) -> NSData {
        let data = NSMutableData()
      //  let terminator = [0]
        for string in array {
            if let encodedString = string.data(using: String.Encoding.utf8) {
                data.append(encodedString)
            //    data.append(terminator, length: 1)
            }
            else {
                print("Cannot encode string \"\(string)\"")
            }
        }
        return data
    }
    
    func saveAllData()
    {
        let obj_Validation = Validation()
        let viewArray : [UIView] = [viewTitle,viewSummary,viewExperience]
        let viewsToShake = obj_Validation.validationForProfessionalUpdate(viewList: viewArray)
        var paramerters = [String:Any]()
        if(viewsToShake.count == 0)
        {
         if self.skillsId.count != 0
            {

                let skillsString = self.skillsId.joined(separator: ",")
                print(skillsString)
                let certificateString = self.certificateId.joined(separator: ",")
                let equipmentString = self.equipmentId.joined(separator: ",")
                
                if txtAreaDetailResume.text != ""
                {
                    paramerters = ["professional_title": viewTitle.detailTextField.text!, "professional_summary": viewSummary.detailTextField.text!, "skill_sets": skillsString , "certification": certificateString , "equipment": equipmentString ,"licenses":viewLicenses.detailTextField.text!,"experience":viewExperience.detailTextField.text!,"resume_details": txtAreaDetailResume.text!,"bank_account_number":viewAccountNo.detailTextField.text!,"routing_number":viewRoutingNumber.detailTextField.text!] as [String : Any]
            
       
        var fileArray =  [[String:AnyObject]]()
        var dict = [String:Any]()
       
        if self.resume != nil
        {
            dict = ["resume":self.resume!,"fileName":lblResumeName.text!]
            fileArray.append(dict as [String : AnyObject])
        }
        if self.documentOne != nil
        {
            dict = ["general_liability_insuarance":self.documentOne!,"fileName":lblDocumentOneName.text!]
            fileArray.append(dict as [String : AnyObject])
        }
        if self.documentTwo != nil
        {
            dict = ["drug_test_certificate":self.documentTwo!,"fileName":lblDocumentTwoname.text!]
            fileArray.append(dict as [String : AnyObject])
        }
        if self.documentThree != nil
        {
            dict = ["drug_test_certificate":self.documentThree!,"fileName":lblBackgrundUpload.text!]
            fileArray.append(dict as [String : AnyObject])
        }

        WebAPI().callMultipartWebApiDocuments(API.updateProfessionalDetails, withHTTPMethod: .post, postMedia: fileArray, postMediaType: multipartyMediaType.document, forPostParameters: paramerters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            AListAlertController.shared.presentAlertController(message: serviceResponse["msg"] as! String, completionHandler: nil)
        })
            }
            else
         {
            let viewShaker = AFViewShaker(view: txtAreaDetailResume)
            txtAreaDetailResume.layer.borderColor = UIColor.red.cgColor
            viewShaker?.shake()
          }
     }
            else
         {
            let viewShaker = AFViewShaker(view: viewSkillTag)
            viewSkillTag.layer.borderColor = UIColor.red.cgColor
            viewShaker?.shake()
         }
            
        }
        else
        {
            let viewShaker = AFViewShaker(viewsArray: viewsToShake)
            print(viewsToShake)
            viewShaker?.shake()
        }
    }
    
    
    
    @IBAction func btn_SaveAction(_ sender: UIButton)
    {
        saveAllData()
    }
    
    func documentMenuWasCancelled(_ documentMenu: UIDocumentMenuViewController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_UploadResumeAction(_ sender: UIButton)
    {
        uploadDocTag = 4
        accessDocuments()
    }
    
    @IBAction func btn_UploadDocumentOneAction(_ sender: UIButton)
    {
        uploadDocTag = 5
        accessDocuments()
    }
    
    @IBAction func btn_UploadDocumentTwoAction(_ sender: UIButton)
    {
        uploadDocTag = 6
        accessDocuments()
    }
    
    @IBAction func btn_UploadBackgroundAction(_ sender: UIButton)
    {
        uploadDocTag = 7
        accessDocuments()
    }
    
    
    @IBAction func btn_PersonalDetailsAction(_ sender: UIButton)
    {
        let destination = self.storyboard!.instantiateViewController(withIdentifier: "PersonalDetailsViewController") as! PersonalDetailsViewController
        let nav = UINavigationController(rootViewController: destination)
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        nav.view.layer.add(transition, forKey: nil)
        nav.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
        nav.navigationBar.tintColor = UIColor.white
        nav.navigationBar.isTranslucent = false
        self.revealViewController().setFront(nav, animated: false)
    }
    
    @IBAction func btn_NotifcationAction(_ sender: UIBarButtonItem)
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
    @IBAction func btn_BackAction(_ sender: UIBarButtonItem)
    {
        let destination = self.storyboard!.instantiateViewController(withIdentifier: "DashBoardViewController") as! DashBoardViewController
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
    
    func getProfileDetails()
    {
        WebAPI().callJSONWebApi(API.getEditProfileDetails, withHTTPMethod: .get, forPostParameters: nil, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            let data = serviceResponse["data"] as? [String:Any]
            print(data!)
            self.getSkills = (data!["skills"] as! NSArray)
            self.getCertificates = (data!["certifications"] as! NSArray)
           // print(self.getCertificates)
            self.getEquipments = (data!["equipments"] as! NSArray)
           // print(self.getEquipments)
            let userProfile = data!["UserProfile"] as! [String:Any]
          //  let tech_Meta = userProfile["tech_meta"] as! [String:Any]
            if let tech = (data!)["tech"] as? [String:Any]
            {
            let techDict = (data!)["tech"] as! [String:Any]
            self.viewTitle.detailTextField.text = (techDict)["professional_title"] as? String
            self.viewSummary.detailTextField.text = (techDict)["professional_summary"] as? String
            self.viewExperience.detailTextField.text = (techDict)["experience"] as? String
            self.lblResumeName.text = (techDict)["resume"] as? String
            self.txtAreaDetailResume.text = (techDict)["resume_details"] as? String
            self.lblDocumentOneName.text = (techDict)["general_liability_insuarance"] as? String
            self.lblDocumentTwoname.text = (techDict)["background_certificate"] as? String
            self.viewLicenses.detailTextField.text = (techDict)["licenses_master_id"] as? String
            self.viewSSN.detailTextField.text = (techDict)["ssn_ein"] as? String
            self.viewAccountNo.detailTextField.text = (techDict)["bank_account_number"] as? String
            self.viewRoutingNumber.detailTextField.text = (techDict)["routing_number"] as? String
            
            self.setSkillsArray = techDict["skill_sets_name"] as! [String]
            self.skillsId = techDict["skill_sets_id"] as! [String]
             print(self.skillsId)
                if self.setSkillsArray.count != 0
                {
            for i in 0...self.setSkillsArray.count-1
            {
                self.viewSkillTag.addTag(self.setSkillsArray[i])
            }
                }
            self.setCertificates = techDict["certification_name"] as! [String]
            self.certificateId = techDict["certification_id"] as! [String]
            print(self.certificateId)
            if self.setCertificates.count != 0
            {
            for i in 0...self.setCertificates.count-1
            {
                self.viewCertification.addTag(self.setCertificates[i])
            }
            }
            self.setEquipments = techDict["equipment_master_name"] as! [String]
            self.equipmentId = techDict["equipment_master_id"] as! [String]
            print(self.equipmentId)
                if self.setEquipments.count != 0
                {
            for i in 0...self.setEquipments.count-1
            {
                self.viewEquipment.addTag(self.setEquipments[i])
            }
                }
            }
           
        })
    }

    @IBAction func btn_SkillsAction(_ sender: UITapGestureRecognizer)
    {
        if self.cnstSkillsHeight.constant == 0
        {
        self.cnstSkillsHeight.constant = CGFloat(30 * 3)
        self.tblSkills.delegate = self
        self.tblSkills.dataSource = self
        self.tblSkills.layer.borderWidth = 1
        self.tblSkills.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.tblSkills.layer.masksToBounds = true
        self.tblSkills.reloadData()
        }
        else
        {
            self.cnstSkillsHeight.constant = 0
        }
    }
    
    @IBAction func btn_CertificationAction(_ sender: UITapGestureRecognizer)
    {
        if self.cnstCertificationHeight.constant == 0
        {
        self.cnstCertificationHeight.constant = CGFloat(30 * 3)
        self.tblCertification.delegate = self
        self.tblCertification.dataSource = self
        self.tblCertification.layer.borderWidth = 1
        self.tblCertification.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.tblCertification.layer.masksToBounds = true
        self.tblCertification.reloadData()
        }
        else
        {
            self.cnstCertificationHeight.constant = 0
        }
    }
    
    @IBAction func btn_EquipmentAction(_ sender: UITapGestureRecognizer)
    {
        if self.cnstEquipment.constant == 0
        {
        self.cnstEquipment.constant = CGFloat(30 * 3)
        self.tblEquipment.delegate = self
        self.tblEquipment.dataSource = self
        self.tblEquipment.layer.borderWidth = 1
        self.tblEquipment.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.tblEquipment.layer.masksToBounds = true
        self.tblEquipment.reloadData()
        }
        else
        {
            self.cnstEquipment.constant = 0
        }
    }
}

extension ProfessionalDetailsViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblSkills
        {
           return self.getSkills.count
        }
        else if tableView == tblCertification
        {
             return self.getCertificates.count
        }
        else
        {
            return self.getEquipments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblSkills
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatesTableViewCell", for: indexPath) as! StatesTableViewCell
            cell.lblState.text = ((self.getSkills[indexPath.row] as? NSDictionary)?.object(forKey: "skill_name") as? String)!
            return cell
        }
        else if tableView == tblCertification
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatesTableViewCell", for: indexPath) as! StatesTableViewCell
            cell.lblState.text = ((self.getCertificates[indexPath.row] as? NSDictionary)?.object(forKey: "certification_name") as? String)!
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatesTableViewCell", for: indexPath) as! StatesTableViewCell
            cell.lblState.text = ((self.getEquipments[indexPath.row] as? NSDictionary)?.object(forKey: "equipment_name") as? String)!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let cell = tableView.cellForRow(at: indexPath)as! StatesTableViewCell
        if tableView == tblSkills
        {
            cell.lblState.text = ((self.getSkills[indexPath.row] as? NSDictionary)?.object(forKey: "skill_name") as? String)!
            self.skills = cell.lblState.text!
            self.viewSkillTag.addTag(self.skills)
            self.setSkillsArray.append(self.skills)
              print(self.setSkillsArray)
            self.skillsId.append(String((self.getSkills[indexPath.row] as? NSDictionary)?.object(forKey: "skill_set_master_id") as! Int))
             print(self.skillsId)
            self.cnstSkillsHeight.constant = 0
        }
        else if tableView == tblCertification
        {
            cell.lblState.text = ((self.getCertificates[indexPath.row] as? NSDictionary)?.object(forKey: "certification_name") as? String)!
            self.certificates = cell.lblState.text!
            self.viewCertification.addTag(self.certificates)
            self.setCertificates.append(self.certificates)
              print(self.setCertificates)
            self.certificateId.append(String((self.getCertificates[indexPath.row] as? NSDictionary)?.object(forKey: "certification_master_id") as! Int))
             print(self.certificateId)
            self.cnstCertificationHeight.constant = 0
        }
        else
        {
            cell.lblState.text = ((self.getEquipments[indexPath.row] as? NSDictionary)?.object(forKey: "equipment_name") as? String)!
            self.equipments = cell.lblState.text!
            self.viewEquipment.addTag(self.equipments)
            self.setEquipments.append(self.equipments)
              print(self.setEquipments)
            self.equipmentId.append(String((self.getEquipments[indexPath.row] as? NSDictionary)?.object(forKey: "equipment_master_id") as! Int))
            print(self.equipmentId)
            self.cnstEquipment.constant = 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    
}
