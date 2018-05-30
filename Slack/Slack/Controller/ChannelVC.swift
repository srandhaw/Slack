//
//  ChannelVC.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 5/30/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        // Do any additional setup after loading the view.
    }

    

}
