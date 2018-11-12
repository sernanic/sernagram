//
//  ViewController.swift
//  sernagram
//
//  Created by Nicolas Serna on 10/22/18.
//  Copyright © 2018 ListFireqBase. All rights reserved.
//

import UIKit
import Firebase
class signInViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func signInAction(_ sender: UIButton) {
        UserDefaults.standard.set(emailTextfield.text, forKey: "username")
        if self.emailTextfield.text == "" || self.passwordTextfield.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTextfield.text!, password: self.passwordTextfield.text!) { (user, error) in
                
                if error == nil {
                    
            
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarViewController")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //userDefault checks to see if there is a username to remember
        userDefault()
    }
    func userDefault(){
        let nameObject = UserDefaults.standard.object(forKey: "username")
        if let username = nameObject as? String{
            emailTextfield.text = username
        }
    }
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

