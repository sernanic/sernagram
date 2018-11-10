//
//  profileViewController.swift
//  sernagram
//
//  Created by Nicolas Serna on 11/5/18.
//  Copyright © 2018 ListFireqBase. All rights reserved.
//

import UIKit
import Firebase
class profileViewController: UIViewController {
    @IBAction func logOutButton(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
        }catch let logOutError{
            print(logOutError.localizedDescription)
        }
        //this is how you return to the sign in view
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "signInViewController")
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
}
