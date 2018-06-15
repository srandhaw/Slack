//
//  ChannelVC.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 5/30/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    //Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: CircleImage!
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_LOGIN, sender: self)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: Notification.Name("notifUserDataChanged"), object: nil)
    }
    
    @IBAction func prepareForUnwind(for x: UIStoryboardSegue ) {
        
    }
    
    @objc func userDataDidChange(_ notif: Notification){
        if(AuthService.instance.isLoggedIn){
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            let bgc = UserDataService.instance.avatarColor
            userImg.backgroundColor = UserDataService.instance.returnUIColor(component: bgc)
        }
        
    }

    

}
