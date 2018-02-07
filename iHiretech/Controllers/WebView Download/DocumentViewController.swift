//
//  DocumentViewController.swift
//  iHiretech
//
//  Created by Admin on 07/02/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {

    @IBOutlet var viewDocument: UIWebView!
    var url: URL!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let urlRequest = URLRequest.init(url: urlResponse! as URL)
//        self.webView.loadRequest(urlRequest as URLRequest)
        print(url)
        var request = URLRequest.init(url: url)
        request.setValue(UserDefaults.standard.object(forKey: "token")! as! String, forHTTPHeaderField: "Authorization")
        self.viewDocument.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_backAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
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
