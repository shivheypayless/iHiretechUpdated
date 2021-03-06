//
//  ApplyWorkViewController.swift
//  iHiretech
//
//  Created by Admin on 10/01/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import AFViewShaker

class ApplyWorkViewController: UIViewController {

    @IBOutlet var cnstLblMaxRate: NSLayoutConstraint!
    @IBOutlet var cnstMaxRateHeight: NSLayoutConstraint!
    @IBOutlet var lblMaxRate: UILabel!
    @IBOutlet var lblHourlyRate: UILabel!
    @IBOutlet var txtDescription: UITextField!
    @IBOutlet var cnstHeight: NSLayoutConstraint!
    @IBOutlet var btnApply: UIButton!
    @IBOutlet var txtFMaxRate: UITextField!
    @IBOutlet var txtFHourlyRate: UITextField!
    @IBOutlet var viewMaxRate: UIView!
    @IBOutlet var viewHourlyRate: UIView!
    @IBOutlet var viewAnimate: UIView!
    @IBOutlet var imgYes: UIImageView!
    @IBOutlet var imgNo: UIImageView!
    @IBOutlet var btnYes: UIButton!
    @IBOutlet var btnNo: UIButton!
    var height_Yes = CGFloat()
    var workOrderId = Int()
    var paymentRateType = String()
    var statusName = String()
    var navigate = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.paymentRateType == "2"
        {
            lblHourlyRate.text! = "Hourly Rate"
            self.cnstMaxRateHeight.constant = 36.0
            self.cnstLblMaxRate.constant = 36.0
           // self.viewMaxRate.clipsToBounds = true
        }
        else
        {
            lblHourlyRate.text! = "Fixed Pay Amount"
            self.cnstMaxRateHeight.constant = 0
            self.cnstLblMaxRate.constant = 0
        }
         self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
        self.viewMaxRate.layer.borderWidth = 1
        self.viewMaxRate.layer.borderColor =  UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        self.txtDescription.layer.borderWidth = 1
        self.txtDescription.layer.borderColor =  UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        self.viewHourlyRate.layer.borderWidth = 1
        self.viewHourlyRate.layer.borderColor =  UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        self.btnApply.layer.cornerRadius = 3
        self.btnApply.layer.masksToBounds = true
         self.height_Yes = self.viewAnimate.frame.size.height
         self.cnstHeight.constant = 50.2*self.height_Yes

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func btn_backAction(_ sender: UIBarButtonItem) {
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_NotificationAction(_ sender: UIBarButtonItem) {
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
    
  
    @IBAction func btn_ChatAction(_ sender: UIBarButtonItem) {
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
    
    @IBAction func btn_NoAction(_ sender: Any) {
//       if imgNo.image == UIImage(named:"img_RadioOff")
//       {
         btnNo.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.imgYes.image = UIImage(named:"img_RadioOff")
             self.imgNo.image = UIImage(named:"img_RadioOn")
            self.lblHourlyRate.isHidden = true
            self.lblMaxRate.isHidden = true
            self.height_Yes = self.viewAnimate.frame.size.height
            self.cnstHeight.constant = 50.2*self.height_Yes
            self.view.layoutIfNeeded()
        }, completion: nil)
       
//   }
//        else
//       {
//         btnNo.isUserInteractionEnabled = false
//        }

    }
    
    @IBAction func btn_YesAction(_ sender: Any) {
//        if imgYes.image == UIImage(named:"img_RadioOn")
//        {
            self.imgYes.image = UIImage(named:"img_RadioOn")
            self.imgNo.image = UIImage(named:"img_RadioOff")
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.lblHourlyRate.isHidden = false
                self.lblMaxRate.isHidden = false
                self.height_Yes = self.viewAnimate.frame.size.height
                self.cnstHeight.constant = 0*self.height_Yes
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
        if self.paymentRateType == "2"
        {
            if self.txtFMaxRate.text! == "" && self.txtFHourlyRate.text == ""
            {
                self.txtFHourlyRate.placeholder = "Hourly Rate cannot be empty"
                self.txtFMaxRate.placeholder = "Max Hours cannot be empty"
                let viewShaker = AFViewShaker(view: viewMaxRate)
                print(viewMaxRate)
                self.viewMaxRate.layer.borderColor = UIColor.red.cgColor
                self.viewHourlyRate.layer.borderColor = UIColor.red.cgColor
                let viewShakerrate = AFViewShaker(view: viewHourlyRate)
                print(viewHourlyRate)
                viewShakerrate?.shake()
                return
            }
            if self.txtFMaxRate.text! == ""
            {
                self.txtFMaxRate.placeholder = "Max Hours cannot be empty"
                self.viewMaxRate.layer.borderColor = UIColor.red.cgColor
                let viewShaker = AFViewShaker(view: viewMaxRate)
                print(viewMaxRate)
                viewShaker?.shake()
                return
            }
            else if self.txtFHourlyRate.text == ""
            {
                self.txtFHourlyRate.placeholder = "Hourly Rate cannot be empty"
                self.viewHourlyRate.layer.borderColor = UIColor.red.cgColor
                let viewShaker = AFViewShaker(view: viewHourlyRate)
                print(viewHourlyRate)
                viewShaker?.shake()
                return
            }
            self.txtFHourlyRate.placeholder == ""
            self.txtFMaxRate.placeholder == ""
            self.viewMaxRate.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
            self.viewHourlyRate.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        paramerters = ["work_order_id": self.workOrderId,"counter_offer":1, "payment_rate_type":self.paymentRateType,"per_hour_rate": self.txtFHourlyRate.text!,"per_hour_max_hours":self.txtFMaxRate.text!,"comment":""] as [String : Any]
        }
        else if self.paymentRateType == "1"
        {
            if self.txtFHourlyRate.text == ""
            {
                 self.txtFHourlyRate.placeholder = "Fixed Rate cannot be empty"
                let viewShaker = AFViewShaker(view: viewMaxRate)
                print(viewMaxRate)
                self.viewMaxRate.layer.borderColor = UIColor.red.cgColor
                self.viewHourlyRate.layer.borderColor = UIColor.red.cgColor
                let viewShakerrate = AFViewShaker(view: viewHourlyRate)
                print(viewHourlyRate)
                viewShakerrate?.shake()
                return
            }
            self.txtFHourlyRate.placeholder = ""
            self.viewMaxRate.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
            self.viewHourlyRate.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
             paramerters = ["work_order_id": self.workOrderId,"counter_offer":1, "payment_rate_type":self.paymentRateType,"fixed_pay_amount": self.txtFHourlyRate.text!,"per_hour_max_hours":self.txtFMaxRate.text!,"comment":""] as [String : Any]
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
