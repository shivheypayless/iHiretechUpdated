//
//  SignUpViewController.swift
//  iHiretech
//
//  Created by ospmac on 26/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SWRevealViewController
import AFViewShaker

class SignUpViewController: UIViewController {

    @IBOutlet var imgTickUntick: UIImageView!
    @IBOutlet var viewConfirmPass: FormFieldView!
    @IBOutlet var viewPassWord: FormFieldView!
    @IBOutlet var viewEmail: FormFieldView!
    @IBOutlet var viewLastName: FormFieldView!
    @IBOutlet var viewFirstName: FormFieldView!
    @IBOutlet var lblTermAndServices: UILabel!
    @IBOutlet var btnSignUp: UIButton!
    var terms = 0
    var webService = WebAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPassWord.txtFieldName.isSecureTextEntry = true
        viewConfirmPass.txtFieldName.isSecureTextEntry = true
        let iconsSize = CGRect(x: 0, y: 0, width: 12, height: 12)
        let attributedString = NSMutableAttributedString(string: "SIGN UP ", attributes: ([NSAttributedStringKey.font :  UIFont.systemFont(ofSize: 12.0), NSAttributedStringKey.foregroundColor: UIColor.white]))
        let starAttachment = NSTextAttachment()
        starAttachment.image = UIImage(named: "img_ButtonArrow")
        starAttachment.bounds = iconsSize
        attributedString.append(NSAttributedString(attachment: starAttachment))
        btnSignUp.titleLabel?.font = UIFont(name: "Quicksand-Bold_0", size: 12.0)
        btnSignUp.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnSignUp.setAttributedTitle(attributedString, for: UIControlState.normal)
        
//        let  attributed = NSMutableAttributedString(string: (lblTermAndServices.text)!, attributes: ([NSAttributedStringKey.font : UIFont(name: "Quicksand-Regular",size: 14.0)!, NSAttributedStringKey.foregroundColor: UIColor(red: 250/255, green: 199/255, blue: 0/255, alpha: 1)]))
//        lblTermAndServices.attributedText = attributed
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Btn_VerifyAccount(_ sender: UIButton)
    {
        let nav = self.storyboard!.instantiateViewController(withIdentifier: "VerifyOtpViewController") as! VerifyOtpViewController
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(nav, animated: false)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    @IBAction func btn_SignUpAction(_ sender: UIButton)
    {
        SignUp()
    }
    
    
    @IBAction func btn_TermsConditionsAction(_ sender: UITapGestureRecognizer)
    {
        if imgTickUntick.image == UIImage(named:"img_UnCheckReminder")
        {
          imgTickUntick.image = UIImage(named:"img_CheckReminder")
            terms = 1
        }
        else
        {
            imgTickUntick.image = UIImage(named:"img_UnCheckReminder")
            terms = 0
        }
    }
    
    func SignUp()
    {
        let viewArray : [UIView] = [viewFirstName,viewLastName,viewEmail,viewPassWord,viewConfirmPass]
        let obj_Validation = Validation()
        let viewsToShake = obj_Validation.validationForSignup(viewList: viewArray)
        var paramerters = [String:Any]()
        if(viewsToShake.count == 0)
        {
//            paramerters = ["first_name": viewFirstName.txtFieldName.text!, "last_name": viewLastName.txtFieldName.text!, "email":viewEmail.txtFieldName.text!, "password": viewPassWord.txtFieldName.text!, "confirm_password": viewConfirmPass.txtFieldName.text!,"user_type":"technician","terms":terms,"device_id":"6998E359CA0619C7B90772DEF7A70F463BF97A5F559E328E88581C802851724F","device_type":"ios"] as [String : Any]
          if self.terms == 1
          {
            
            paramerters = ["first_name": viewFirstName.txtFieldName.text!, "last_name": viewLastName.txtFieldName.text!, "email":viewEmail.txtFieldName.text!, "password": viewPassWord.txtFieldName.text!, "confirm_password": viewConfirmPass.txtFieldName.text!,"user_type":"technician","terms":terms,"device_id":((UserDefaults.standard.object(forKey: "deviceToken") != nil) ?  (UserDefaults.standard.object(forKey: "deviceToken")!) : "6998E359CA0619C7B90772DEF7A70F463BF97A5F559E328E88581C802851724F"),"device_type":"ios"] as [String : Any]
            if viewPassWord.txtFieldName.text! == viewConfirmPass.txtFieldName.text!
            {
            
            webService.callJSONWebApi(API.registration, withHTTPMethod: .post, forPostParameters: paramerters, shouldIncludeAuthorizationHeader: false, actionAfterServiceResponse: { (serviceResponse) in
                print(serviceResponse)
                
                if let message = serviceResponse["msg"] as? String
                {
                    if message == "Validation error."
                    {
                        let nav = self.storyboard!.instantiateViewController(withIdentifier: "VerifyOtpViewController") as! VerifyOtpViewController
                        nav.emailId = self.viewEmail.txtFieldName.text!
                        let transition = CATransition()
                        transition.duration = 0.5
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        transition.type = kCATransitionFade
                        self.navigationController?.view.layer.add(transition, forKey: nil)
                        self.navigationController?.isNavigationBarHidden = false
                        self.navigationController?.pushViewController(nav, animated: false)
                        self.navigationController?.isNavigationBarHidden = true
                        self.navigationController?.navigationBar.barTintColor = UIColor.black
                    }
                    else
                    {
                    AListAlertController.shared.presentAlertController(message: message)
                    {
                        let nav = self.storyboard!.instantiateViewController(withIdentifier: "VerifyOtpViewController") as! VerifyOtpViewController
                        nav.emailId = self.viewEmail.txtFieldName.text!
                        let transition = CATransition()
                        transition.duration = 0.5
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        transition.type = kCATransitionFade
                        self.navigationController?.view.layer.add(transition, forKey: nil)
                        self.navigationController?.isNavigationBarHidden = true
                        self.navigationController?.pushViewController(nav, animated: false)
                        self.navigationController?.isNavigationBarHidden = false
                        self.navigationController?.navigationBar.barTintColor = UIColor.black
                    }
                }
                }
            })
            }
            else
            {
                viewConfirmPass.txtFieldName.text = ""
                viewConfirmPass.txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Passwords do not match",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
                let viewShaker = AFViewShaker(view: viewConfirmPass)
                print(viewConfirmPass)
                viewShaker?.shake()
            }
            }
            else
          {
             AListAlertController.shared.presentAlertController(message: "Please accept Technician Terms & Conditions.", completionHandler: nil)
          }
        }
        else
        {
            let viewShaker = AFViewShaker(viewsArray: viewsToShake)
            print(viewsToShake)
            viewShaker?.shake()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigationkey
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
