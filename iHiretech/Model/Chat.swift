//
//  Chat.swift
//  iHiretech
//
//  Created by Admin on 25/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import SocketIO

enum SocketEvent: String {
    case typing = "typing"
    case message = "message"
}

protocol SocketIOManagerDelegate: class {
    func usersTyping(_ data: [String:Any])
    func messageReceived(_ data: [String:Any])
}

class SocketIOManager {
    
    static let sharedInstance = SocketIOManager()
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://172.16.2.7:3003/")!)
    weak var socketIOManagerDelegate: SocketIOManagerDelegate!
    
    func establishConnection() {
        socket.connect()
        socket.onAny { (socketEvent) in
            switch SocketEvent(rawValue: socketEvent.event) {
            case .typing?:
                self.socketIOManagerDelegate.usersTyping(socketEvent.items?.first as! [String:Any])
            case .message?:
                self.socketIOManagerDelegate.messageReceived(socketEvent.items?.first as! [String:Any])
            default:
                NotificationCenter.default.post(name: NSNotification.Name("MessageReceived"), object: nil, userInfo: socketEvent.items?.first as? [String:Any])
            }
        }
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func sendDataToEvent(_ socketEvent: SocketEvent,data dict: [String:Any]) {
        socket.emit(socketEvent.rawValue, dict)
    }
}

