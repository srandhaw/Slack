//
//  AuthService.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 6/11/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService{
    
    static let instance = AuthService()
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get{
           return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set{
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get{
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set{
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
        
    }
    
    var userEmail: String {
        get{
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set{
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    func registerUser(email: String,password: String,completion: @escaping CompletionHandler){
        let email1 = email.lowercased()
        let header = [
            "Content-Type":"application/json; charset=utf-8"
        ]
        let body: [String: Any] = [
            "email":email1,
            "password":password
        ]
        
        Alamofire.request(REGISTER_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseString{(response) in

            if(response.result.error==nil){
                completion(true)
            }
            else{
                completion(false)
               // debugPrint(response.result.error as Any)
                print("\n\n problem in register user in AuthService \n\n")
            }
        }
        
    }
    
    func loginUser(email: String, password: String,completion: @escaping CompletionHandler){
        let email1 = email.lowercased()
        let header = [
            "Content-Type":"application/json; charset=utf-8"
        ]
        let body: [String: Any] = [
            "email":email1,
            "password":password
        ]
        
        Alamofire.request(LOGIN_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            if(response.result.error==nil){
                guard let data = response.data else {return}
               
                do{
                let json = try JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    self.isLoggedIn = true
                }catch{print("\n\nJSON - problem in login user in AuthService\n\n")}
                
                
                
                completion(true)
                
            }
            else{
                debugPrint(response.result.error)
                completion(false)
            }
        }
    }
    
    
    func createUser(name: String,email: String,avatarName: String,avatarColor: String, completion: @escaping CompletionHandler){
        
        let email1 = email.lowercased()
        
        let header = [
            "Authorization":"Bearer \(AuthService.instance.authToken)",
            "Content-Type":"application/json; charset=utf-8"
        ]
        let body:[String: Any] = [
            "name": name,
            "email": email1,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        Alamofire.request(ADD_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            print("\n\(response.result.error)\n")
            if(response.result.error==nil){
                
                if let json = response.result.value as? Dictionary<String,Any>{
                     let id = json["_id"] as? String
                       
                    
                    let color = json["avatarColor"] as? String
                    
                    let avatarName = json["avatarName"] as? String
                    
                     let email = json["email"] as? String
                     let name = json["name"] as? String
                    UserDataService.instance.setUserData(id: id!, email: email!, name: name!, avatarName: avatarName!, avatarColor: avatarColor)
                }
                    
                
              
                
                
                completion(true)
            }else{
                
                completion(false)
            }
        }
        
    }
    

}
