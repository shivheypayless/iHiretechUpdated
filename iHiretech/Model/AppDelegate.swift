//
//  AppDelegate.swift
//  iHiretech
//
//  Created by Admin on 25/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import MapKit
import SWRevealViewController
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,LocationUpdateProtocol, SocketIOManagerDelegate {
    func usersTyping(_ data: [String : Any]) {
        
    }
    func messageReceived(_ data: String) {
        
    }
  
    var window: UIWindow?
    var storyBoard: UIStoryboard!
    var statusLocation = Int()
    var workOrderId = Int()
    // var UserLocation:
    
    var locationTracker : LocationTracker =  LocationTracker.sharedLocationInstance() as! LocationTracker
    var locationUpdateTimer : Timer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
         // self.locationObjectAllocation()
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
        }
        UIApplication.shared.statusBarStyle = .lightContent
        
        GMSServices.provideAPIKey("AIzaSyBm6BnRIXEMTtviPmt5tmZ8jVgSN_tz0L4")
        GMSPlacesClient.provideAPIKey("AIzaSyBm6BnRIXEMTtviPmt5tmZ8jVgSN_tz0L4")

        registerForPushNotifications()
        
        if UserDefaults.standard.object(forKey: "deviceToken") as? String == nil
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyboard.instantiateViewController(withIdentifier: "RootNavViewController") as! RootNavViewController
            self.window!.rootViewController = destination
            self.window!.makeKeyAndVisible()
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.window!.rootViewController = destination
            self.window!.makeKeyAndVisible()
        }
        return true
    }
    

    
    func registerForPushNotifications()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    
    func locationObjectAllocation(workOrderID : Int , status : Int)
    {
        self.statusLocation = status
        self.workOrderId = workOrderID
        if(UIApplication.shared.backgroundRefreshStatus == .denied)
        {
            // todo : Alert for The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh
        }
        else if(UIApplication.shared.backgroundRefreshStatus == .restricted)
        {
            //Todo : Alert for The functions of this app are limited because the Background App Refresh is disable.
        }
        else
        {
            var time: TimeInterval = 30.0
            if self.statusLocation == 1
            {
            locationTracker.startLocationTracking()
            locationTracker.delegate = self
            //Send the best location to server every 60 seconds
            //You may adjust the time interval depends on the need of your app.
            locationUpdateTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(self.updateLocationTimer), userInfo: nil, repeats: true)
            }
            else
            {
                locationTracker.stopLocationTracking()
                locationTracker.delegate = self
                locationUpdateTimer?.invalidate()
                 print("Stop Update")
                self.locationTracker.updateLocationToServer()
            }
        }
        
    }
    @objc func updateLocationTimer()
    {
        print("Location update")
        self.locationTracker.updateLocationToServer()
    }

    func updateLocation(toServer latitude: String!, longi Longitude: String!)
    {
        print(latitude)
        print(Longitude)
        var parameters = ["work_order_id":self.workOrderId,"status":self.statusLocation,"latitude":latitude,"longitude":Longitude] as [String : Any]
        WebAPI().callJSONWebApi(API.shareGps, withHTTPMethod: .post, forPostParameters: parameters, shouldIncludeAuthorizationHeader: true, actionAfterServiceResponse: { (serviceResponse) in
            print(serviceResponse)
        })
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
    {
        print(userInfo)
      //  print(((((userInfo as AnyObject).object(forKey: "aps") as AnyObject).object(forKey: "alert")as AnyObject).object(forKey: "work_order_id") as! Int))
        if UserDefaults.standard.object(forKey: "UnreadAlert") != nil
        {
           application.applicationIconBadgeNumber = (UserDefaults.standard.object(forKey: "UnreadAlert")! as! Int)
        }
      
        if ((((userInfo as AnyObject).object(forKey: "aps") as AnyObject).object(forKey: "alert")as AnyObject).object(forKey: "work_order_status") as! String) == "1"
        {
            let storyboardRoot = UIStoryboard(name: "Main", bundle: nil)
            let destinationRoot = storyboardRoot.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.window!.rootViewController = destinationRoot
            self.window!.makeKeyAndVisible()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyboard.instantiateViewController(withIdentifier: "SearchOrderDetailViewController") as! SearchOrderDetailViewController
            if ((((userInfo as AnyObject).object(forKey: "aps") as AnyObject).object(forKey: "alert")as AnyObject).object(forKey: "flag") as! String) == "chat"
            {
                destination.tabsTag = 2
                destination.workOrderId = Int((((userInfo as AnyObject).object(forKey: "aps") as AnyObject).object(forKey: "alert")as AnyObject).object(forKey: "work_order_id") as! String)!
                destination.txtSendMsg.text! = ((((userInfo as AnyObject).object(forKey: "aps") as AnyObject).object(forKey: "alert")as AnyObject).object(forKey: "title") as! String)
                destination.socketId = ((((userInfo as AnyObject).object(forKey: "aps") as AnyObject).object(forKey: "alert")as AnyObject).object(forKey: "to_user") as! String)
            }
            else
            {
                destination.tabsTag = 1
                destination.workOrderId = Int((((userInfo as AnyObject).object(forKey: "aps") as AnyObject).object(forKey: "alert")as AnyObject).object(forKey: "work_order_id") as! String)!
            }
            
            (destinationRoot.frontViewController as! UINavigationController).navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
            (destinationRoot.frontViewController as! UINavigationController).navigationBar.tintColor = UIColor.white
            (destinationRoot.frontViewController as! UINavigationController).navigationBar.isTranslucent = false
            (destinationRoot.frontViewController as! UINavigationController).pushViewController(destination, animated: false)
        }
        else
        {
        let storyboardRoot = UIStoryboard(name: "Main", bundle: nil)
        let destinationRoot = storyboardRoot.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.window!.rootViewController = destinationRoot
        self.window!.makeKeyAndVisible()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyboard.instantiateViewController(withIdentifier: "WorkOrderDetailsViewController") as! WorkOrderDetailsViewController
        if ((((userInfo as AnyObject).object(forKey: "aps") as AnyObject).object(forKey: "alert")as AnyObject).object(forKey: "flag") as! String) == "chat"
        {
           destination.tabsTag = 2
            destination.workOrderId = Int((((userInfo as AnyObject).object(forKey: "aps") as AnyObject).object(forKey: "alert")as AnyObject).object(forKey: "work_order_id") as! String)!
         //   destination.txtSendMsg.text! = ((((userInfo as AnyObject).object(forKey: "aps") as AnyObject).object(forKey: "alert")as AnyObject).object(forKey: "title") as! String)
            destination.socketId = ((((userInfo as AnyObject).object(forKey: "aps") as AnyObject).object(forKey: "alert")as AnyObject).object(forKey: "to_user") as! String)
        }
        else
        {
            destination.tabsTag = 1
            destination.workOrderId = Int(((((userInfo as AnyObject).object(forKey: "aps") as AnyObject).object(forKey: "alert")as AnyObject).object(forKey: "work_order_id") as? String)!)!
        }
       
        (destinationRoot.frontViewController as! UINavigationController).navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
        (destinationRoot.frontViewController as! UINavigationController).navigationBar.tintColor = UIColor.white
        (destinationRoot.frontViewController as! UINavigationController).navigationBar.isTranslucent = false
        (destinationRoot.frontViewController as! UINavigationController).pushViewController(destination, animated: false)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        // SocketIOManager.sharedInstance.establishConnection()
          SocketIOManager.sharedInstance.closeConnection()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        SocketIOManager.sharedInstance.establishConnection()
        SocketIOManager.sharedInstance.socketIOManagerDelegate = self
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
         SocketIOManager.sharedInstance.establishConnection()
        SocketIOManager.sharedInstance.socketIOManagerDelegate = self
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "iHiretech")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

