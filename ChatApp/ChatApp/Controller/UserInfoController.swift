
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
    var profImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
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
         profImage = image
        profileImage.image = profImage
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
    
    func getUserDictionary(uid: String, values: [String: AnyObject]){
        let profileDB = Database.database().reference().child("users").child(uid)
        profileDB.updateChildValues(values as [AnyHashable : Any], withCompletionBlock: {
            (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            self.performSegue(withIdentifier: "gotoContact", sender: self)
            print("Data Saved")
        })
        
    }
    
    //MARK: ~Save user Data to firebase
    @IBAction func SaveProfileData(_ sender: Any) {
       
        SVProgressHUD.show()
        
        if let userID = Auth.auth().currentUser?.uid{
            let imageName = "profileImage" + userID
          let storageRef = Storage.storage().reference().child(imageName + ".png")
        if let fileName = profImage!.pngData() {
            storageRef.putData(fileName, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    print(error!)
                    return
                }
                
                storageRef.downloadURL{ (url, error) in
                    guard let downloadURL = url else{
                        print(error!)
                        return
                    }
                    let urlString = downloadURL.absoluteString
                    let profileDictionaty = ["email": Auth.auth().currentUser?.email! as Any, "id": userID as Any, "display_name": self.displayNameLabel.text!, "birthdate": self.birthdateLabel.text!, "country": self.countryLabel.text!, "profileURL" : urlString] as [String : Any]
                    self.getUserDictionary(uid: userID, values: profileDictionaty as [String : AnyObject])
                }
                
                
            }
        }
       
        }else {
            return
        }
    }
    
}
