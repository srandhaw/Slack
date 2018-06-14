//
//  AvatarCell.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 6/13/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

enum AvatarType{
    case light
    case dark
}

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    func configureCell(index: Int,type: AvatarType){
        if(type==AvatarType.dark){
            self.layer.backgroundColor = UIColor.lightGray.cgColor
            avatarImg.image = UIImage(named: "dark\(index)")
        }
        else{
            self.layer.backgroundColor = UIColor.darkGray.cgColor
            avatarImg.image = UIImage(named: "light\(index)")
        }
    }
    
    
    
}
