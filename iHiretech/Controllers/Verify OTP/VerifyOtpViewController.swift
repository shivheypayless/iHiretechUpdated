//
//  VerifyOtpViewController.swift
//  iHiretech
//
//  Created by Admin on 07/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import AFViewShaker

class VerifyOtpViewController: UIViewController {

 
    @IBOutlet var btnVerify: UIButton!
    @IBOutlet var viewOtp: FormFieldView!
    var emailId = String()
    var webService = WebAPI()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let iconsSize = CGRect(x: 0, y: 0, width: 12, height: 12)
        let attributedString = NSMutableAttributedString(string: "Verify Account ", attributes: ([NSAttributedStringKey.font :  UIFont.systemFont(ofSize: 12.0), NSAttributedStringKey.foregroundColor: UIColor.white]))
        let starAttachment = NSTextAttachment()
        starAttachment.image = UIImage(named: "img_ButtonArrow")
        starAttachment.bounds = iconsSize
        attributedString.append(NSAttributedString(attachment: starAttachment))
        btnVerify.titleLabel?.font = UIFont(name: "Quicksand-Bold_0", size: 12.0)
        btnVerify.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnVerify.setAttributedTitle(attributedString, for: UIControlState.normal)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func Btn_VerifyOtpAction(_ sender: UIButton)
    {
        var paramerters = [String:Any]()
      
        if viewOtp.txtFieldName.text! == ""
        {
            let viewShaker = AFViewShaker(view: viewOtp)
             viewOtp.txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Enter OTP Code",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            print(viewOtp)
            viewShaker?.shake()
        }
        else
        {
            paramerters = ["otp": Int(viewOtp.txtFieldName.text!)!,"email":self.emailId] as [String : Any]
            print(paramerters)
         webService.callJSONWebApi(API.verifyOtp, withHTTPMethod: .post, forPostParameters: paramerters, shouldIncludeAuthorizationHeader: false, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
            
            if let message = serviceResponse["msg"] as? String
            {
                AListAlertController.shared.presentAlertController(message: message)
                {
                    let nav = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    transition.type = kCATransitionFade
                    self.navigationController?.view.layer.add(transition, forKey: nil)
                    self.navigationController?.isNavigationBarHidden = true
                    self.navigationController?.pushViewController(nav, animated: false)
                    self.navigationController?.navigationBar.barTintColor = UIColor.black

                }
            }
         })
        }
    }
   
    
    @IBAction func Btn_ResendOTP(_ sender: UIButton)
    {
        let nav = self.storyboard!.instantiateViewController(withIdentifier: "ResendOtpViewController") as! ResendOtpViewController
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(nav, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
    }
    
}
