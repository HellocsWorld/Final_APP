//
//  ContactViewController.swift
//  ChatApp
//
//  Created by Raul Serrano on 12/9/18.
//  Copyright © 2018 Raul Serrano. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    
    @IBOutlet weak var contactTable: UITableView!
    
    var contactArray: [ContactModel] = [ContactModel]()
    var toID:String = ""
    var name: String = ""
    var profImageURL: String = ""
    var profURL: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
     //   let newBackButton = UIBarButtonItem(title: "log out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(signOutPressed(sender:)))
     //   navigationItem.leftBarButtonItem = newBackButton


            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
             imageView.layer.cornerRadius = imageView.frame.size.width/2
             imageView.clipsToBounds = true
             imageView.contentMode = .scaleAspectFit
             let image = UIImage(named: "profile")
             imageView.image = image
             navigationItem.titleView = imageView
        
        contactTable.delegate = self
        contactTable.dataSource = self
        
        contactTable.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "customContactCell")
        getDisplayName()
        
        //delete lines on table
        contactTable.separatorStyle = .none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messages" {
                let controller = segue.destination as! ChatViewController
            controller.toID = toID
            controller.profimageURL = profImageURL
            controller.name = name
            

        }
    }
    
   @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customContactCell", for: indexPath) as! ContactCell
        
        cell.ContactName.text = contactArray[indexPath.row].name
        cell.contactImageView.image = UIImage(named: "profile")
        cell.contactImageView.image = UIImage(named: "profile")
//        let profileURL = contactArray[indexPath.row].profImageUrl
//        
//        if profileURL == "" {
//            
//        }else {
//            let url = NSURL(string: profileURL)
//            let data = try? Data(contentsOf: url! as URL)
//            if let imageData = data {
//                let image = UIImage(data: imageData)
//                cell.contactImageView.image = image
//            }
//        }
       
        
        
            cell.contactImageView.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1) //color literal
        
        return cell
    }
    
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            toID = contactArray[indexPath.row].id
            profImageURL = contactArray[indexPath.row].profImageUrl
            self.performSegue(withIdentifier: "messages", sender: self)
    }
    
    
    //MARK: ~get contact names and info 
    func getDisplayName(){
        SVProgressHUD.show()
        if let userID = Auth.auth().currentUser?.uid {
            let nameFromDB = Database.database().reference().child("users").child(userID).child("Contact")
        
          nameFromDB.observe(.childAdded, with: {(snapshot) in
            // Get user value
            if let value = snapshot.value as? NSDictionary{
                self.name = value["display_name"] as? String ?? ""
                let email = value["email"] as? String ?? ""
                let id = value["contactID"] as? String ?? ""
                let profUrl = value["profileURL"] as? String ?? ""
                print(profUrl)
                let contact = ContactModel()
                contact.name = self.name
                contact.email = email
                contact.id = id
                contact.profImageUrl = profUrl
                self.contactArray.append(contact)
                self.contactTable.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
       SVProgressHUD.dismiss()
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
//    @objc func signOutPressed(sender: UIBarButtonItem) {
//
//        //Mark: ~ try catch logout
//        let userDefaults = UserDefaults.standard
//        if userDefaults.value(forKey: "appFirstTimeOpend") == nil {
//            //if app is first time opened then it will be nil
//            userDefaults.setValue(true, forKey: "appFirstTimeOpend")
//            // signOut from FIRAuth
//            do {
//                try Auth.auth().signOut()
//            }catch let error as NSError
//            {
//                print (error.localizedDescription)
//            }
//             navigationController?.popToRootViewController(animated: true)
//            // go to beginning of app
//        } else {
//            //go to where you want
//        }
//
//        do {
//            try Auth.auth().signOut()
//
//            //sends the user to the welcome or root view controller
//            navigationController?.popToRootViewController(animated: true)
//        } catch let error as NSError
//        {
//            print (error.localizedDescription)
//        }
//    }
}
