//
//  ChatView.swift
//  iHiretech
//
//  Created by Admin on 25/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

//protocol ChatRoomDelegate: class {
//    func receivedMessage(message: Message)
//}

class ChatView: NSObject {
    var inputStream: InputStream!
    var outputStream: OutputStream!
 //   weak var delegate: ChatRoomDelegate?
    //2
    var username = ""
    
    //3
    let maxReadLength = 4096
    
    func setupNetworkCommunication() {
        // 1
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        // 2
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           "localhost" as CFString,
                                           80,
                                           &readStream,
                                           &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        inputStream.delegate = self
        
        inputStream.schedule(in: .current, forMode: .commonModes)
        outputStream.schedule(in: .current, forMode: .commonModes)
        
        inputStream.open()
        outputStream.open()
    }
    

}

extension ChatView: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            print("new message received")
        //    readAvailableBytes(stream: aStream as! InputStream)
        case Stream.Event.endEncountered:
            print("new message received")
        case Stream.Event.errorOccurred:
            print("error occurred")
        case Stream.Event.hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
            break
        }
    }
    
//    private func readAvailableBytes(stream: InputStream) {
//        //1
//        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
//
//        //2
//        while stream.hasBytesAvailable {
//            //3
//            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
//
//            //4
//            if numberOfBytesRead < 0 {
//                if let _ = stream.streamError {
//                    break
//                }
//            }
//            if let message = processedMessageString(buffer: buffer, length: numberOfBytesRead) {
//                //Notify interested parties
//                 delegate?.receivedMessage(message: message)
//            }
//            //Construct the Message object
//        }
//    }
    
//    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>,
//                                        length: Int) -> Message? {
//        //1
//        guard let stringArray = String(bytesNoCopy: buffer,
//                                       length: length,
//                                       encoding: .ascii,
//                                       freeWhenDone: true)?.components(separatedBy: ":"),
//            let name = stringArray.first,
//            let message = stringArray.last else {
//                return nil
//        }
//        //2
//        let messageSender:MessageSender = (name == self.username) ? .ourself : .someoneElse
//        //3
//        return Message(message: message, messageSender: messageSender, username: name)
//    }
    
    func sendMessage(message: String) {
        let data = "msg:\(message)".data(using: .ascii)!
        
        _ = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
    }
}
