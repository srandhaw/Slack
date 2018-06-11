//
//  RoundedButton.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 6/11/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = 5
    }

}
