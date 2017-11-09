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
    
    var conversation = ["Hello","Hi.","How are you?","I'm doing great. What have you been upto these days?","Nothing much! Just the usual corporate work life.","Ohh I see. BTW why don't you visit us for a dinner or something with Sue and kids.","Yeah sure why not!","How does next Saturday Night sound to you.","Yeah will do, as long as Sue doesn't have any other plans for the night.","Sure, I'll even notify Aisha about it","Cool","Meet up soon.","Cya"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 119/255, blue: 0/255, alpha: 1)
        
        self.chatTextField.layer.cornerRadius = 6
        self.chatTextField.layer.masksToBounds = true
        self.chatTextField.layer.borderWidth = 1
        self.chatTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        self.tblChat.register(UINib(nibName: "OwnerTableViewCell", bundle: nil) , forCellReuseIdentifier: "OwnerTableViewCell")
        self.tblChat.register(UINib(nibName: "OtherUserTableViewCell", bundle: nil) , forCellReuseIdentifier: "OtherUserTableViewCell")
        self.tblChat.estimatedRowHeight = 40
        self.tblChat.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
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

}

extension ChatViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerTableViewCell", for: indexPath) as! OwnerTableViewCell
            cell.lblText.text = self.conversation[indexPath.row]
        return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherUserTableViewCell", for: indexPath) as! OtherUserTableViewCell
            cell.lblText.text = self.conversation[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
}

