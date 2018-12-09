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
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var displayName: UILabel!
    
    
    // Declare instance variables 
    var messageArray: [Message] = [Message]()
    
   
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        contactTableView.delegate = self
        contactTableView.dataSource = self
        
        //set display name
        getDisplayName()
        
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
    
    func getDisplayName(){
        let nameFromDB = Database.database().reference().child("profile")
        
        nameFromDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let name = snapshotValue["display_name"]!
            print(name)
            self.displayName.text = name
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
