//
//  MessageService.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 6/16/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService{
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    
    func findAllChannels(completion: @escaping CompletionHandler){
        
        let header = [
            "Authorization":"Bearer \(AuthService.instance.authToken)",
            "Content-Type":"application/json; charset=utf-8"
        ]
        
        Alamofire.request(GET_CHANNELS_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            if(response.result.error==nil){
                
                guard let data = response.data else { return }
                
                do{
                if let json = try JSON(data: data).array{
                    for item in json{
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                        self.channels.append(channel)
                    }
                
                }
                }catch{
                    
                }
                
                
                completion(true)
                
            }
            completion(false)
            debugPrint(response.result.error)
        }
    }
    
}
