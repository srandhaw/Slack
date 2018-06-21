//
//  ChatVC.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 5/30/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Variable
    var isTyping = false

    //Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxt: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var typingUsersLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        sendBtn.isHidden = true
        
        //dynamic tableview height
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
        SocketService.instance.getMessage { (newMessage) in
            if(newMessage.channelID == MessageService.instance.selectedChannel?.id){
                MessageService.instance.messages.append(newMessage)
                self.tableView.reloadData()
               
                if(MessageService.instance.messages.count>0){
                    let endIndex = IndexPath(row: MessageService.instance.messages.count-1, section: 0)
                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
                }
                
            }
        }
        
       
        
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
           
            var names = ""
            var number = 0
            
            for (name, channel) in typingUsers{
                if(name != UserDataService.instance.name && channel == channelId){
                    if(number == 0){
                        names = name
                    }
                    else {
                        names = "\(names), \(name)"
                    }
                    number += 1
                }
                
            }
            
            if(number>0 && AuthService.instance.isLoggedIn){
                
                if(number == 1){
                    self.typingUsersLabel.text = "\(names) is typing..."
                    
                }
                 else if(number>1){
                    self.typingUsersLabel.text = "\(names) are typing..."
                }
                else{
                    self.typingUsersLabel.text = ""
                }
                
                
            }
            else{
                self.typingUsersLabel.text = ""
            }
        }
        
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
                                MessageService.instance.findAllMessagesForChannel(channelId: (MessageService.instance.selectedChannel?.id)!, completion: { (success) in
                                    if(success){
                                        self.tableView.reloadData()
                                    }
                                })
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
    
    override func viewDidAppear(_ animated: Bool) {
        sendBtn.isHidden = true
    }
    
    @objc func channelSelected(_ notif: Notification){
        if(AuthService.instance.isLoggedIn){
        channelNameLbl.text = MessageService.instance.selectedChannel?.channelTitle
        self.messageTxt.isHidden = false
        self.sendBtn.isHidden = false
        tableView.reloadData()
        }
        else{
            channelNameLbl.text = "Please Log In!"
            self.messageTxt.isHidden = true
            self.sendBtn.isHidden = true
        }
        sendBtn.isHidden = true
    }

    @IBAction func sendBtnPressed(_ sender: Any) {
        if(AuthService.instance.isLoggedIn){
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            guard let messageBody = messageTxt.text else { return }
            
            SocketService.instance.addMessage(messageBody: messageBody, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
                if(success){
                    self.messageTxt.text = ""
                    self.messageTxt.resignFirstResponder()
                    SocketService.instance.manager.defaultSocket.emit("stopType", UserDataService.instance.name, (MessageService.instance.selectedChannel?.id)!)
                }
            })
        }
        
    }
    
    @IBAction func messageBoxEditing(_ sender: Any) {
        if(messageTxt.text==""){
            isTyping = false
            sendBtn.isHidden = true
            SocketService.instance.manager.defaultSocket.emit("stopType", UserDataService.instance.name, (MessageService.instance.selectedChannel?.id)!)
        }
        else{
            sendBtn.isHidden = false
            isTyping = true
            SocketService.instance.manager.defaultSocket.emit("startType", UserDataService.instance.name, (MessageService.instance.selectedChannel?.id)!)
        }
        
    }
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    //tableView functions
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell{
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        }
        else{
        return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

   

}
