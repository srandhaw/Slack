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
    
    func getMessage(completion: @escaping (_ newMessage: Message)-> Void){
        
        manager.defaultSocket.on("messageCreated") { (dataArray, ack) in
            guard let messageBody = dataArray[0] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let userName = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let userAvatarColor = dataArray[5] as? String else { return }
            guard let id = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }
            
            let newMessage = Message(message: messageBody, userName: userName, channelID: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
            
           completion(newMessage)
            
            
            
        }
        
    }
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void){
        manager.defaultSocket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String: String] else { return }
            completionHandler(typingUsers)
        }
    }
    
    

}
