//
//  AddChannelVC.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 6/17/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.touchBg(_:)))
        bgView.addGestureRecognizer(touch)
        
        nameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.423529923, green: 0.6870478392, blue: 0.8348321319, alpha: 1)])
        descriptionTxt.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.423529923, green: 0.6870478392, blue: 0.8348321319, alpha: 1)])
        

        
    }
    
    @objc func touchBg(_ recog: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelBtnPressed(_ sender: Any) {
        guard let channelName = nameTxt.text, nameTxt.text != "" else{ return }
        guard let channelDescription = descriptionTxt.text, descriptionTxt.text != "" else{ return }
        
        SocketService.instance.addChannel(name: channelName, description: channelDescription) { (success) in
            if(success){
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
