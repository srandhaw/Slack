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
    
    @IBOutlet weak var userImg: UIImageView!
    
    //Variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5 0.5 0.5 1]"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: self)
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
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
                              self.performSegue(withIdentifier: UNWIND, sender: self)
                               
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
    }
    
    
}
