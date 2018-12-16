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
    
    var validEmail: Bool = false
    
    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailfield: UITextField!
    @IBOutlet var passwordfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func logInPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailfield.text!, password: passwordfield.text!) {(user, error) in
            
            if user != nil {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "gotoContact", sender: self)
                
            }else {
                print(error!)
                
            }
        }
        
        
    }
    
    //CHECKEMAIL: ~check if email is valid
    @IBAction func doneEditingEmail(_ sender: Any) {
        if !emailfield.text!.isEmpty {
            validEmail = isValidEmail(testStr: emailfield.text!)
            print(validEmail)
        } else{
            let alert = UIAlertController(title: "Empty Email", message: "Your Email cannot be empty.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
        if validEmail != true {
            let alert = UIAlertController(title: "Invalid email", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    //Mark: ~check password
    @IBAction func passwordChanged(_ sender: Any) {
        if passwordfield.text!.count > 5 && validEmail == true {
            loginButton.isEnabled = true
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
}

