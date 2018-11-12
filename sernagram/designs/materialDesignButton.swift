//
//  materialDesignButton.swift
//  sernagram
//
//  Created by Nicolas Serna on 11/10/18.
//  Copyright © 2018 ListFireqBase. All rights reserved.
//

import UIKit

@IBDesignable class materialDesignButton: UIButton {

    //adjust the cornerRadius
    //in order to make it a circle grab height and divde by 2
    @IBInspectable var cornerRadius: Float = 0 {
        didSet {
            self.layer.cornerRadius = CGFloat(cornerRadius)
        }
        
    }
    //this will get the shadow to show up
    //set it to 0.25
    @IBInspectable var shadowOpacity: Float = 0.25  {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
        
    }
    //adjust shadowRadius to 5
    @IBInspectable var shadowRadius: Int = 5  {
        didSet {
            self.layer.shadowRadius = CGFloat(shadowRadius)
        }
        
    }
    //adjust the position of a shadow
    //shoud start at (0,10)
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 10)  {
        didSet {
            self.layer.shadowOffset = shadowOffset
        }

    }
}
