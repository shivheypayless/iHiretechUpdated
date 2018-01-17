//
//  ForgotViewController.swift
//  iHiretech
//
//  Created by Admin on 29/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ForgotViewController: UIViewController {

    @IBOutlet var btnReset: UIButton!
    @IBOutlet var viewCnfrmPass: FormFieldView!
    @IBOutlet var viewPassword: FormFieldView!
    @IBOutlet var viewOtp: FormFieldView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPassword.txtFieldName.isSecureTextEntry = true
        viewCnfrmPass.txtFieldName.isSecureTextEntry = true
        
        let iconsSize = CGRect(x: 0, y: 0, width: 12, height: 12)
        let  myMutableString = NSMutableAttributedString(string: "Reset Password", attributes: ([NSAttributedStringKey.font :  UIFont.systemFont(ofSize: 12.0), NSAttributedStringKey.foregroundColor: UIColor.white]))
        let starAttachment = NSTextAttachment()
        starAttachment.image = UIImage(named: "img_ButtonArrow")
        starAttachment.bounds = iconsSize
        myMutableString.append(NSAttributedString(attachment: starAttachment))
        //  btnResetLink.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnReset.setAttributedTitle(myMutableString, for: UIControlState.normal)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_ResetPassword(_ sender: UIButton)
    {
        var paramerters = [String:Any]()
        paramerters = ["otp": viewOtp.txtFieldName.text!, "new_password": viewPassword.txtFieldName.text! ,"confirm_password": viewCnfrmPass.txtFieldName.text!] as [String : Any]
        
        WebAPI().callJSONWebApi(API.reset, withHTTPMethod: .post, forPostParameters: paramerters, shouldIncludeAuthorizationHeader: false, actionAfterServiceResponse: { (serviceResponse) in
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
    
    @IBAction func btn_ResendOTP(_ sender: UIButton)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
