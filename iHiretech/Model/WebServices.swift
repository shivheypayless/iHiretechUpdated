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
import Alamofire

enum multipartyMediaType : String
{
    case image = "image"
    case document = "application/pdf"
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
    case reset = "api/auth/reset-password"
  //  case resetPassword = "api/auth/reset-password"
    case changePassword = "api/technician/change-password"
    case getTechnicianProfileDetails = "api/technician/profile"
    case technicianUploadProfilePic = "api/technician/upload-profile-picture"
    case getEditProfileDetails = "api/technician/edit-profile"
    case updatePersonalDetails = "api/technician/update-personal-details"
    case updateProfessionalDetails = "api/technician/update-professional-details"
    case getProfilePic = "api/technician/profilePic"
    case workOrderListing = "api/technician/my-work-order-listing"
    case searchWorkOrderListing = "api/technician/get-work-order-listing"
    case appliedRoutedOrderListing = "api/technician/applied-routed-work-order-listing"
    case workOrderDetails = "api/technician/view-work-order-details"
    case getChatHistory = "api/technician/get-users-message"
    case sendMessageChat = "api/technician/send-message"
    case applyWorkOrder = "api/technician/apply-to-work-order"
    case rejectWorkOrder = "api/technician/cancel-routed-work-order"
    case ratingCustomer = "api/technician/rate-customer"
    case shareGps = "api/technician/store-gps"
    case checkIn = "api/technician/check-in-work-order"
    case checkOut = "api/technician/check-out-work-order"
    case getNotificationList = "api/technician/get-notification-list"
    case addExpenses = "api/technician/add-technician-expenses"
    case approveWorkOrder = "technician/approve-routed-work-order"
    case ratingTechnicianList = "technician/technician-rating-list"
}


typealias actionWithServiceResponse = ((_ serviceResponse: [String:Any])-> Void)

class WebAPI {
    
    //Static property to access Singleton Class
    static let shared = WebAPI()
    
