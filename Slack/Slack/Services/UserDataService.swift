//
//  UserDataService.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 6/12/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import Foundation

class UserDataService{
    
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var email = ""
    public private(set) var name = ""
    public private(set) var avatarName = "profileDefault"
    public private(set) var avatarColor = ""
    
    func setUserData(id: String, email: String, name: String, avatarName: String, avatarColor: String){
        
        self.id = id
        self.email = email
        self.name = name
        self.avatarColor = avatarColor
        self.avatarName = avatarName
        
    }
    
    func setAvatarName(avatarName: String){
        self.avatarName = avatarName
    }
    
    func returnUIColor(component: String) -> UIColor{
        let scanner = Scanner(string: component)
        let skipped = CharacterSet(charactersIn: "[] ,")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r,g,b,a: NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        guard let rUnwrapped = r else{return UIColor.lightGray}
        guard let gUnwrapped = g else{return UIColor.lightGray}
        guard let bUnwrapped = b else{return UIColor.lightGray}
        guard let aUnwrapped = a else{return UIColor.lightGray}
        
        let rFloat = CGFloat(rUnwrapped.doubleValue)
        let gFloat = CGFloat(gUnwrapped.doubleValue)
        let bFloat = CGFloat(bUnwrapped.doubleValue)
        let aFloat = CGFloat(aUnwrapped.doubleValue)
        
        let color: UIColor = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
        return color
        
        
    }
    
    func logoutUser(){
        id = ""
        email = ""
        name=""
        avatarName = ""
        avatarColor = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
        MessageService.instance.clearChannels()
        MessageService.instance.clearMessages()
    }
    


}
