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
    


}
