//
//  CreateAccountVC.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 6/10/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    
    @IBOutlet weak var userImg: UIImageView!
    
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
        if(email==""||password==""){
            return
        }
        
        AuthService.instance.registerUser(email: email!, password: password!) { (success) in
            if(success){
                print("user registered!!!")
            }
        }
    }
    
    @IBAction func chooseAvatarBtnPressed(_ sender: Any) {
    }
    
    @IBAction func generateBackgroundColorBtnPressed(_ sender: Any) {
    }
    
    
}
