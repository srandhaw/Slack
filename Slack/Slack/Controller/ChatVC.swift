//
//  ChatVC.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 5/30/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: Notification.Name("channelSelected"), object: nil)
        
       if(AuthService.instance.isLoggedIn){
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: Notification.Name("notifUserDataChanged"), object: nil)
                
            })
        }
       else{
        channelNameLbl.text = "Please Log In!"
        }
        
       
        
    }
    
    @objc func channelSelected(_ notif: Notification){
        channelNameLbl.text = MessageService.instance.selectedChannel?.channelTitle
        
    }

   
  

   

}
