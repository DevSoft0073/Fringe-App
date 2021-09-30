//
//  SocketManger.swift
//  SessionControl
//
//  Created by Dharmesh Avaiya on 05/07/21.
//  Copyright © 2020 dharmesh. All rights reserved.
//


import Foundation
import SocketIO

enum SocketMessageType: String {
    case connect = "ConncetedChat"
    case newMessage = "newMessage"
    case chatStatus = "ChatStatus"
    case startTyping = "type"
    case stopTyping = "typing"
    case disconnect = "disconnect"
    case leaveChat = "leaveChat"
}

class SocketManger {
    
    //------------------------------------------------------
    
    //MARK: Shared
    
    static let shared = SocketManger()
    
    let manager = SocketManager(socketURL: URL(string: "http://jaohar-uk.herokuapp.com:80")!, config: [.log(true), .compress])
    var socket:SocketIOClient!
            
    //------------------------------------------------------
    
    //MARK: Customs
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    /*
    //------------------------------------------------------
    
    //MARK: Handler
    
    func onConnect(handler: @escaping () -> Void) {
        socket.on(SocketMessageType.connect.rawValue) { (_, _) in
            handler()
        }
    }
    
    func handleNewMessage(handler: @escaping (_ message: [String: Any]) -> Void) {
        socket.on(SocketMessageType.newMessage.rawValue) { (data, ack) in
            print("textttttt",data[1])
            let msg = data[1] as! [String: Any]
            handler(msg)
        }
    }
    
    func handleJoinedMessage(handler: @escaping (_ message: [String: Any]) -> Void) {
        socket.on(SocketMessageType.chatStatus.rawValue) { (data, ack) in
            print(data[1])
            let msg = data[1] as! [String: Any]
            handler(msg)
        }
    }
    
    func handleUserTyping(handler: @escaping (_ trueIndex: Int) -> Void) {
        socket.on(SocketMessageType.startTyping.rawValue) { (data, ack) in
            let trueIndex = data[1] as? Int
            handler(trueIndex!)
        }
    }
    
    func handleUserStopTyping(handler: @escaping () -> Void) {
        socket.on(SocketMessageType.stopTyping.rawValue) { (_, _) in
            handler()
        }
    }*/
    
    //------------------------------------------------------
    
    //MARK: Init
    
    init() {
        
        socket = manager.defaultSocket
        
        socket.on(SocketMessageType.connect.rawValue) { (_, _) in
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SocketMessageType.connect.rawValue), object: nil)
        }
        
        socket.on(SocketMessageType.newMessage.rawValue) { (data, ack) in
            
            let msg = data[1] as! [String: Any]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SocketMessageType.newMessage.rawValue), object: msg)
        }
        
        socket.on(SocketMessageType.chatStatus.rawValue) { (data, ack) in
            
            let msg = data[1] as! [String: Any]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SocketMessageType.chatStatus.rawValue), object: msg)
        }
        
        socket.on(SocketMessageType.startTyping.rawValue) { (data, ack) in
            
            let trueIndex = data[1] as? Int
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SocketMessageType.startTyping.rawValue), object: trueIndex)
        }
        
        socket.on(SocketMessageType.stopTyping.rawValue) { (_, _) in
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SocketMessageType.stopTyping.rawValue), object: nil)
        }
    }
      
    //------------------------------------------------------
}
