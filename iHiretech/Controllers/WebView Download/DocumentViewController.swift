//
//  DocumentViewController.swift
//  iHiretech
//
//  Created by Admin on 07/02/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import MBProgressHUD

class DocumentViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var viewDocument: UIWebView!
    var url: URL!
    var progressHUD: MBProgressHUD!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let urlRequest = URLRequest.init(url: urlResponse! as URL)
//        self.webView.loadRequest(urlRequest as URLRequest)
        self.viewDocument.delegate = self
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
    
    public func webViewDidStartLoad(_ webView: UIWebView)
    {
         self.showHUD()
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView)
    {
        self.progressHUD.hide(animated: true)
    }
    
    func showHUD() {
        progressHUD = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!.rootViewController!.view, animated: true)
    }
//    override func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
//    {
//    }
    
   
    
   

}
