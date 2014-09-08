//
//  FakeMessageSender.swift
//  MessageBroker
//
//  Created by Paul Young on 03/09/2014.
//  Copyright (c) 2014 CocoaFlow. All rights reserved.
//

import Foundation
import MessageTransfer
import JSONLib

struct FakeMessageSender: MessageSenderWithReceiver {
    
    typealias Verification = (channel: String, topic: String, payload: JSON?) -> Void
    
    private let verify: Verification
    var messageReceiver: MessageReceiver?
    
    init(var _ messageReceiver: MessageReceiverWithSender, _ verify: Verification = { (channel, topic, payload) in }) {
        self.messageReceiver = messageReceiver
        self.verify = verify
        messageReceiver.messageSender = self
    }
    
    func send(channel: String, _ topic: String, _ payload: JSON?) {
        self.verify(channel: channel, topic: topic, payload: payload)
    }
}
