//
//  GradientView.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 5/30/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var topColor = #colorLiteral(red: 0.3631127477, green: 0.4045833051, blue: 0.8775706887, alpha: 1){
        didSet{
            self.setNeedsLayout()
        }
    }

    @IBInspectable var bottomColor = #colorLiteral(red: 0.3942383528, green: 0.8946506381, blue: 0.9545024037, alpha: 1){
        didSet{
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    

}
