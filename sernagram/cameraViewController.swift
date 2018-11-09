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
class cameraViewController: UIViewController {
    var selectedImage:UIImage?

    @IBOutlet weak var cameraImage: UIImageView!
    
    @IBOutlet weak var captionTextView: UITextView!
    
    @IBOutlet weak var shareOutlet: UIButton!
    
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
                newPostReference.setValue(["photoURL":cameraImageURL], withCompletionBlock: { (error, DatabaseReference) in
                    if error != nil{
                        ProgressHUD.showError(error?.localizedDescription)
                        return
                    }
                    ProgressHUD.showSuccess()
                })
               
            })
        }
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //we add touch functionality to the UIImage.This is how we start uploading images to firebase
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        cameraImage.addGestureRecognizer(tapGesture)
        cameraImage.isUserInteractionEnabled = true

        // Do any additional setup after loading the view.
    }
    //This is how we start uploading images to firebase
    @objc func handleSelectPhoto(){
        //this is how the photo library or image picker is presented
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    

}
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
