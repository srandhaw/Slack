//
//  CircleImage.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 6/14/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
    }

}
