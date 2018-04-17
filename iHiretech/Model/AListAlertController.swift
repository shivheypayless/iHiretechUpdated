//
//  AListAlertViewController.swift
//  ALIST
//
//  Created by ospmac on 04/10/17.
//  Copyright © 2017 heypayless. All rights reserved.
//

import UIKit

class AListAlertController: UIAlertController {
    
    static let shared = AListAlertController(title: "Techadox", message: nil, preferredStyle: .alert)
    var actionAfterDismiss: (()->Void)!
     var appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            guard self.actionAfterDismiss != nil else {
                return
            }
            self.actionAfterDismiss()
        }
        addAction(okAction)
    }
    
    func presentAlertController(title: String = "Techadox", message: String, completionHandler: (()->Void)?) {
        self.title = title
        self.message = message
        actionAfterDismiss = completionHandler
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: nil)
    }

}
