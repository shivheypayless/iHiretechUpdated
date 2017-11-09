//
//  iHiretechNavigationViewController.swift
//  iHiretech
//
//  Created by Admin on 26/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SWRevealViewController

class iHiretechNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.white       // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
//        if self.viewControllers.count == 1 && !(viewController is ViewController)
//        {
            let barBtn_SideMenu = UIBarButtonItem(image: UIImage(named: "img_Menu"), style: UIBarButtonItemStyle.plain, target: viewController.navigationController?.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            viewController.navigationItem.leftBarButtonItem = barBtn_SideMenu
//        }
//        else
//        {
//            let barBtn_Back = UIBarButtonItem(image: UIImage(named: "img_Menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.popViewController(sender:)))
//            viewController.navigationItem.leftBarButtonItem = barBtn_Back
//        }
//        if viewController.navigationItem.rightBarButtonItem == nil
//        {
//
//        }
        
    }
    
    @objc func popViewController(sender: Any) {
        _ = self.popViewController(animated: true)
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
