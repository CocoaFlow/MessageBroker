//
//  FakeMessageReceiver.swift
//  MessageBroker
//
//  Created by Paul Young on 03/09/2014.
//  Copyright (c) 2014 CocoaFlow. All rights reserved.
//

import Foundation
import MessageTransfer
import JSONLib

struct FakeMessageReceiver: MessageReceiverWithSender {
    
    typealias Verification = (channel: String, topic: String, payload: JSON) -> Void
    
    private let verify: Verification
    var messageSender: MessageSender?
    
    init(var _ messageSender: MessageSenderWithReceiver, _ verify: Verification = { (channel, topic, payload) in }) {
        self.messageSender = messageSender
        self.verify = verify
        messageSender.messageReceiver = self
    }
    
    func receive(channel: String, _ topic: String, _ payload: JSON) {
        self.verify(channel: channel, topic: topic, payload: payload)
    }
}
