//
//  ProfileVCViewController.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 6/15/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

class ProfileVCViewController: UIViewController {

    //Outlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = UserDataService.instance.name
        userEmail.text = UserDataService.instance.email
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        let bgc = UserDataService.instance.avatarColor
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(component: bgc)

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        
        NotificationCenter.default.post(name: Notification.Name("notifUserDataChanged"), object: nil)
        UserDataService.instance.logoutUser()
        dismiss(animated: true, completion: nil)
    }
    
    
    

}
