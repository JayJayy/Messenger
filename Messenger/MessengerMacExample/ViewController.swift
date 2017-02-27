//
//  ViewController.swift
//  MessengerMacExample
//
//  Created by Johannes Starke on 26.02.17.
//  Copyright © 2017 Johannes Starke. All rights reserved.
//

import Cocoa
import Messenger

struct TestMessage: Message {
    
}

class ViewController: NSViewController {
    @IBOutlet weak var firstMessageTextField: NSTextField?
    @IBOutlet weak var lastMessageTextField: NSTextField?
    
    var testMessageToken: AnyObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Messenger.shared.subscribe(me: self, to: TestMessage.self) { [weak self] _ in
            self?.lastMessageTextField?.objectValue = Date()
        }
        
        testMessageToken = NSObject()
        
        if let token = testMessageToken {
            Messenger.shared.subscribe(me: token, to: TestMessage.self) { [weak self] _ in
                self?.firstMessageTextField?.objectValue = Date()
                self?.testMessageToken = nil
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func sendMessageAction(_ sender: AnyObject) {
        Messenger.shared.publish(message: TestMessage())
    }
}

