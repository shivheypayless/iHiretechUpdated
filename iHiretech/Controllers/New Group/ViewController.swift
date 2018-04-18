//
//  ViewController.swift
//  iHiretech
//
//  Created by Admin on 25/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SWRevealViewController
import AFViewShaker

class ViewController: UIViewController {

    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var viewPassword: FormFieldView!
    @IBOutlet var viewUserName: FormFieldView!
     var webService = WebAPI()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPassword.txtFieldName.isSecureTextEntry = true
         self.navigationController?.isNavigationBarHidden = true
        let iconsSize = CGRect(x: 0, y: 0, width: 12, height: 12)
      //  let attributedString = NSMutableAttributedString(string: "SIGN IN ")
         let  attributedString = NSMutableAttributedString(string: "SIGN IN ", attributes: ([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12.0), NSAttributedStringKey.foregroundColor: UIColor.white]))
        let starAttachment = NSTextAttachment()
        starAttachment.image = UIImage(named: "img_ButtonArrow")
        starAttachment.bounds = iconsSize
        attributedString.append(NSAttributedString(attachment: starAttachment))
     //   btnSignIn.titleLabel?.font = UIFont(name: "Quicksand-Bold_0", size: 12.0)
        btnSignIn.setTitleColor(UIColor.white, for: UIControlState.normal)
         btnSignIn.setAttributedTitle(attributedString, for: UIControlState.normal)
        
    //    self.viewUserName.txtFieldName.text = "rohan@yopmail.com"
     //   self.viewPassword.txtFieldName.text = "123456"
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btn_SignIn(_ sender: UIButton)
    {
           Login()
    }
    
    @IBAction func btn_ForgotPassword(_ sender: UIButton)
    {
        let nav = self.storyboard!.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
        let transition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
       self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(nav, animated: false)
        self.navigationController?.isNavigationBarHidden = false
         self.navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    
    @IBAction func btn_SignUp(_ sender: UIButton)
    {
        let nav = self.storyboard!.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(nav, animated: false)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.black
     
    }
    
    func Login()
    {
        let viewArray : [UIView] = [viewUserName,viewPassword]
        let obj_Validation = Validation()
        let viewsToShake = obj_Validation.validationForLogin(viewList: viewArray)
        var paramerters = [String:Any]()
        if(viewsToShake.count == 0)
        {
            paramerters = ["login": viewUserName.txtFieldName.text!, "password": viewPassword.txtFieldName.text!,"user_type":"technician","device_id":((UserDefaults.standard.object(forKey: "deviceToken") != nil) ?  (UserDefaults.standard.object(forKey: "deviceToken")!) : "6998E359CA0619C7B90772DEF7A70F463BF97A5F559E328E88581C802851724F"),"device_type":"ios"] as [String : Any]
            
         //    paramerters = ["login": viewUserName.txtFieldName.text!, "password": viewPassword.txtFieldName.text!,"user_type":"technician","device_id":(UserDefaults.standard.object(forKey: "deviceToken")!),"device_type":"ios"] as [String : Any]
            
       //    paramerters = ["login": viewUserName.txtFieldName.text!, "password": viewPassword.txtFieldName.text!,"user_type":"technician","device_id":"6998E359CA0619C7B90772DEF7A70F463BF97A5F559E328E88581C802851724F","device_type":"ios"] as [String : Any]
            
            
            webService.callJSONWebApi(API.login, withHTTPMethod: .post, forPostParameters: paramerters, shouldIncludeAuthorizationHeader: false, actionAfterServiceResponse: { (serviceResponse) in
                print(serviceResponse)
                
                 let data = serviceResponse["data"] as? [String:Any]
                
                let tokenData = data!["token"] as? String
                print(tokenData!)
                
                UserDefaults.standard.setValue("Bearer " + tokenData!, forKey: "token")
                  if let message = serviceResponse["msg"] as? String
                  {
                    AListAlertController.shared.presentAlertController(message: message)
                    {
                        let destination = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        UIApplication.shared.keyWindow!.rootViewController = destination
                    }
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
    
}

