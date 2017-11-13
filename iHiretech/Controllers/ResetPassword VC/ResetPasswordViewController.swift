//
//  ResetPasswordViewController.swift
//  iHiretech
//
//  Created by ospmac on 26/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SWRevealViewController
import AFViewShaker

class ResetPasswordViewController: UIViewController {

    @IBOutlet var viewEmail: FormFieldView!
    @IBOutlet var btnResetLink: UIButton!
      var webService = WebAPI()
    override func viewDidLoad() {
        super.viewDidLoad()
        let iconsSize = CGRect(x: 0, y: 0, width: 12, height: 12)
     //   let myMutableString = NSMutableAttributedString(string: "SEND PASSWORD RESET LINK ")
//        let myMutableString = NSMutableAttributedString(
//            string: "SEND PASSWORD RESET LINK ",
//            attributes: [NSAttributedStringKey.font:UIFont(
//                name: "Quicksand-Bold_0",
//                size: 12.0)!])
       
        let  myMutableString = NSMutableAttributedString(string: "SEND PASSWORD RESET LINK ", attributes: ([NSAttributedStringKey.font :  UIFont.systemFont(ofSize: 12.0), NSAttributedStringKey.foregroundColor: UIColor.white]))
        let starAttachment = NSTextAttachment()
        starAttachment.image = UIImage(named: "img_ButtonArrow")
        starAttachment.bounds = iconsSize
        myMutableString.append(NSAttributedString(attachment: starAttachment))
      //  btnResetLink.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnResetLink.setAttributedTitle(myMutableString, for: UIControlState.normal)
      
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_SendPasswordLinkAction(_ sender: UIButton)
    {
        var paramerters = [String:Any]()
        paramerters = ["email": viewEmail.txtFieldName.text!] as [String : Any]
        if (viewEmail.txtFieldName.text!) == ""
        {
            let viewShaker = AFViewShaker(view: viewEmail)
            print(viewEmail)
            viewShaker?.shake()
        }
        else
        {
            if (isValidEmail(testStr: viewEmail.txtFieldName.text!))
            {
            webService.callJSONWebApi(API.forgotPassword, withHTTPMethod: .post, forPostParameters: paramerters, shouldIncludeAuthorizationHeader: false, actionAfterServiceResponse: { (serviceResponse) in
                print(serviceResponse)
                
                if let message = serviceResponse["msg"] as? String
                {
                    AListAlertController.shared.presentAlertController(message: message)
                    {
                        let nav = self.storyboard!.instantiateViewController(withIdentifier: "VerifyOtpViewController") as! VerifyOtpViewController
                        let transition = CATransition()
                        transition.duration = 0.5
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        transition.type = kCATransitionFade
                        self.navigationController?.view.layer.add(transition, forKey: nil)
                        self.navigationController?.isNavigationBarHidden = false
                        self.navigationController?.pushViewController(nav, animated: false)
                        self.navigationController?.isNavigationBarHidden = false
                        self.navigationController?.navigationBar.barTintColor = UIColor.black
                    }
                }
            })
            }
            else
            {
                viewEmail.txtFieldName.text = ""
                viewEmail.txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Enter Valid Email Address",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
                let viewShaker = AFViewShaker(view: viewEmail)
                print(viewEmail)
                viewShaker?.shake()
            }
        }
    
       
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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
