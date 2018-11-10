//
//  Post.swift
//  sernagram
//
//  Created by Nicolas Serna on 11/10/18.
//  Copyright © 2018 ListFireqBase. All rights reserved.
//

import Foundation
class Post {
    var caption: String
    var photoURL: String
    init(captionText:String,photoURLString:String) {
        caption = captionText
        photoURL = photoURLString
    }
}