    //Base URL for WebAPI(s)
  //  private let baseurl = "http://172.16.2.62:8001/"//local
     private let baseurl = "http://172.16.2.68:8001/" // local
  //  private let baseurl = "https://app.ihiretech.hplbusiness.com/" //testbed
    //    private let baseurl = "http://172.16.2.7:3003/"//live
   // lazy var profileImgs = "\(baseurl)profileImgs/"
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
                       // AListAlertController.shared.presentAlertController(message: message)
                    //    {
                            completionHandler(responseData)
                     //   }
                           
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
                                else if let message = data["image"] as? [AnyObject]
                                {
                                    if let mess = message[0] as? String
                                    {
                                        AListAlertController.shared.presentAlertController(message: mess , completionHandler: nil)
                                    }
                                }
                            }
                            else
                            {
                                if (responseData["msg"] as? String) != nil
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
                            if (responseData["msg"] as? String) != nil
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
    
    
    // call Web Service with Content-Type: multipart/form-data
    public func callMultipartWebApi(_ api: API, withHTTPMethod method: HTTPMethod, postMedia media: NSData?, postMediaType mediaType : multipartyMediaType?, forPostParameters parameters: [String:Any]!,shouldIncludeAuthorizationHeader authorizationHeaderFlag: Bool,actionAfterServiceResponse completionHandler: @escaping actionWithServiceResponse)
    {
        guard checkForNetworkConnectivity() else {
            return
        }
       
            self.showHUD()
     
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        userInitiatedGlobalQueue.async {
            var request = URLRequest(url: URL(string: "\(self.baseurl)\(api.rawValue)")!)
            request.httpMethod = method.rawValue
            let boundary = self.generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            if(media != nil)
            {
                request.httpBody = self.createBodyWithParameters(parameters: parameters as [String : AnyObject], filePathKey: "image", mimeType: mediaType!, imageDataKey: media!, boundary: boundary) as Data
            }
           
           
            if authorizationHeaderFlag {
                request.addValue(UserDefaults.standard.object(forKey: "token") as! String, forHTTPHeaderField: "Authorization")
            }
            self.callWebServiceWithRequest(request, actionAfterServiceResponse: completionHandler)
        }
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    private func createBodyWithParameters(parameters: [String: AnyObject]?, filePathKey: String?, mimeType : multipartyMediaType, imageDataKey: NSData, boundary: String) -> Data {
        var body = Data()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        var filename = String()
        
        var mimetype = String()
        if(mimeType.rawValue == "image"){
            filename = "asdasd22.jpg"
            mimetype = "image/*"
        }
       
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        
        body.appendString(string: "\r\n")
        if(mimeType.rawValue == "video")
        {
            AListAlertController.shared.presentAlertController(title: "iHiretech", message: "Please select image only !", completionHandler: nil)
//            body.appendString(string: "--\(boundary)\r\n")
//            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"asdasd22.jpg\"\r\n")
       //     body.appendString(string: "Content-Type: image/*\r\n\r\n")
//            body.append(UIImageJPEGRepresentation(thumbNailImg!, 1.0)! as Data)
//            body.appendString(string: "\r\n")
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    // call Web Service with Content-Type: multipart/form-data
    public func callMultipartWebApiDocuments(_ api: API, withHTTPMethod method: HTTPMethod, postMedia media:[[String:AnyObject]]!,postMediaType mediaType : multipartyMediaType?, forPostParameters parameters: [String:Any]!,shouldIncludeAuthorizationHeader authorizationHeaderFlag: Bool,actionAfterServiceResponse completionHandler: @escaping actionWithServiceResponse)
    {
        guard checkForNetworkConnectivity() else
        {
            return
        }
    
        self.showHUD()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        userInitiatedGlobalQueue.async {
            var request = URLRequest(url: URL(string: "\(self.baseurl)\(api.rawValue)")!)
            request.httpMethod = method.rawValue
             let boundary = "Boundary-\(UUID().uuidString)"
        //     request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
           
//            if authorizationHeaderFlag {
//                request.addValue(UserDefaults.standard.object(forKey: "token") as! String, forHTTPHeaderField: "Authorization")
//            }
         
           let headers: HTTPHeaders = ["Authorization": UserDefaults.standard.object(forKey: "token")! as! String,
                                        "content-type": "multipart/form-data; boundary= \(boundary)",
                "cache-control": "no-cache"
            ]
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        //    request.httpBody = jsonData

          request.allHTTPHeaderFields = headers
            Alamofire.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    
                        multipartFormData.append((value as! String).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! ,  withName: key)
                        
                }
        
            }, with: request, encodingCompletion: {
                encodingResult in
                switch encodingResult {
                case .success(let upload, _,_):
                    upload.responseJSON { response in
                        debugPrint("SUCCESS RESPONSE: \(response)")
                     self.progressHUD.hide(animated: true)
                    }
                case .failure(let encodingError):
                    // hide progressbas here
                    print("ERROR RESPONSE: \(encodingError)")
                      self.progressHUD.hide(animated: true)
                }
            })
            
//            Alamofire.upload(multipartFormData:{ multipartFormData in
//                for (key, value) in parameters {
//                    multipartFormData.append(jsonData, withName: key)
//                    var fileName = String()
//                    var fileData : Data?
//                    if media?.count != 0
//                    {
//                        for fileType in 0...media.count-1
//                        {
//                            if ((media[fileType] as [String:AnyObject])["resume"] as? NSData) != nil
//                            {
//
//                                fileName = ((media[fileType] as [String:AnyObject])["fileName"] as! String)
//                                fileData = ((media[fileType] as [String:AnyObject])["resume"] as! Data)
//                                 multipartFormData.append(fileData!, withName: fileName)
//
//                            }
//                            if ((media[fileType] as [String:AnyObject])["general_liability_insuarance"] as? NSData) != nil
//                            {
//                                fileName = ((media[fileType] as [String:AnyObject])["fileName"] as! String)
//                                fileData = ((media[fileType] as [String:AnyObject])["general_liability_insuarance"] as! Data)
//                                 multipartFormData.append(fileData!, withName: fileName)
//                            }
//                            if ((media[fileType] as [String:AnyObject])["drug_test_certificate"] as? NSData) != nil
//                            {
//                                fileName = ((media[fileType] as [String:AnyObject])["fileName"] as! String)
//                                fileData = ((media[fileType] as [String:AnyObject])["drug_test_certificate"] as! Data)
//                                multipartFormData.append(fileData!, withName: fileName)
//                            }
//
//                        }
//
//                    }
//
//                }
////                for (key, value) in parameters {
////                    if let array = value as? [String]
////                    {
////                        do {
////                            let jsonData = try JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
////                            // here "jsonData" is the dictionary encoded in JSON data
////                            multipartFormData.append(jsonData,  withName: key)
////                            print("success")
////                        } catch {
////                            print(error.localizedDescription)
////                        }
////
////                    }
////                    else
////                    {
////
////                        multipartFormData.append((value as! String).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! ,  withName: key)
////                    }
////                }
//
//            },
//                             usingThreshold:UInt64.init(),
//                             to: "\(self.baseurl)\(api.rawValue)",
//                             method:.post,
//                             headers: headers,
//                             encodingCompletion: { encodingResult in
//                                switch encodingResult {
//                                case .success(let upload, _, _):
//                                    upload.responseString(completionHandler: { response in
//                                        print("success", response.result.value!)
//                                          self.progressHUD.hide(animated: true)
//                                    })
//                                case .failure(let encodingError):
//                                    print("en eroor :", encodingError)
//                                      self.progressHUD.hide(animated: true)
//                                }
//            })
//
//            
           
            
            
     //       self.callWebServiceWithRequest(request, actionAfterServiceResponse: completionHandler)
        }
    }
    
 
    private func createBodyWithParametersDocuments(media:[[String:AnyObject]]!, parameters: [String: AnyObject]?, boundary: String) -> Data {
        var body = Data()
        
        if parameters != nil {
            for (key, value) in parameters! {
             //   body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "\(key)")
                body.appendString(string: "\(value)")
            }
        }
        
        var fileName = String()
        var fileData : NSData?
        
        if media?.count != 0
        {
            for fileType in 0...media.count-1
            {
                if ((media[fileType] as [String:AnyObject])["resume"] as? NSData) != nil
                {
//                    fileName = ((media[fileType] as [String:AnyObject])["fileName"] as! String)
//                    fileData = ((media[fileType] as [String:AnyObject])["resume"] as! NSData)
//                    body.appendString(string: "--\(boundary)\r\n")
//                    body.appendString(string: "Content-Disposition: form-data; name=\"resume\"; filename=\"\(fileName)\"\r\n")
//                 //   body.appendString(string: "Content-Type: multipart/form-data; boundary= \(boundary)")
//                    body.append(fileData! as Data)
//                    body.appendString(string: "\r\n")
                    
                        fileName = ((media[fileType] as [String:AnyObject])["fileName"] as! String)
                        fileData = ((media[fileType] as [String:AnyObject])["resume"] as! NSData)
                        body.appendString(string: "--\(boundary)\r\n")
                        body.appendString(string: "Content-Disposition: form-data; name=\"resume\"; filename=\"\(fileName)\"\r\n")
                        body.appendString(string: "Content-Type: application/pdf\r\n\r\n")
                        body.append(fileData! as Data)
                        body.appendString(string: "\r\n")
                }
                if ((media[fileType] as [String:AnyObject])["general_liability_insuarance"] as? NSData) != nil
                {
                    fileName = ((media[fileType] as [String:AnyObject])["fileName"] as! String)
                     fileData = ((media[fileType] as [String:AnyObject])["general_liability_insuarance"] as! NSData)
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"general_liability_insuarance\"; filename=\"\(fileName)\"\r\n")
                    body.append(fileData! as Data)
                 //   body.appendString(string: "Content-Type: multipart/form-data; boundary= \(boundary)")
                    body.appendString(string: "\r\n")
                }
                if ((media[fileType] as [String:AnyObject])["drug_test_certificate"] as? NSData) != nil
                {
                    fileName = ((media[fileType] as [String:AnyObject])["fileName"] as! String)
                     fileData = ((media[fileType] as [String:AnyObject])["drug_test_certificate"] as! NSData)
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"drug_test_certificate\"; filename=\"\(fileName)\"\r\n")
                    body.append(fileData! as Data)
                 //   body.appendString(string: "Content-Type: multipart/form-data; boundary= \(boundary)")
                    body.appendString(string: "\r\n")
                }
               
            }

        }
    
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
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
