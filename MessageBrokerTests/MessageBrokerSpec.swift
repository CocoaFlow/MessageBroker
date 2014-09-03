//
//  MessageBrokerSpec.swift
//  MessageBroker
//
//  Created by Paul Young on 03/09/2014.
//  Copyright (c) 2014 CocoaFlow. All rights reserved.
//

import Foundation
import Quick
import Nimble
import MessageBroker
import MessageTransfer
import JSONLib

struct FakeMessageReceiver: MessageReceiverWorkaround {
    
    typealias Verification = (channel: String, topic: String, payload: JSON) -> Void
    
    private let verify: Verification
    var messageSender: MessageSender?
    
    init(var _ messageSender: MessageSenderWorkaround, _ verify: Verification = { (channel, topic, payload) in }) {
        self.messageSender = messageSender
        self.verify = verify
        messageSender.messageReceiver = self
    }
    
    func receive(channel: String, _ topic: String, _ payload: JSON) {
        self.verify(channel: channel, topic: topic, payload: payload)
    }
}

struct FakeMessageSender: MessageSenderWorkaround {
    
    typealias Verification = (channel: String, topic: String, payload: JSON) -> Void
    
    private let verify: Verification
    var messageReceiver: MessageReceiver?
    
    init(var _ messageReceiver: MessageReceiverWorkaround, _ verify: Verification = { (channel, topic, payload) in }) {
        self.messageReceiver = messageReceiver
        self.verify = verify
        messageReceiver.messageSender = self
    }
    
    func send(channel: String, _ topic: String, _ payload: JSON) {
        self.verify(channel: channel, topic: topic, payload: payload)
    }
}

class MessageBrokerSpec: QuickSpec {
    
    override func spec() {
        
        describe("Message broker") {
            
            describe("receiving a message") {
                
                it("should forward the message to the message receiver") {
                    let messageBroker = MessageBroker()
                    
                    let brokerChannel = "channel"
                    let brokerTopic = "topic"
                    let brokerPayload = "{\"key\":\"value\"}"
                    
                    var receiverChannel: String!
                    var receiverTopic: String!
                    var receiverPayload: JSON!
                    
                    let messageReceiver = FakeMessageReceiver(messageBroker) { (channel, topic, payload) in
                        receiverChannel = channel
                        receiverTopic = topic
                        receiverPayload = payload
                    }
                    
                    messageBroker.receive(brokerChannel, brokerTopic, JSON.parse(brokerPayload).value!)
                    
                    expect(receiverChannel).toEventually(equal(brokerChannel))
                    expect(receiverTopic).toEventually(equal(brokerTopic))
                    expect(receiverPayload).toEventually(equal(JSON.parse(brokerPayload).value))
                }
            }
            
            describe("sending a message") {
                
                it("should forward the message to the message sender") {
                    let messageBroker = MessageBroker()
                    
                    let brokerChannel = "channel"
                    let brokerTopic = "topic"
                    let brokerPayload = "{\"key\":\"value\"}"
                    
                    var receiverChannel: String!
                    var receiverTopic: String!
                    var receiverPayload: JSON!
                    
                    let messageReceiver = FakeMessageSender(messageBroker) { (channel, topic, payload) in
                        receiverChannel = channel
                        receiverTopic = topic
                        receiverPayload = payload
                    }
                    
                    messageBroker.send(brokerChannel, brokerTopic, JSON.parse(brokerPayload).value!)
                    
                    expect(receiverChannel).toEventually(equal(brokerChannel))
                    expect(receiverTopic).toEventually(equal(brokerTopic))
                    expect(receiverPayload).toEventually(equal(JSON.parse(brokerPayload).value))
                }
            }
        }
    }
}
