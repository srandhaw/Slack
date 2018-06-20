//
//  ChannelVC.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 5/30/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate,UITableViewDataSource {

    //Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var tableView: UITableView!
    
        override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: Notification.Name("notifUserDataChanged"), object: nil)
            
            NotificationCenter.default.post(name: Notification.Name("notifUserDataChanged"), object: nil)
            
            
        SocketService.instance.getChannel { (success) in
            
            if(success){
                self.tableView.reloadData()
            }
        }
            
            SocketService.instance.getMessage { (newMessage) in
                if(newMessage.channelID != MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn){
                    MessageService.instance.unreadChannels.append(newMessage.channelID)
                    self.tableView.reloadData()
                }
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(AuthService.instance.isLoggedIn){
            
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            let bgc = UserDataService.instance.avatarColor
            userImg.backgroundColor = UserDataService.instance.returnUIColor(component: bgc)
           
           
            
        }
        else{
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            AuthService.instance.isLoggedIn = false
            MessageService.instance.clearChannels()
            self.tableView.reloadData()
           
        }
        
        
     
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if(AuthService.instance.isLoggedIn){
            let profile = ProfileVCViewController()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        }
        else{
            performSegue(withIdentifier: TO_LOGIN, sender: self)
        }
    }
    
    @IBAction func prepareForUnwind(for x: UIStoryboardSegue ) {
        
    }
    
    @IBAction func addChannelBtnPressed(_ sender: Any) {
        if(AuthService.instance.isLoggedIn){
        let channel = AddChannelVC()
        channel.modalPresentationStyle = .custom
        present(channel, animated: true, completion: nil)
        }
    }
    
    
    @objc func userDataDidChange(_ notif: Notification){
        if(AuthService.instance.isLoggedIn){
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            let bgc = UserDataService.instance.avatarColor
            userImg.backgroundColor = UserDataService.instance.returnUIColor(component: bgc)
            NotificationCenter.default.post(name: Notification.Name("channelSelected"), object: nil)
            
            MessageService.instance.findAllChannels(completion: { (success) in
                if(success){
                    self.tableView.reloadData()
                }
            })
            }
        else{
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            AuthService.instance.isLoggedIn = false
            MessageService.instance.clearChannels()
            tableView.reloadData()
            
        }
        
        
        
        
        
    }
    
   
    
    //tableView functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath) as? ChannelCell{
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
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
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        MessageService.instance.clearMessages()
        
        MessageService.instance.findAllMessagesForChannel(channelId: (MessageService.instance.selectedChannel?.id)!) { (success) in
            if(success){
                NotificationCenter.default.post(name: Notification.Name("channelSelected"), object: nil)
                if(MessageService.instance.unreadChannels.count > 0){
                    MessageService.instance.unreadChannels = MessageService.instance.unreadChannels.filter{$0 != channel.id}
                }
                
                let index = IndexPath(row: indexPath.row, section: 0)
                tableView.reloadRows(at: [index], with: .none)
                tableView.selectRow(at: index, animated: true, scrollPosition: .none)
                
                self.revealViewController().revealToggle(animated: true)
            }
        }
        
    }
    
    

    

}
