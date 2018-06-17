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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
  self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: Notification.Name("notifUserDataChanged"), object: nil)
        SocketService.instance.getChannel { (success) in
            
            if(success){
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
        }
    }
    
    @IBAction func prepareForUnwind(for x: UIStoryboardSegue ) {
        
    }
    
    @IBAction func addChannelBtnPressed(_ sender: Any) {
        let channel = AddChannelVC()
        channel.modalPresentationStyle = .custom
        present(channel, animated: true, completion: nil)
    }
    
    
    @objc func userDataDidChange(_ notif: Notification){
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
        
    }
    
    

    

}
