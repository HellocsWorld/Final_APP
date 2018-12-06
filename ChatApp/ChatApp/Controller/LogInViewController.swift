//
//  logInViewController.swift
//  ChatApp
//
//  Created by Raul Serrano on 11/27/18.
//  Copyright © 2018 Raul Serrano. All rights reserved.
//


import UIKit
import Firebase
import SVProgressHUD


class LogInViewController: UIViewController {
    
    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailfield: UITextField!
    @IBOutlet var passwordfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func logInPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailfield.text!, password: passwordfield.text!) {(user, error) in
            
            if error != nil {
                print(error!)
                
            }else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToProfile", sender: self)
                
            }
        }
        
        
    }
    
    
    
    
}

