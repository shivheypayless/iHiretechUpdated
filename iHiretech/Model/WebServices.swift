//
//  WebServices.swift
//  iHiretech
//
//  Created by Admin on 06/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import SystemConfiguration
import MBProgressHUD

enum multipartyMediaType : String
{
    case image = "image"
}

enum HTTPMethod : String {
    case post = "POST"
    case get = "GET"
}

enum API: String
{
    case registration = "api/auth/sign-up"
    case verifyOtp = "api/auth/verify-otp"
    case reSendOtp = "api/auth/send-otp"
    case login = "api/auth/log-in"
    case forgotPassword = "api/auth/forgot-password"
    case resetPassword = "api/auth/reset-password"
    case changePassword = "api/technician/change-password"
    case getTechnicianProfileDetails = "api/technician/profile"
}


typealias actionWithServiceResponse = ((_ serviceResponse: [String:Any])-> Void)

class WebAPI {
    
    //Static property to access Singleton Class
    static let shared = WebAPI()
    
    //Base URL for WebAPI(s)
    private let baseurl = "http://172.16.2.12:8080/"//local
    //    private let baseurl = "http://104.238.72.196:3003/"//testbed
    //    private let baseurl = "http://172.16.2.7:3003/"//live
    lazy var profileImgs = "\(baseurl)profileImgs/"
  //  lazy var postImgs = "\(baseurl)postImgs/"
    
    //GCD initialize Global User Interactive Queue
    private let userInteractiveGlobalQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
    //GCD initialize Global User Initiated Queue
    private let userInitiatedGlobalQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
    
    //Instance of URLSession to interact with WebAPI(s)
    private let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    
    //activity indicator while waiting for Web Api response and to stop user interaction
    fileprivate var progressHUD: MBProgressHUD!
    
    public func callJSONWebApi(_ api: API, withHTTPMethod method: HTTPMethod, forPostParameters parameters: [String:Any]!,shouldIncludeAuthorizationHeader authorizationHeaderFlag: Bool,actionAfterServiceResponse completionHandler: @escaping actionWithServiceResponse)
    {
        var request: URLRequest!
        if method == .post {
            //print(parameters)
            request = URLRequest(url: URL(string: "\(self.baseurl)\(api.rawValue)")!)
            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        else {
            
            if let keys = parameters?.keys {
                var queryString = "?"
                for eachKey in keys {
                    queryString.append("\(eachKey)=\(parameters[eachKey]!)&")
                }
                request = URLRequest(url: URL(string: "\(self.baseurl)\(api.rawValue)\(queryString)")!)
            }
            else {
                request = URLRequest(url: URL(string: "\(self.baseurl)\(api.rawValue)")!)
            }
            
        }
        print(request.url!)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if authorizationHeaderFlag {
            request.setValue(UserDefaults.standard.object(forKey: "token") as? String, forHTTPHeaderField: "Authorization")
        }
        guard checkForNetworkConnectivity() else {
            return
        }
//        if parameters?["page_no"] == nil {
//            showHUD()
//        }
//        else
//        {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        }
        
        showHUD()
        userInteractiveGlobalQueue.async {
            
            self.callWebServiceWithRequest(request, actionAfterServiceResponse: completionHandler)
        }
    }
    
    func buildQueryString(_ parameters: [String:String],baseURL url: String) -> String {
        var queryString = String()
        for eachParameter in parameters.keys {
            queryString.append("\(eachParameter)=\(parameters[eachParameter]!)&")
        }
        return "\(url)?\(queryString)"
    }

    
//perform dataTask(s) for Web Service(s)
    private func callWebServiceWithRequest(_ request: URLRequest, actionAfterServiceResponse completionHandler: @escaping actionWithServiceResponse) {
        let dataTask = defaultSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                self.progressHUD.hide(animated: true)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                guard error == nil else {
                    AListAlertController.shared.presentAlertController(message: (error?.localizedDescription)!, completionHandler: nil)
                    return
                }
                do {
                    let responseData = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                    print(responseData)
                    
                    if responseData["status"] as! Int == 1 {
                        if let message = responseData["msg"] as? String {
                        AListAlertController.shared.presentAlertController(message: message)
                        {
                            completionHandler(responseData)
                        }
                           
                        }
                        else {
                            completionHandler(responseData)
                        }
                    }
                    else {
                        if responseData["status"] as! Int == 0
                        {
                            if let data = responseData["data"] as? [String:Any]
                            {
                                if let message = data["email"] as? [AnyObject]
                                {
                                   if let mess = message[0] as? String
                                   {
                                    AListAlertController.shared.presentAlertController(message: mess , completionHandler: nil)
                                }
                                }
                            }
                            else
                            {
                                 if let message = responseData["msg"] as? String
                                 {
                               AListAlertController.shared.presentAlertController(message: responseData["msg"] as! String, completionHandler: nil)
                            }
                                else
                                 {
                                     completionHandler(responseData)
                                 }
                            }
                        }
                        else
                        {
                            if let message = responseData["msg"] as? String
                            {
                             AListAlertController.shared.presentAlertController(message: responseData["msg"] as! String, completionHandler: nil)
                            }
                            else
                            {
                                completionHandler(responseData)
                            }
                        }
                    }
                }
                catch
                {
                    AListAlertController.shared.presentAlertController(message: error.localizedDescription, completionHandler: nil)
                }
            }
        }
        dataTask.resume()
    }

}

extension WebAPI {
    
    // possible states for internet access
    private enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    private var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    
    // check for internet access
    fileprivate func checkForNetworkConnectivity() -> Bool {
        guard self.currentReachabilityStatus != .notReachable else {
//            let alertController = UIAlertController(title: "TrenderAlert", message: "Please check your internet connection !", preferredStyle: UIAlertControllerStyle.alert)
//            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in })
//            alertController.addAction(okAction)
//            UIApplication.shared.keyWindow!.rootViewController!.present(alertController, animated: true, completion: nil)
            AListAlertController.shared.presentAlertController(title: "Connection Problem", message: "Please check your internet connection !", completionHandler: nil)
            return false
        }
        return true
    }
    
    fileprivate func showHUD() {
        guard progressHUD != nil else {
            progressHUD = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!.rootViewController!.view, animated: true)
            return
        }
        progressHUD.show(animated: true)
    }
}

extension Data {
    mutating func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
