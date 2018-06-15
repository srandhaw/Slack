//
//  CreateAccountVC.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 6/10/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
//Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var userImg: UIImageView!
    
    //Variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5 0.5 0.5 1]"
    var bgColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.423529923, green: 0.6870478392, blue: 0.8348321319, alpha: 1)])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.423529923, green: 0.6870478392, blue: 0.8348321319, alpha: 1)])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.423529923, green: 0.6870478392, blue: 0.8348321319, alpha: 1)])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        avatarName = UserDataService.instance.avatarName
        userImg.image = UIImage(named: avatarName)
        if(avatarName.contains("light") && bgColor==nil){
            userImg.backgroundColor = UIColor.lightGray
        }
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: self)
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        
        spinner.isHidden = false
        spinner.startAnimating()
        let email = emailTxt.text
        let password = passwordTxt.text
        let name = usernameTxt.text
        
        
        
        if(email==""||password==""){
            return
        }
        
        AuthService.instance.registerUser(email: email!, password: password!) { (success) in
          if(success){
            
                AuthService.instance.loginUser(email: email!, password: password!, completion: { (success) in
                    if(success){
                        
                       AuthService.instance.createUser(name: name!, email: email!, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            
                            if(success){
                                self.spinner.isHidden=true
                                self.spinner.stopAnimating()
                              self.performSegue(withIdentifier: UNWIND, sender: self)
                                NotificationCenter.default.post(name: Notification.Name("notifUserDataChanged"), object: nil)
                               
                            }else{
                                print("\n\nproblemo in createacc\n\n")
                            }
                            
 
                        })
                       
                    }
                })
           }
        }
    }
    
    @IBAction func chooseAvatarBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: self)
    }
    
    @IBAction func generateBackgroundColorBtnPressed(_ sender: Any) {
        let r: CGFloat = CGFloat(arc4random_uniform(255))/255
        let g: CGFloat = CGFloat(arc4random_uniform(255))/255
        let b: CGFloat = CGFloat(arc4random_uniform(255))/255
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        
        UIView.animate(withDuration: 0.3) {
            
            self.userImg.backgroundColor = self.bgColor
        }
        
    }
    
    
}
