//
//  ChangePaawordViewController.swift
//  iHiretech
//
//  Created by ospmac on 26/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import AFViewShaker

class ChangePaawordViewController: UIViewController {

    @IBOutlet var btnResetPass: UIButton!
    @IBOutlet var viewConfirmPass: FormFieldView!
    @IBOutlet var viewNewPass: FormFieldView!
    @IBOutlet var viewOldPass: FormFieldView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewOldPass.txtFieldName.isSecureTextEntry = true
        viewNewPass.txtFieldName.isSecureTextEntry = true
        viewConfirmPass.txtFieldName.isSecureTextEntry = true
        let iconsSize = CGRect(x: 0, y: 0, width: 12, height: 12)
        //let attributedString = NSMutableAttributedString(string: "RESET PASSWORD ")
        let attributedString = NSMutableAttributedString(string: "RESET PASSWORD ", attributes: ([NSAttributedStringKey.font :  UIFont.systemFont(ofSize: 12.0), NSAttributedStringKey.foregroundColor: UIColor.white]))
        let starAttachment = NSTextAttachment()
        starAttachment.image = UIImage(named: "img_ButtonArrow")
        starAttachment.bounds = iconsSize
        attributedString.append(NSAttributedString(attachment: starAttachment))
      //  btnResetPass.titleLabel?.font = UIFont(name: "Quicksand-Bold_0", size: 12.0)
        btnResetPass.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnResetPass.setAttributedTitle(attributedString, for: UIControlState.normal)
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
    @IBAction func Btn_ChangePassword(_ sender: UIButton)
    {
        let viewArray : [UIView] = [viewOldPass,viewNewPass,viewConfirmPass]
        let obj_Validation = Validation()
        let viewsToShake = obj_Validation.validationForChangePassword(viewList: viewArray)
        var paramerters = [String:Any]()
        if(viewsToShake.count == 0)
        {
            
            paramerters = ["old_password": viewOldPass.txtFieldName.text!, "password": viewNewPass.txtFieldName.text!,"password_confirmation":viewConfirmPass.txtFieldName.text!] as [String : Any]
           
            if viewNewPass.txtFieldName.text! == viewConfirmPass.txtFieldName.text!
            {
            
            WebAPI().callJSONWebApi(API.changePassword, withHTTPMethod: .post, forPostParameters: paramerters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
                print(serviceResponse)
                 self.viewOldPass.txtFieldName.text = ""
                 self.viewNewPass.txtFieldName.text = ""
                 self.viewConfirmPass.txtFieldName.text = ""
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
            let viewShaker = AFViewShaker(viewsArray: viewsToShake)
            print(viewsToShake)
            viewShaker?.shake()
        }
    }
    
}
