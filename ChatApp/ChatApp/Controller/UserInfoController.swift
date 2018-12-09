
//
//  UserInfoController.swift
//  ChatApp
//
//  Created by Raul Serrano on 11/30/18.
//  Copyright © 2018 Raul Serrano. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class UserInfoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
 
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UITextField!
    @IBOutlet weak var birthdateLabel: UITextField!
    @IBOutlet weak var countryLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
        self.profileImage.clipsToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
        let addfromCamera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCameraButton()
            
        }
        
        let addfromLibrary = UIAlertAction(title: "library", style: .default) { _ in
            self.openPhotoLibraryButton()
            
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        
        alert.addAction(addfromCamera)
        alert.addAction(addfromLibrary)
        alert.addAction(cancelAction)
            
       present(alert, animated: true)
    }
    
    //Mark: ~add image from Camera
  func openCameraButton() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
//Mark: ~add image from library
  func openPhotoLibraryButton() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
   
    
 func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {print("HERE: ",
            Error.self)
            return}
        profileImage.image = image
        self.dismiss(animated:true, completion: nil)
    }
    
    //Mark: ~ texfield listener
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    //MARK: ~Save user Data to firebase
    @IBAction func SaveProfileData(_ sender: Any) {
        SVProgressHUD.show()
        let profileDB = Database.database().reference().child("profile")
        
        let profileDictionaty = ["display_name": displayNameLabel.text!, "birthdate": birthdateLabel.text!, "country": countryLabel.text!]
        
        //save message dictionary to database
        profileDB.childByAutoId().setValue(profileDictionaty) {
            (error, reference) in
            if error != nil{
                print(error!)
                return
            }else {
                print("user info saved")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToProfile", sender: self)
            }
      
        }
        
        
    }
    
}
