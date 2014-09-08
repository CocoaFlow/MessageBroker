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
import JSONLib

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
                    
                    expect(receiverChannel).to(equal(brokerChannel))
                    expect(receiverTopic).to(equal(brokerTopic))
                    expect(receiverPayload).to(equal(JSON.parse(brokerPayload).value))
                }
            }
            
            describe("sending a message") {
                
                it("should forward the message to the message sender") {
                    let messageBroker = MessageBroker()
                    
                    let brokerChannel = "channel"
                    let brokerTopic = "topic"
                    let brokerPayload = "{\"key\":\"value\"}"
                    
                    var senderChannel: String!
                    var senderTopic: String!
                    var senderPayload: JSON!
                    
                    let messageSender = FakeMessageSender(messageBroker) { (channel, topic, payload) in
                        senderChannel = channel
                        senderTopic = topic
                        senderPayload = payload
                    }
                    
                    messageBroker.send(brokerChannel, brokerTopic, JSON.parse(brokerPayload).value!)
                    
                    expect(senderChannel).to(equal(brokerChannel))
                    expect(senderTopic).to(equal(brokerTopic))
                    expect(senderPayload).to(equal(JSON.parse(brokerPayload).value))
                }
            }
        }
    }
}
