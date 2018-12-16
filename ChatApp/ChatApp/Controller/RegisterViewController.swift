//
//  RedisterViewController.swift
//  ChatApp
//
//  Created by Raul Serrano on 11/27/18.
//  Copyright © 2018 Raul Serrano. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    var validEmail: Bool = false
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.isEnabled = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func registerPressed() {
   
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Duplicate Email", message: "there is already an account with this email perhaps you meant to log in.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.performSegue(withIdentifier: "goToWelcome", sender: self)}))
                self.present(alert, animated: true)
                SVProgressHUD.dismiss()
                   
            }
            
        }
        self.performSegue(withIdentifier: "goToUserInfo", sender: self)
        SVProgressHUD.dismiss()
    }
    
   //CHECKEMAIL: ~check if email is valid
    @IBAction func doneEditingEmail(_ sender: Any) {
        if !emailField.text!.isEmpty {
            validEmail = isValidEmail(testStr: emailField.text!)
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
        if passwordField.text!.count > 5 && validEmail == true {
            registerButton.isEnabled = true
        }
    }


    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
