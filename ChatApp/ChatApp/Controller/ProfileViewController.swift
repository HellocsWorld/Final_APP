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
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet weak var displayNameTitle: UINavigationItem!
    @IBOutlet weak var contactTableView: UITableView!
    
    
    // Declare instance variables here
    var messageArray: [Message] = [Message]()
    
   
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        contactTableView.delegate = self
        contactTableView.dataSource = self
        
        
        contactTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        configureTableView()
        retrieveMessage()
        
        //delete lines on table
        contactTableView.separatorStyle = .none
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! ContactCell
        
        cell.messageBody.text = messageArray.last!.messageBody
        cell.senderUsername.text = messageArray.last!.sender
        cell.UserImageView.image = UIImage(named: "profile")
        
        if cell.senderUsername.text != Auth.auth().currentUser?.email {
            cell.UserImageView.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            cell.messageBackground.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)  //color literal
        }
        
        return cell
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    func configureTableView(){
        contactTableView.rowHeight = UITableView.automaticDimension
        contactTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
 /*
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
        
    }*/
    
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
  /*
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
        
        //TODO: Send the message to Firebase and save it in our database
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = Database.database().reference().child("Messages")
        
        let messageDictionaty = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text!]
        
        //save message dictionary to database
        messagesDB.childByAutoId().setValue(messageDictionaty) {
            (error, reference) in
            if error != nil{
                print(error!)
            }else {
                print("Message Saved")
            }
            self.messageTextfield.isEnabled = true
            self.sendButton.isEnabled = true
            self.messageTextfield.text = ""
        }
    } */
    
    func retrieveMessage(){
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            
            self.configureTableView()
            self.contactTableView.reloadData()
        }
    }
    
    
    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //Mark: ~ try catch logout
        do {
            try Auth.auth().signOut()
            
            //send the user to the welcome or root view controller
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("error, while signing out")
        }
    }
    

}
