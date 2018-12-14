//
//  profileViewController.swift
//  ChatApp
//
//  Created by Raul Serrano on 11/27/18.
//  Copyright © 2018 Raul Serrano. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {

    
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var ActiveConversationTableView: UITableView!
    @IBOutlet weak var displayName: UILabel!
    
    
    // Declare instance variables 
    var messageArray: [Message] = [Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
       // if Auth.auth().currentUser?.uid == nil {
            //sends the user to the welcome or root view controller
         //   navigationController?.popToRootViewController(animated: true)
       // }
        
        ActiveConversationTableView.delegate = self
        ActiveConversationTableView.dataSource = self
        
        //set display name
     //   getDisplayName()
        
       // ActiveConversationTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        configureTableView()
       // retrieveMessage()
        
        //delete lines on table
        ActiveConversationTableView.separatorStyle = .none
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MessageCell
        let message = messageArray[indexPath.row]
        let receiver = message.receiver
            let db = Database.database().reference().child("users").child(receiver)
        db.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary{
                cell.messageBody.text = self.messageArray.last!.messageBody
                cell.senderUsername.text = value["display_name"] as? String ?? ""
                cell.UserImageView.image = UIImage(named: "profile")
                cell.UserImageView.backgroundColor =  _ColorLiteralType(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
                cell.messageBackground.backgroundColor =  _ColorLiteralType(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)  //color literal
            }
            
            
        })
    
        
        return cell
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    func configureTableView(){
        ActiveConversationTableView.rowHeight = UITableView.automaticDimension
        ActiveConversationTableView.estimatedRowHeight = 120.0
    }
    
    
    
    /*func retrieveMessage(){
        
        let userID = Auth.auth().currentUser?.uid
        let messageDB = Database.database().reference().child("Messages").child(userID!)
        
        messageDB.observe(.childAdded) { (snapshot) in
            print(snapshot)
            let value = snapshot.value as? NSDictionary
            let text = value?["MessageBody"] as? String ?? ""
            let sender = value?["Sender"] as? String ?? ""
            let receiver = value?["receiver"] as? String ?? ""
            let date = value?["Date"] as? String ?? ""
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            message.receiver = receiver
            let dateFromDB = TimeInterval(date)
            let time = NSDate(timeIntervalSince1970: TimeInterval(dateFromDB!))
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let myString = formatter.string(from: time as Date)
            message.date = myString
            
            
            self.messageArray.append(message)
            
            self.configureTableView()
            self.ActiveConversationTableView.reloadData()
        }
        
    }*/
    
    func getDisplayName(){
        let userID = Auth.auth().currentUser
        if let user = userID {
            let uid = user.uid
            let nameFromDB = Database.database().reference().child("users").child(uid)
            
            nameFromDB.observe(.childAdded, with: {(snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let name = value?["display_name"] as? String ?? ""
                print(name)
                self.displayName.text = name
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        
//        observe(.childAdded) { (snapshot) in
//            let snapshotValue = snapshot.value as! Dictionary<String, String>
//            let name = snapshotValue["display_name"]!
//            print(name)
//            self.displayName.text = name
      // }
    }
    
    
    
    @IBAction func signOutPressed(_ sender: AnyObject) {
        
        //Mark: ~ try catch logout
        do {
            try Auth.auth().signOut()
            
            //sends the user to the welcome or root view controller
            navigationController?.popToRootViewController(animated: true)
        } catch let error as NSError
        {
            print (error.localizedDescription)
        }
    }
    
}
