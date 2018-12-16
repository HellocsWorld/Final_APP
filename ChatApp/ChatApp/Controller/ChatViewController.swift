//
//  chatViewController.swift
//  ChatApp
//
//  Created by Raul Serrano on 11/27/18.
//  Copyright © 2018 Raul Serrano. All rights reserved.
//

import UIKit
import Firebase


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    //variables
    var messageArray: [Message] = [Message]()
    var toID: String = ""
    var name: String = ""
    var profimageURL: String = ""
    
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        messageTextfield.delegate = self
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        configureTableView()
        retrieveMessage()
        self.navigationItem.title = name
        
        messageTableView.separatorStyle = .none
        
    }
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MessageCell
        let db = Database.database().reference().child("users").child(messageArray[indexPath.row].sender)
        db.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary{
                cell.senderUsername.text = value["display_name"] as? String ?? ""
            }
         })
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        //cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.timeStamp.text = messageArray[indexPath.row].date
        cell.UserImageView.image = UIImage(named: "profile")
        //********this is the code for profile imaage it workes but it is slow****
//        if profimageURL == "" {
//           cell.UserImageView.image = UIImage(named: "profile")
//        }else {
//            let url = NSURL(string: profimageURL)
//            let data = try? Data(contentsOf: url! as URL)
//            if let imageData = data {
//                let image = UIImage(data: imageData)
//                cell.UserImageView.image = image
//            }
//        }
        if   messageArray[indexPath.row].receiver == toID{
            //Message we sent
            cell.UserImageView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            cell.messageBackground.backgroundColor = #colorLiteral(red: 0.1529411765, green: 0.6823529412, blue: 0.3764705882, alpha: 1)
        }else{
            cell.UserImageView.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            cell.messageBackground.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        }
        
        return cell
    }
    
    // number of rows
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    
    
    func configureTableView(){
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    
    //Declare textFieldDidBeginEditing here:
    //the keyboard is 258 + 50 of the message box = 308
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 358
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    //textFieldDidEndEditing
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    //MARK: - Send & Recieve from Firebase
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
        //Send the message to Firebase and save it in our database
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        let timestamp = NSDate().timeIntervalSince1970
        let userID = Auth.auth().currentUser?.uid
       // let messageID = toID + userID!
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionaty = ["Sender": userID, "receiver": toID, "MessageBody": messageTextfield.text!, "Date": String(timestamp)]
        
        messagesDB.childByAutoId().setValue(messageDictionaty as [AnyHashable : Any], withCompletionBlock: {
            (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            print("Data Saved")
            self.messageTextfield.isEnabled = true
            self.sendButton.isEnabled = true
            self.messageTextfield.text = ""
        })
    }
    
    // message retreiver
   func retrieveMessage(){
        let userID = Auth.auth().currentUser?.uid
    // let messageID = toID + userID!
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let text = value?["MessageBody"] as? String ?? ""
            let sender = value?["Sender"] as? String ?? ""
            let receiver = value?["receiver"] as? String ?? ""
            let date = value?["Date"] as? String ?? ""
            
            if receiver == self.toID || sender == self.toID && sender == userID || receiver == userID{
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
              print("Time Here: " + myString)
            
              self.messageArray.append(message)
            
              self.configureTableView()
              self.messageTableView.reloadData()
            }
            
        })
         { (error) in
            print(error.localizedDescription)
        }
    
    }
    
    
    
}

