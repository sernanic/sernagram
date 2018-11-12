//
//  cardTableViewCell.swift
//  sernagram
//
//  Created by Nicolas Serna on 11/11/18.
//  Copyright © 2018 ListFireqBase. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class cardTableViewCell: UIView {
    @IBInspectable var cornerRadius : CGFloat = 0.0
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOffsetWidth : Int = 0
    @IBInspectable var shadowOffsetHeight :Int = 1
    @IBInspectable var shadowOpacity : Float = 0.2
    
    override func layoutSubviews(){
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        var shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        
        layer.shadowRadius = 6
        
    }
    
    
}
