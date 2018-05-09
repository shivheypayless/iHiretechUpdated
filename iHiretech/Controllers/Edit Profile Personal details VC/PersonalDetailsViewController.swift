//
//  PersonalDetailsViewController.swift
//  iHiretech
//
//  Created by Admin on 01/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import KLCPopup
import AFViewShaker

typealias getUserDetailsPersonal = (String) -> Void

class PersonalDetailsViewController: UIViewController {

    @IBOutlet var viewCountry: EditTextView!
    @IBOutlet var viewZip: EditTextView!
    @IBOutlet var viewCity: EditTextView!
    @IBOutlet var viewExtension: EditTextView!
    @IBOutlet var viewContactNumber: EditTextView!
    @IBOutlet var viewAddressLineTwo: EditTextView!
    @IBOutlet var viewAdressLineOne: EditTextView!
    @IBOutlet var viewLastName: EditTextView!
    @IBOutlet var viewFirstname: EditTextView!
    @IBOutlet var viewUserName: EditTextView!
    @IBOutlet var viewState: EditTextView!
    @IBOutlet var cnstStateHeight: NSLayoutConstraint!
    @IBOutlet var stateTableView: UITableView!
    @IBOutlet var viewDate: EditTextView!
    @IBOutlet var imgSelectedProfilePic: UIImageView!
    @IBOutlet var btnUploadImage: UIButton!
     let picker = UIImagePickerController()
    var calenderPickerView = UIDatePicker()
    var popup = KLCPopup()
    var getProfileDetailsDict = [String:Any]()
    var getStates = NSArray()
    var profileImage = Data()
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        getProfileDetails { (userDetails) in
            self.getProfilePic()
        }
        self.viewCountry.borderView.backgroundColor = UIColor(red: 225/255, green: 229/255, blue: 234/255, alpha: 1)
        self.viewCountry.detailTextField.text = "USA"
      // getProfileDetails()
        self.btnUploadImage.layer.cornerRadius = 3
        self.btnUploadImage.layer.masksToBounds = true
//        if viewContactNumber.detailTextField.text! == ""
//        {
        self.viewContactNumber.detailTextField.addTarget(self, action: #selector(self.textFieldTextChangedTrend(_:)), for: UIControlEvents.editingChanged)
        self.viewUserName.detailTextField.addTarget(self, action: #selector(self.textFieldTextChangedTrend(_:)), for: UIControlEvents.editingChanged)
//        }
         self.cnstStateHeight.constant = 0
          self.stateTableView.register(UINib(nibName: "StatesTableViewCell", bundle: nil) , forCellReuseIdentifier: "StatesTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    override func viewDidLayoutSubviews() {
        imgSelectedProfilePic.layer.cornerRadius = imgSelectedProfilePic.frame.size.height/2
        imgSelectedProfilePic.layer.masksToBounds = true
        imgSelectedProfilePic.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_ProfessionalDetailsAction(_ sender: UIButton)
    {
        let destination = self.storyboard!.instantiateViewController(withIdentifier: "ProfessionalDetailsViewController") as! ProfessionalDetailsViewController
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
    
    @IBAction func btn_NotificationAction(_ sender: UIBarButtonItem)
    {
        let nav = self.storyboard!.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(nav, animated: true)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btn_UploadProfilePic(_ sender: UIButton)
    {
        self.view.endEditing(true)
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select your option", message: "", preferredStyle: .actionSheet)
        
        let cameraActionButton: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { void in
            print("Camera")
            self.openCamera()
        }
        actionSheetControllerIOS8.addAction(cameraActionButton)
        
        let galleryActionButton: UIAlertAction = UIAlertAction(title: "Gallery", style: .default) { void in
            print("Gallery")
            self.openGallary()
        }
        
        actionSheetControllerIOS8.addAction(galleryActionButton)
        
        let CancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .default) { void in
            print("Gallery")
            self.dismiss(animated: true, completion: nil)
        }
        
        actionSheetControllerIOS8.addAction(CancelActionButton)
        
        actionSheetControllerIOS8.popoverPresentationController?.sourceView = self.btnUploadImage
        actionSheetControllerIOS8.popoverPresentationController?.sourceRect = self.btnUploadImage.bounds
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    @IBAction func btn_StateAction(_ sender: UIButton)
    {
        if self.cnstStateHeight.constant == 0
        {
        self.cnstStateHeight.constant = 100
        self.stateTableView.layer.borderWidth = 1
        self.stateTableView.layer.borderColor = UIColor.lightGray.cgColor
      //  self.stateTableView.layer.cornerRadius = 6.0
       // self.stateTableView.layer.masksToBounds = true
        self.stateTableView.delegate = self
        self.stateTableView.dataSource = self
        self.stateTableView.reloadData()
        }
        else
        {
            self.cnstStateHeight.constant = 0
        }
    }
    
    @IBAction func btn_DateAction(_ sender: UIButton)
    {
        view.endEditing(true)
        var calenderView = UIView()
        var calenderPickerView = UIDatePicker()
        calenderView = Bundle.main.loadNibNamed("DatePickerView", owner: self, options: nil)?[0] as! UIView
        calenderView.layer.cornerRadius = 10.0
        calenderView.layer.masksToBounds = true
        calenderPickerView = (calenderView.viewWithTag(3)! as! UIDatePicker)
        calenderPickerView.datePickerMode = UIDatePickerMode.date
        calenderPickerView.maximumDate = Date()
        let CloseButton = calenderView.viewWithTag(1) as! UIButton
        CloseButton.addTarget(self, action: #selector(self.btn_CloseAction(_:)), for: UIControlEvents.touchUpInside)
        let SaveButton = calenderView.viewWithTag(2) as! UIButton
        SaveButton.addTarget(self, action: #selector(self.btn_SaveDateAction(_:)), for: UIControlEvents.touchUpInside)
        popup = KLCPopup(contentView: calenderView , showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popup.show()
    }
    
    @objc func btn_SaveDateAction(_ sender: UIButton)
    {
        popup.dismiss(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        self.viewDate.detailTextField.text! = dateFormatter.string(from: calenderPickerView.date)
        
    }
    
    @objc func btn_CloseAction(_ sender: UIButton)
    {
        popup.dismiss(true)
    }
    
    func getProfileDetails(details : @escaping getUserDetailsPersonal)
    {
        WebAPI().callJSONWebApi(API.getEditProfileDetails, withHTTPMethod: .get, forPostParameters: nil, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            let data = serviceResponse["data"] as? [String:Any]
            self.getProfileDetailsDict = data!["user"] as! [String:Any]
            self.getStates = (data!["states"] as! NSArray)
            print(self.getStates)
            let userProfile = data!["UserProfile"] as! [String:Any]
            self.viewFirstname.detailTextField.text = userProfile["first_name"] as? String
            self.viewLastName.detailTextField.text = userProfile["last_name"] as? String
            self.viewUserName.detailTextField.text = (self.getProfileDetailsDict)["username"] as? String
            self.viewDate.detailTextField.text = userProfile["date_of_birth"] as? String
            self.viewAdressLineOne.detailTextField.text = userProfile["address_line_1"] as? String
            self.viewAddressLineTwo.detailTextField.text = userProfile["address_line_2"] as? String
            self.viewCity.detailTextField.text = userProfile["city"] as? String
            self.viewState.detailTextField.text = userProfile["state"] as? String
            if !(userProfile["zip_code"] is NSNull)
            {
               if (userProfile["zip_code"] is String)
                {
                    self.viewZip.detailTextField.text = userProfile["zip_code"] as! String
                }
                else
               {
                self.viewZip.detailTextField.text = String(userProfile["zip_code"] as! Int)
                }
              
            }
            if let contact = (userProfile["contact_number_1"] as? String)
            {
            let endIndex = (userProfile["contact_number_1"] as? String)!.index((userProfile["contact_number_1"] as? String)!.endIndex, offsetBy: -8)
            let truncated = (userProfile["contact_number_1"] as? String)!.substring(to: endIndex)
            print(truncated)
           //  self.viewContactNumber.detailTextField.text = truncated
              self.viewContactNumber.detailTextField.text =  String((userProfile["contact_number_1"] as! String).prefix(11))
            let lastChar = String((userProfile["contact_number_1"] as? String)!.suffix(2))
            print(lastChar)
             self.viewExtension.detailTextField.text = lastChar
            }
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
                    print(afterEqualsTo)
                }
            let imageData = String(afterEqualsTo).data(using: String.Encoding.utf8)
            
            if let decodedData = NSData(base64Encoded: imageData!, options: .ignoreUnknownCharacters) {
                print(decodedData)
              //  self.profileImage = decodedData as Data
                if decodedData != nil
                {
                    DispatchQueue.global(qos: .background).async {
                        DispatchQueue.main.async {
                            self.imgSelectedProfilePic.image = UIImage(data: decodedData as Data)
                        }
                    }
                }
                else
                {
                    DispatchQueue.global(qos: .background).async {
                        DispatchQueue.main.async {
                            self.imgSelectedProfilePic.image = UIImage(named: "img_EditProfilePic")
                        }
                    }
            }
            }
            }
        })
    }
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func uploadPersonalDetails()
    {
        let obj_Validation = Validation()
        let viewArray : [UIView] = [viewUserName,viewFirstname,viewLastName,viewDate,viewAdressLineOne,viewContactNumber,viewCity,viewState,viewZip,viewCountry]
        let viewsToShake = obj_Validation.validationPersonalProfile(viewList: viewArray)
        var paramerters = [String:Any]()
        if(viewsToShake.count == 0)
        {
            if viewExtension.detailTextField.text! != ""
            {
                 paramerters = ["username": viewUserName.detailTextField.text!, "first_name": viewFirstname.detailTextField.text!, "last_name":viewLastName.detailTextField.text!, "date_of_birth": viewDate.detailTextField.text!, "address_line_1": viewAdressLineOne.detailTextField.text!,"address_line_2":viewAddressLineTwo.detailTextField.text!,"contact_number_1":viewContactNumber.detailTextField.text!,"contact_number_extension":Int(viewExtension.detailTextField.text!)!,"city":viewCity.detailTextField.text!,"state":viewState.detailTextField.text!,"zip_code":Int(viewZip.detailTextField.text!)!,"country":viewCountry.detailTextField.text!] as [String : Any]
            }
            else
            {
                 paramerters = ["username": viewUserName.detailTextField.text!, "first_name": viewFirstname.detailTextField.text!, "last_name":viewLastName.detailTextField.text!, "date_of_birth": viewDate.detailTextField.text!, "address_line_1": viewAdressLineOne.detailTextField.text!,"address_line_2":viewAddressLineTwo.detailTextField.text!,"contact_number_1":viewContactNumber.detailTextField.text!,"contact_number_extension":viewExtension.detailTextField.text!,"city":viewCity.detailTextField.text!,"state":viewState.detailTextField.text!,"zip_code":Int(viewZip.detailTextField.text!)!,"country":viewCountry.detailTextField.text!] as [String : Any]
            }
       
            print(paramerters)
        WebAPI().callJSONWebApi(API.updatePersonalDetails, withHTTPMethod: .post, forPostParameters: paramerters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            if let message = serviceResponse["msg"] as? String
            {
               AListAlertController.shared.presentAlertController(message: message, completionHandler: nil)
            }
            })
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
        uploadPersonalDetails()
    }
}

extension PersonalDetailsViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
  
    /*************************
     Method Name:  openGallary()
     Parameter: nil
     return type: nil
     Desc: This function opens the gallery.
     *************************/
    func openGallary()
    {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    /*************************
     Method Name:  openCamera()
     Parameter: nil
     return type: nil
     Desc: This function opens the Camera.
     *************************/
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    /*************************
     Method Name:  imagePickerControllerDidCancel()
     Parameter: UIImagePickerController
     return type: nil
     Desc: This function is called if user taps cancel button.
     *************************/
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    /*************************
     Method Name:  imagePickerController()
     Parameter: UIImagePickerController, [String : Any]
     return type: nil
     Desc: This function is called when user selects image from gallery.
     *************************/
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        print(info)
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
         //   mediaType = .image
            imgSelectedProfilePic.image = fixOrientation(img: chosenImage)
           let fileSize = chosenImage.scale
            print(fileSize)

            let imageData = UIImageJPEGRepresentation(imgSelectedProfilePic.image!, 0.5)! as NSData
            
         //   mediaData = UIImageJPEGRepresentation(fixOrientation(img: chosenImage), 1.0)! as NSData
            let parameters = [
                    "name": "image",
                    "fileName": "asdasd22.jpg"
                ] as [String:AnyObject]
            WebAPI().callMultipartWebApi(API.technicianUploadProfilePic, withHTTPMethod: .post, postMedia: imageData, postMediaType: multipartyMediaType.image, forPostParameters: parameters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
                print(serviceResponse)
                AListAlertController.shared.presentAlertController(message: serviceResponse["msg"] as! String, completionHandler: nil)
            })
            
        }
        else
        {
            print("Something went wrong")
        }
        dismiss(animated:true, completion: nil)
    }
    
    func fixOrientation(img:UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
    
}

extension PersonalDetailsViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getStates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatesTableViewCell", for: indexPath) as! StatesTableViewCell
        cell.lblState.text = ((self.getStates[indexPath.row] as? NSDictionary)?.object(forKey: "state_name") as? String)!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let cell = tableView.dequeueReusableCell(withIdentifier: "StatesTableViewCell", for: indexPath) as! StatesTableViewCell
        cell.backgroundColor = UIColor.green
        self.viewState.detailTextField.text! = ((self.getStates[indexPath.row] as? NSDictionary)?.object(forKey: "state_name") as? String)!
      //  self.stateTableView.isHidden = true
        self.cnstStateHeight.constant = 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
}

extension PersonalDetailsViewController : UITextFieldDelegate
{
    @objc func textFieldTextChangedTrend(_ sender : UITextField)
    {
          if  !(viewContactNumber.detailTextField.text!.isEmpty)
            {
               viewContactNumber.detailTextField.delegate = self
            }
        
        if  !(viewUserName.detailTextField.text!.isEmpty)
        {
            viewUserName.detailTextField.delegate = self
        }
    }
//
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
       
        if viewUserName.detailTextField.text!.characters.contains(" "){
            viewUserName.detailTextField.text! = viewUserName.detailTextField.text!.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        }
        
        if !(viewContactNumber.detailTextField.text!.isEmpty) {
      
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            
            if (isBackSpace == -92)
            {
                print("Backspace was pressed")
            }
          else
            {
                if range.location >= 12
                {
                    return false
                }
                else
                {
                if viewContactNumber.detailTextField.text!.characters.count == 7 || viewContactNumber.detailTextField.text!.characters.count == 3
                {
                    textField.text = "\(textField.text!)-\(string)"
                    return false
                }
                }
            }
        }
         return true
        
    }
}



