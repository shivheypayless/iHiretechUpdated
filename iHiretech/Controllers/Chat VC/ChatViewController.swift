//
//  ChatViewController.swift
//  iHiretech
//
//  Created by Admin on 31/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet var chatTextField: UITextField!
    @IBOutlet var tblChat: UITableView!
    let chatRoom = ChatView()
     var chatHistory = [AnyObject]()
    var conversation = ["Hello","Hi.","How are you?","I'm doing great. What have you been upto these days?","Nothing much! Just the usual corporate work life.","Ohh I see. BTW why don't you visit us for a dinner or something with Sue and kids.","Yeah sure why not!","How does next Saturday Night sound to you.","Yeah will do, as long as Sue doesn't have any other plans for the night.","Sure, I'll even notify Aisha about it","Cool","Meet up soon.","Cya"]
    
    var timer: Timer!
    
    var isTyping = false {
        didSet {
            guard oldValue != isTyping else {
                return
            }
            guard isTyping else {
                self.tblChat.reloadData()
                return
            }
            let lastIndexPath = self.tblChat.indexPathsForVisibleRows!.sorted(by: { $0.row < $1.row }).last!
           
            self.tblChat.reloadData()
            guard lastIndexPath.row == chatHistory.count - 1 else {
                return
            }
            self.tblChat.scrollToRow(at: IndexPath(row: lastIndexPath.row + 1, section: 0) , at: .bottom, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
        
        self.chatTextField.layer.cornerRadius = 6
        self.chatTextField.layer.masksToBounds = true
        self.chatTextField.layer.borderWidth = 1
        self.chatTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        chatTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
      getChatHistory()
        self.tblChat.register(UINib(nibName: "OwnerTableViewCell", bundle: nil) , forCellReuseIdentifier: "OwnerTableViewCell")
        self.tblChat.register(UINib(nibName: "OtherUserTableViewCell", bundle: nil) , forCellReuseIdentifier: "OtherUserTableViewCell")
        self.tblChat.estimatedRowHeight = 40
        self.tblChat.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // chatRoom.setupNetworkCommunication()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    

    
    func getChatHistory()
    {
      //  let chatDetail = self.chatDetails["chatWith"] as! [String:Any]
     //   print(String(describing: chatDetail["socket_id"]!))
        let parameter = ["with_users_id":"873f51a0f9d0b0871df292dccfeb0964","work_order_id":"612"] as! [String:AnyObject]
        //chatTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        WebAPI.shared.callJSONWebApi(.getChatHistory, withHTTPMethod: .post, forPostParameters: parameter, shouldIncludeAuthorizationHeader: true) { (serviceResponse) in
            print(serviceResponse)
            let Data = serviceResponse["data"] as! [String:AnyObject]
            self.chatHistory = Data["messages"] as! [AnyObject]
            if self.chatHistory.count != 0
            {
                self.tblChat.dataSource = self
                self.tblChat.delegate = self
                self.tblChat.reloadData()
            }
            else
            {
                self.tblChat.reloadData()
            }
            //SocketIOManager.sharedInstance.socketIOManagerDelegate = self
            guard self.chatHistory.count > 0 else {
                return
            }
            self.tblChat.scrollToRow(at: IndexPath(row: self.chatHistory.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_NotificationAction(_ sender: UIBarButtonItem)
    {
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
    
    @IBAction func btn_backAction(_ sender: UIBarButtonItem)
    {
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
    
    
    @IBAction func btn_SendMessage(_ sender: UIButton)
    {
        guard !chatTextField.text!.isEmpty else {
            return
        }
        
        SocketIOManager.sharedInstance.sendDataToEvent(.message, data: [
            "to_id" : "",
            "work_order_id": "",
            "message": chatTextField.text!])
        chatTextField.text = nil
    }
    
    @objc func textDidChange(_ sender: UITextField) {
      //  SocketIOManager.sharedInstance.sendDataToEvent(.typing, data: [:])
    }
    
}

extension ChatViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerTableViewCell", for: indexPath) as! OwnerTableViewCell
          //  cell.lblText.text = self.conversation[indexPath.row]
            cell.lblText.text = chatHistory[indexPath.row]["msg_string"] as? String
        return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherUserTableViewCell", for: indexPath) as! OtherUserTableViewCell
      //      cell.lblText.text = self.conversation[indexPath.row]
            cell.lblText.text = chatHistory[indexPath.row]["msg_string"] as? String
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
}

//extension ChatViewController: SocketIOManagerDelegate {
//    func usersTyping(_ data: [String : Any]) {
//        isTyping = true
//        timer?.invalidate()
//        if #available(iOS 10.0, *) {
//            timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (_) in
//                self.isTyping = false
//            })
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//    
//    func messageReceived(_ data: [String:Any]) {
////        let recipient = (data["work_order_id"] as! [[String:String]]).first!
////        let chatMessage = [
////              "to_id": "",
////              "work_order_id": data["work_order_id"] as! String,
////              "message": data["message"] as! String]
//        let indexPaths = self.tblChat.indexPathsForVisibleRows?.sorted(by: { $0.row < $1.row })
////        chatHistory.append(chatMessage as AnyObject)
//        self.tblChat.reloadData()
//        guard let lastIndexPath = indexPaths?.last  else {
//            return
//        }
//        guard lastIndexPath.row == (isTyping ? chatHistory.count - 1 : chatHistory.count - 2) else {
//            return
//        }
//        self.tblChat.scrollToRow(at: IndexPath(row: lastIndexPath.row + 1, section: 0) , at: .bottom, animated: false)
//    }
//    
//  
//}

