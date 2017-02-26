//
//  ViewController.swift
//  MessengerMacExample
//
//  Created by Johannes Starke on 26.02.17.
//  Copyright © 2017 Johannes Starke. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var lastMessageReceivedTextField: NSTextField!

    var lastMessageDate: Date
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

