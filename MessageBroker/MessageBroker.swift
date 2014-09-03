//
//  MessageBroker.swift
//  MessageBroker
//
//  Created by Paul Young on 02/09/2014.
//  Copyright (c) 2014 CocoaFlow. All rights reserved.
//

import Foundation
import MessageTransfer
import JSONLib

public final class MessageBroker: MessageSenderWorkaround, MessageReceiverWorkaround {
    
    public var messageSender: MessageSender?
    public var messageReceiver: MessageReceiver?
    
    public init() {}
    
    public func send(channel: String, _ topic: String, _ payload: JSON) {
    
    }
    
    public func receive(channel: String, _ topic: String, _ payload: JSON) {
    
    }
}
