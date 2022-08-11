//
//  SocketIOManager.swift
//  IOSChatBot
//
//  Created by Raghuram on 07/06/22.
//

import UIKit

class SocketManager: NSObject,URLSessionDelegate {
    static let sharedInstance = SocketManager()
    
    override init() {
        super.init()
    }
}
