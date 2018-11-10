//
//  signUpViewController.swift
//  sernagram
//
//  Created by Nicolas Serna on 10/22/18.
//  Copyright © 2018 ListFireqBase. All rights reserved.
//

import UIKit
import Firebase
class signUpViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var emailtextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    var selectedImage:UIImage?
    @IBAction func signUpAction(_ sender: UIButton) {
        if emailtextfield.text == ""{
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }else{
        Auth.auth().createUser(withEmail: emailtextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error == nil {
                let uid = user?.uid
                ////////////////////////////////////////////////////////////////////////////////////////////////
                //this is how an account witha profile image is done
                let storageRef = Storage.storage().reference().child("profile_images").child(uid!)
                //we convert the picture to a jpeg format for firebase storage
                if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1) {
                    //upload the data to firebase Storage
                    storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                        if error != nil{
                            return
                        }
                        //we will extract the url where our data lives with and convert it to a string in order to add it to the database
                        let profileImageURL = metadata?.downloadURL()?.absoluteString
                        let databaseRef = Database.database().reference()
                        let userRef = databaseRef.child("users")
                        
                        //this is created every time a user is created
                        let newUserReference = userRef.child(uid!)
                        //this is how you record values to the database
                        newUserReference.setValue(["username": self.usernameTextfield.text,"email":self.emailtextfield.text,"password":self.passwordTextfield.text,"profileImageURL":profileImageURL])
                    })
                }
                /////////////////////////////////////////////////////////////////////////////////////////////////
                //this is how it is done without a profile Image
                
                //            let databaseRef = Database.database().reference()
                //            let userRef = databaseRef.child("users")
                //
                //            //this is created every time a user is created
                //            let newUserReference = userRef.child(uid!)
                //            //this is how you record values to the database
                //            newUserReference.setValue(["username": self.usernameTextfield.text,"email":self.emailtextfield.text,"password":self.passwordTextfield.text])
                //this switches to the next viewcontroller
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarViewController")
                self.present(vc!, animated: true, completion: nil)
                
            }//if there is an error
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
 
            
        }
        
    }
}
    //go from signUp view to sign in view
    @IBAction func returnToLogIn(_ sender: UIButton) {
       dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //this is how you make an imageview circular
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        //this is how we create an action when th image view is tapped more specifically when an outlet is tapped
        //this goes with the extension below
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true

    }
    //we want to present a photo libary when outlet(image view) is touched
    @objc func handleSelectProfileImage(){
        //this is how the photo library or image picker is presented
        let pickerController = UIImagePickerController()
         pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }//the end of creating an action when imageview is tapped
    

    //touch outside the keyboard in order to end keyboard
    //remember to use UITextFieldDelegate up top
    //remember to connect text field to  delegate in little yellow button
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //    touch return in the keyboard in order to end keyboard
    //remember to use UITextFieldDelegate up top
    //remember to connect text field to  delegate in little yellow button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
//extension for picking an image for the profile image
extension signUpViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //dismiss picker control when desired
        dismiss(animated: true, completion: nil)
        //this is how we can extract the actual photo from the imagePicker
        
        if let image = info[.originalImage] as? UIImage{
            //now we will send the image to firebase storage
            //we are going to store all media files to firebase storage and link them to firebase database
            selectedImage = image
            //we set the image of the uiimage view to the image picked
            profileImage.image = selectedImage
        }
        
    }
}

