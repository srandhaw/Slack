//
//  SocketService.swift
//  Slack
//
//  Created by Sehajbir Randhawa on 6/17/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    override init() {
        super.init()
        
    }
    
    var manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
    
    func establishConnection() {
        manager.defaultSocket.connect()
        }
    
    func closeConnection() {
        manager.defaultSocket.disconnect()
    }
    
    func addChannel(name: String,description: String,completion: @escaping CompletionHandler){
        manager.defaultSocket.emit("newChannel", name,description)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler){
        manager.defaultSocket.on("channelCreated") { (dataArray, ack) in
            guard let name = dataArray[0] as? String else { return }
            guard let description = dataArray[1] as? String else { return }
            guard let id = dataArray[2] as? String else { return }
            
            let newChannel = Channel(channelTitle: name, channelDescription: description, id: id)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    func addMessage(messageBody: String,userId: String, channelId: String, completion: @escaping CompletionHandler){
        manager.defaultSocket.emit("newMessage",messageBody, userId,channelId,UserDataService.instance.name,UserDataService.instance.avatarName,UserDataService.instance.avatarColor)
        completion(true)
        
    }
    
    

}
