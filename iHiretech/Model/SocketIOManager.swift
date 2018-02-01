//
//  Chat.swift
//  iHiretech
//
//  Created by Admin on 25/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import SocketIO

enum Event: String {
    case typing = "typing"
    case message = "message_sent"
}

protocol SocketIOManagerDelegate: class {
    func usersTyping(_ data: [String:Any])
    func messageReceived(_ data: [String:Any])
}

class SocketIOManager {
    
    static let sharedInstance = SocketIOManager()
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://172.16.2.68:8890")!)
    weak var socketIOManagerDelegate: SocketIOManagerDelegate!
    
    func establishConnection() {

        socket.connect()
        print("connection established....")
        socket.onAny { (socketEvent) in
            print(socketEvent.event)
            switch Event(rawValue: socketEvent.event) {
            case .typing?:
                self.socketIOManagerDelegate.usersTyping(socketEvent.items?.first as! [String:Any])
            case .message?:
              self.socketIOManagerDelegate.messageReceived(socketEvent.items?.first as! [String:Any])
                 NotificationCenter.default.post(name: NSNotification.Name("MessageReceived"), object: nil, userInfo: socketEvent.items?.first as? [String:Any])
            default:
                print("Done")
            }
        }
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func sendDataToEvent(_ socketEvent: Event,data dict: [String:Any]) {
        socket.emit(socketEvent.rawValue, dict)
    }
}

