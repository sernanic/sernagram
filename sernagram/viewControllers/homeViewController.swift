//
//  homeViewController.swift
//  sernagram
//
//  Created by Nicolas Serna on 10/22/18.
//  Copyright © 2018 ListFireqBase. All rights reserved.
//

import UIKit
import Firebase
class homeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableViewController: UITableView!
    var postArray = [Post]()
    
    //this function is required for tableviews
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    //this function is required for tableviews
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //this function reuses cells once they are gone off the screen
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //this displays the caption relative to the index path
        cell.textLabel?.text = postArray[indexPath.row].caption
        return cell
    }
    //this function retrieves information from the database
    func loadPosts(){
        //this is where we are looking for the data
        //.childAdded observes all existing data on the database and can get it for us
        let databaseref = Database.database().reference().child("post").observe(.childAdded) { (snapshot: DataSnapshot) in
            //the data retrieves are dictionaries so we want to declare a dictionary to store the data
            if let dict = snapshot.value as? [String:Any] {
                //this is how you grab the caption
                let captionText = dict["caption"] as! String
                let photoURL = dict["photoURL"] as! String
                let post = Post(captionText: captionText , photoURLString: photoURL )
               self.postArray.append(post)
                print(self.postArray)
                //this means we ask the tableview to display new data if there is any
                self.tableViewController.reloadData()
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewController.dataSource = self
        loadPosts()
        //Post is a model created by me found in the model folder named Post.swift
        //var post = Post(captionText: "test", photoURLString: "URL")
    }
    

   
}
