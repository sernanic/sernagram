//
//  cameraViewController.swift
//  sernagram
//
//  Created by Nicolas Serna on 11/8/18.
//  Copyright © 2018 ListFireqBase. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
class cameraViewController: UIViewController,UITextFieldDelegate {
    var selectedImage:UIImage?

    @IBOutlet weak var cameraImage: UIImageView!
    
    @IBOutlet weak var captionTextView: UITextView!
    
    @IBOutlet weak var shareOutlet: UIButton!
    
    @IBOutlet weak var removeOutlet: UIBarButtonItem!
    
    @IBAction func shareButton(_ sender: UIButton) {
        //we are going to push selecteImage to storage in firebase

        
        if let cameraImg = self.selectedImage, let imageData = cameraImg.jpegData(compressionQuality: 0.1) {
            //NSUUID().uuidString provides a random generated ID for the photo
            let photoIDString = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("post").child(photoIDString)
            //upload the data to firebase Storage
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    return
                }
                //we will extract the url where our data lives with and convert it to a string in order to add it to the database
                let cameraImageURL = metadata?.downloadURL()?.absoluteString
                //first we get the location of the database
                let dataBaseRef = Database.database().reference()
                //we the create a root directory to reference all the post
                let postRef = dataBaseRef.child("post")
                //create a string id for each new post on the database
                //childByAutoId generates a random id for the child and the key produces a relative path
                let newPostId = postRef.childByAutoId().key
                let newPostReference = postRef.child(newPostId)
                //remember that this setValue has a completionHandler, but you can use the setValue alone, completionHandler is a small function that is preformed
                newPostReference.setValue(["photoURL":cameraImageURL,"caption":self.captionTextView.text], withCompletionBlock: { (error, DatabaseReference) in
                    if error != nil{
                        ProgressHUD.showError(error?.localizedDescription)
                        return
                    }
                    ProgressHUD.showSuccess()
                    //after we successfully put this in firebase we set the place holders to there initial form again
                    self.captionTextView.text = ""
                    //this specifies the photo in the assets is the photo we desire
                    self.cameraImage.image = UIImage(named: "placeholder-photo")
                    //we reset the selectedImage to nothing so handlePost's button color can become disabled and gray
                    self.selectedImage = nil
                    //this takes us to the homeViewcontroller once the action is done (there are 5 items and each item is indexed from 0 th 4 from left to right)
                    self.tabBarController?.selectedIndex = 0
                })
               
            })//end of putData
        }
}//end of shareButton
    @IBAction func removeAction(_ sender: UIBarButtonItem) {
        self.captionTextView.text = ""
        //this specifies the photo in the assets is the photo we desire
        self.cameraImage.image = UIImage(named: "placeholder-photo")
        //we reset the selectedImage to nothing so handlePost's button color can become disabled and gray
        self.selectedImage = nil
        handlePost()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //we add touch functionality to the UIImage.This is how we start uploading images to firebase
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        cameraImage.addGestureRecognizer(tapGesture)
        cameraImage.isUserInteractionEnabled = true

    }//every time the view appears we take into consideration handlePost()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    //we don't allow post that do not have a picture
    func handlePost(){
        if selectedImage != nil {
            self.shareOutlet.isEnabled = true
            self.removeOutlet.isEnabled =  true
            self.shareOutlet.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else{
            self.shareOutlet.isEnabled = false
            self.removeOutlet.isEnabled =  false
            self.shareOutlet.backgroundColor = .lightGray
        }
    }
    //This is how we start uploading images to firebase
    @objc func handleSelectPhoto(){
        //this is how the photo library or image picker is presented
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    
    //touch outside the keyboard in order to end keyboard
    //remember to use UITextFieldDelegate up top
    //remember to connect text field to  delegate in little yellow button
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //touch return in the keyboard in order to end keyboard
    //remember to use UITextFieldDelegate up top
    //remember to connect text field to  delegate in little yellow button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
//pickerController
extension cameraViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //dismiss picker control when desired
        dismiss(animated: true, completion: nil)
        //this is how we can extract the actual photo from the imagePicker
        
        if let image = info[.originalImage] as? UIImage{
            //now we will send the image to firebase storage
            //we are going to store all media files to firebase storage and link them to firebase database
            selectedImage = image
            //we set the image of the uiimage view to the image picked
            cameraImage.image = selectedImage
        }
        
    }
}
