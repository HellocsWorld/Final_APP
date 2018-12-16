//
//  NewContactViewController.swift
//  ChatApp
//
//  Created by Raul Serrano on 12/9/18.
//  Copyright © 2018 Raul Serrano. All rights reserved.
//
import UIKit
import Firebase
import SVProgressHUD


class NewContactViewController: UIViewController{
   
    
    
    @IBOutlet weak var contactEmail: UITextField!
    
    let user = ContactModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func addPressed(_ sender: AnyObject) {
        let checkifUserExistinDB = Database.database().reference().child("users")
        
        checkifUserExistinDB.queryOrdered(byChild: "email").queryEqual(toValue: self.contactEmail.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                for child in snapshot.children {
                    let snapshot2 = snapshot.childSnapshot(forPath: (child as AnyObject).key)
                    let value = snapshot2.value as? NSDictionary
                    self.user.name = value?["display_name"] as! String
                    self.user.email = value?["email"] as! String
                    if value?["profileURL"] != nil {
                         self.user.profImageUrl = value?["profileURL"] as! String
                    }
                   
                    self.user.id = value?["id"] as! String
                    let userID = Auth.auth().currentUser?.uid
                    let contactDB = Database.database().reference().child("users").child(userID!).child("Contact")
                    
                    let contactDictionaty = ["display_name": self.user.name, "email":  self.user.email, "contactID":  self.user.id, "profileURL": self.user.profImageUrl]
                    
                    contactDB.childByAutoId().setValue(contactDictionaty as [AnyHashable : Any], withCompletionBlock: {
                        (err, ref) in
                        if err != nil {
                            print(err!)
                            return
                        }
                        SVProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "backtocontact", sender: self)
                        print("Data Saved")
                    })
                }
            }
            else{
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Wrong user email", message: "there is no account with this email.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in return}))
                self.present(alert, animated: true)
                
            }
        })
        
    }
    
    
    
}

