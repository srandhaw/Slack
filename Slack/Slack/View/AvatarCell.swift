//
//  AvatarCell.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 6/13/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    
    
}
