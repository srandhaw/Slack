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
    @IBOutlet weak var messageTxt: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
        self.messageTxt.isHidden = false
        self.sendBtn.isHidden = false
        
        messageTxt.attributedPlaceholder = NSAttributedString(string: "message", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.423529923, green: 0.6870478392, blue: 0.8348321319, alpha: 1)])
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: Notification.Name("channelSelected"), object: nil)
        
      // AuthService.instance.isLoggedIn = false
        
       if(AuthService.instance.isLoggedIn){
        
            AuthService.instance.findUserByEmail(completion: { (success) in
                if(success){
                    NotificationCenter.default.post(name: Notification.Name("notifUserDataChanged"), object: nil)
                    MessageService.instance.findAllChannels(completion: { (success) in

                        if(success){
                            if(MessageService.instance.channels.count>0){
                                MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                                self.channelNameLbl.text = MessageService.instance.selectedChannel?.channelTitle
                            }
                            else{
                                self.channelNameLbl.text = "You do not have any channels yet!"
                                self.messageTxt.isHidden = true
                                self.sendBtn.isHidden = true
                            }

                        }
                        
                        MessageService.instance.clearChannels()
                    })
                
                    print("\n\n\(MessageService.instance.channels.count)\n")
                }
                
            })
        }
       else{
        channelNameLbl.text = "Please Log In!"
        self.messageTxt.isHidden = true
        self.sendBtn.isHidden = true
        }
        
       
        
    }
    
    @objc func channelSelected(_ notif: Notification){
        if(AuthService.instance.isLoggedIn){
        channelNameLbl.text = MessageService.instance.selectedChannel?.channelTitle
        self.messageTxt.isHidden = false
        self.sendBtn.isHidden = false
        }
        else{
            channelNameLbl.text = "Please Log In!"
            self.messageTxt.isHidden = true
            self.sendBtn.isHidden = true
        }
        
    }

    @IBAction func sendBtnPressed(_ sender: Any) {
        if(AuthService.instance.isLoggedIn){
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            guard let messageBody = messageTxt.text else { return }
            
            SocketService.instance.addMessage(messageBody: messageBody, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
                if(success){
                    self.messageTxt.text = ""
                    self.messageTxt.resignFirstResponder()
                }
            })
        }
        
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
  

   

}
