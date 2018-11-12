//
//  Post.swift
//  sernagram
//
//  Created by Nicolas Serna on 11/10/18.
//  Copyright © 2018 ListFireqBase. All rights reserved.
//

import Foundation
class Post {
    var caption: String?
    var photoURL: String?
    var videoURL: String?
    
}
//a more elegant way of assigning thins to post
extension Post{
    func transFormPost(dict:[String:Any]) -> Post{
        let post = Post()
        //this is how you grab the caption
        post.caption = dict["caption"] as? String
        post.photoURL = dict["photoURL"] as? String
        return post
    }
}
