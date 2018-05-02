//
//  BlendedApplyViewController.swift
//  iHiretech
//
//  Created by Admin on 17/01/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import AFViewShaker

class BlendedApplyViewController: UIViewController {

    @IBOutlet var cnstViewClose: NSLayoutConstraint!
    @IBOutlet var btnYes: UIButton!
    @IBOutlet var btnNo: UIButton!
    @IBOutlet var imgYes: UIImageView!
    @IBOutlet var imgNo: UIImageView!
    @IBOutlet var viewAnimate: UIView!
    @IBOutlet var btnApply: UIButton!
    @IBOutlet var cnstAnimateViewHeight: NSLayoutConstraint!
    @IBOutlet var textFieldComment: UITextField!
    @IBOutlet var viewBlendedSecondMaxHrs: TextFieldView!
    @IBOutlet var viewBlendedSecondAmt: TextFieldView!
    @IBOutlet var viewBlendedFirstMaxHrs: TextFieldView!
    @IBOutlet var viewBlendedFirstAmt: TextFieldView!
    var height_Yes = CGFloat()
    var workOrderId = Int()
    var paymentRateType = String()
    var statusName = String()
    var navigate = String()
    override func viewDidLoad() {
        super.viewDidLoad()
     self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
        self.textFieldComment.layer.borderWidth = 1
        self.textFieldComment.layer.borderColor =  UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.btnApply.layer.cornerRadius = 3
        self.btnApply.layer.masksToBounds = true
        self.height_Yes = self.viewAnimate.frame.size.height
       // self.cnstAnimateViewHeight.constant = 100.2*self.height_Yes
        self.cnstViewClose.constant = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btn_Chat(_ sender: UIBarButtonItem) {
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
    
    @IBAction func btn_Notification(_ sender: UIBarButtonItem) {
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
    
    @IBAction func btn_Back(_ sender: UIBarButtonItem) {
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_NoAction(_ sender: UIButton) {
//         btnNo.isUserInteractionEnabled = false
//        if imgNo.image == UIImage(named:"img_RadioOff")
//        {
            btnNo.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.imgYes.image = UIImage(named:"img_RadioOff")
                self.imgNo.image = UIImage(named:"img_RadioOn")
                self.height_Yes = self.viewAnimate.frame.size.height
               // self.cnstAnimateViewHeight.constant = 300.2*self.height_Yes
                self.cnstViewClose.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
            
  //      }
//        else
//        {
//            btnNo.isUserInteractionEnabled = false
//        }

        
    }
    
    @IBAction func btn_YesAction(_ sender: UIButton) {
        self.imgYes.image = UIImage(named:"img_RadioOn")
        self.imgNo.image = UIImage(named:"img_RadioOff")
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.height_Yes = self.viewAnimate.frame.size.height
          //  self.cnstAnimateViewHeight.constant = 0*self.height_Yes
            self.cnstViewClose.constant = 460
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
   
    @IBAction func btn_ApplyAction(_ sender: UIButton) {
        applyWorkOrder()
    }
    
    func applyWorkOrder()
    {
        var paramerters = [String:Any]()
        if imgYes.image == UIImage(named:"img_RadioOn")
        {
            let viewArray : [UIView] = [viewBlendedFirstAmt,viewBlendedFirstMaxHrs,viewBlendedSecondAmt,viewBlendedSecondMaxHrs]
            let obj_Validation = Validation()
            let viewsToShake = obj_Validation.validationForBlendedApply(viewList: viewArray)
            var paramerters = [String:Any]()
            if(viewsToShake.count == 0)
            {
              paramerters = ["work_order_id": self.workOrderId,"counter_offer":1, "payment_rate_type": self.paymentRateType,"blended_rate_amount_first": self.viewBlendedFirstAmt.txtFieldName.text!,"blended_rate_hours_first":self.viewBlendedFirstMaxHrs.txtFieldName.text!,"blended_rate_amount_second":self.viewBlendedSecondAmt.txtFieldName.text!,"blended_rate_hours_second":self.viewBlendedSecondMaxHrs.txtFieldName.text!,"comment":self.textFieldComment.text!] as [String : Any]
            }
            else
            {
                let viewShaker = AFViewShaker(viewsArray: viewsToShake)
                print(viewsToShake)
                viewShaker?.shake()
                return
            }
        }
        else
        {
            paramerters = ["work_order_id": self.workOrderId,"counter_offer": 0] as [String : Any]
        }
                if self.statusName == "routing"
                {
                    WebAPI().callJSONWebApi(API.approveWorkOrder, withHTTPMethod: .post, forPostParameters: paramerters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
                        print(serviceResponse)
                        if let message = serviceResponse["msg"] as? String
                        {
                            AListAlertController.shared.presentAlertController(message: serviceResponse["msg"] as! String, completionHandler: {
                                if self.navigate == "WorkOrderDetail"
                                {
                                    let destination = MyWorkOrderTableViewController(style: .plain)
                                    let transition = CATransition()
                                    transition.duration = 0.5
                                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                    transition.type = kCATransitionFade
                                    self.navigationController?.view.layer.add(transition, forKey: nil)
                                    self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                                    self.navigationController?.navigationBar.tintColor = UIColor.white
                                    self.navigationController?.navigationBar.isTranslucent = false
                                    self.navigationController?.pushViewController(destination, animated: false)
                                }
                                else  if self.navigate == "SearchWorkOrderDetail"
                                {
                                    let destination = SearchWorkOrderTableViewController(style: .plain)
                                    let transition = CATransition()
                                    transition.duration = 0.5
                                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                    transition.type = kCATransitionFade
                                    self.navigationController?.view.layer.add(transition, forKey: nil)
                                    self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                                    self.navigationController?.navigationBar.tintColor = UIColor.white
                                    self.navigationController?.navigationBar.isTranslucent = false
                                    self.navigationController?.pushViewController(destination, animated: false)
                                }
                                else
                                {
                                    let destination = AppliedRoutedTableViewController(style: .plain)
                                    let transition = CATransition()
                                    transition.duration = 0.5
                                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                    transition.type = kCATransitionFade
                                    self.navigationController?.view.layer.add(transition, forKey: nil)
                                    self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                                    self.navigationController?.navigationBar.tintColor = UIColor.white
                                    self.navigationController?.navigationBar.isTranslucent = false
                                    self.navigationController?.pushViewController(destination, animated: false)
                                }
                            })
                        }
                    })
                }
                else
                {
                        WebAPI().callJSONWebApi(API.applyWorkOrder, withHTTPMethod: .post, forPostParameters: paramerters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
                        print(serviceResponse)
                        if let message = serviceResponse["msg"] as? String
                        {
                            AListAlertController.shared.presentAlertController(message: serviceResponse["msg"] as! String, completionHandler: {
                                if self.navigate == "WorkOrderDetail"
                                {
                                    let destination = MyWorkOrderTableViewController(style: .plain)
                                    let transition = CATransition()
                                    transition.duration = 0.5
                                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                    transition.type = kCATransitionFade
                                    self.navigationController?.view.layer.add(transition, forKey: nil)
                                    self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                                    self.navigationController?.navigationBar.tintColor = UIColor.white
                                    self.navigationController?.navigationBar.isTranslucent = false
                                    self.navigationController?.pushViewController(destination, animated: false)
                                }
                                else  if self.navigate == "SearchWorkOrderDetail"
                                {
                                    let destination = SearchWorkOrderTableViewController(style: .plain)
                                    let transition = CATransition()
                                    transition.duration = 0.5
                                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                    transition.type = kCATransitionFade
                                    self.navigationController?.view.layer.add(transition, forKey: nil)
                                    self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                                    self.navigationController?.navigationBar.tintColor = UIColor.white
                                    self.navigationController?.navigationBar.isTranslucent = false
                                    self.navigationController?.pushViewController(destination, animated: false)
                                }
                                else
                                {
                                    let destination = AppliedRoutedTableViewController(style: .plain)
                                    let transition = CATransition()
                                    transition.duration = 0.5
                                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                    transition.type = kCATransitionFade
                                    self.navigationController?.view.layer.add(transition, forKey: nil)
                                    self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
                                    self.navigationController?.navigationBar.tintColor = UIColor.white
                                    self.navigationController?.navigationBar.isTranslucent = false
                                    self.navigationController?.pushViewController(destination, animated: false)
                                }
                            })
                            }
                        })
                }
          
        
    }
}
