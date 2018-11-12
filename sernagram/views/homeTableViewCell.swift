//
//  homeTableViewCell.swift
//  sernagram
//
//  Created by Nicolas Serna on 11/11/18.
//  Copyright © 2018 ListFireqBase. All rights reserved.
//

import UIKit

class homeTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var postImgView: UIImageView!
    
    @IBOutlet weak var likeOutlet: UIButton!
    @IBOutlet weak var commentOutlet: UIButton!
    @IBOutlet weak var shareOutlet: UIButton!
    
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    func updateView(post:Post){
        profileImg.image = UIImage(named: "photo1.jpeg")
        nameLabel.text = "Nicolas"
        //we are getting the string URL from firebase database
        if let photoURLString = post.photoURL{
            //we convert the string into a URL
            let photoURL = URL(string: photoURLString)
            //this will download and display the photo from firebase database used from SDWebImage pod
            postImgView.sd_setImage(with: photoURL)
        }
        //in order to have no constraint and make captions as long as possible switch the number of lines to 0 in the identity inspector
        captionLabel.text = post.caption
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
