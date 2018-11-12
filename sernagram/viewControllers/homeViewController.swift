//
//  homeViewController.swift
//  sernagram
//
//  Created by Nicolas Serna on 10/22/18.
//  Copyright © 2018 ListFireqBase. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
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
        //in this instace we most specify we are using a costum cell named homeTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! homeTableViewCell
        let post = postArray[indexPath.row]
        //the following was put in a function located in homeTableViewCell in order to have MVC
//         cell.profileImg.image = UIImage(named: "photo1.jpeg")
//        cell.nameLabel.text = "Nicolas"
//        if let photoURLString = post.photoURL{
//            let photoURL = URL(string: photoURLString)
//            cell.postImgView.sd_setImage(with: photoURL)
//        }
//        cell.captionLabel.text = post.caption
        cell.updateView(post: post)
        return cell
    }
    //this function retrieves information from the database
    func loadPosts(){
        //this is where we are looking for the data
        //.childAdded observes all existing data on the database and can get it for us
        let databaseref = Database.database().reference().child("post").observe(.childAdded) { (snapshot: DataSnapshot) in
            //the data retrieves are dictionaries so we want to declare a dictionary to store the data
            if let dict = snapshot.value as? [String:Any] {
                //must always declare a variable to represent model
                let instancePost = Post()
                let newpost = instancePost.transFormPost(dict: dict)
                //transformPost is a better way to do this assigning
//                post.caption = dict["caption"] as? String
//                post.photoURL = dict["photoURL"] as? String
               self.postArray.append(newpost)
                print(self.postArray)
                //this means we ask the tableview to display new data if there is any
                self.tableViewController.reloadData()
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewController.dataSource = self
        //tableViewController.estimatedRowHeight = 521
        //this makes it possible to dynamically adjust it's height to the content
        //tableViewController.rowHeight = UITableView.automaticDimension
        loadPosts()
        //Post is a model created by me found in the model folder named Post.swift
        //var post = Post(captionText: "test", photoURLString: "URL")
    }
    

   
}
