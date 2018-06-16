//
//  LoginVC.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 6/10/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    //Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.423529923, green: 0.6870478392, blue: 0.8348321319, alpha: 1)])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.423529923, green: 0.6870478392, blue: 0.8348321319, alpha: 1)])
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginVC.handleTap))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    @IBAction func crossPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = usernameTxt.text, usernameTxt.text != "" else{ return }
         guard let password = passwordTxt.text, passwordTxt.text != "" else{ return }
        
        AuthService.instance.loginUser(email: email, password: password) { (success) in
            if(success){
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if(success){
                        NotificationCenter.default.post(name: Notification.Name("notifUserDataChanged"), object: nil)
                        self.spinner.isHidden = false
                        self.spinner.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                })
            }
        }
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: self)
    }
    
}
