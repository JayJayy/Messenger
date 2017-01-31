//
//  Messenger.swift
//  Budget
//
//  Created by Johannes Starke on 27.10.16.
//  Copyright © 2016 Johannes Starke. All rights reserved.
//

import Foundation

public class Messenger {
    public static let shared: Messenger = Messenger()
    
    private let store: WeakStore<Receiver>
    
    internal init() {
        store = WeakStore<Receiver>()
    }
    
    public func publish<TMessage: Message>(message: TMessage) {
        let storeName = "\(TMessage.self)"
        let items = store.items(from: storeName)
        
        print("Messenger: Publish \(storeName) to \(items.count) receiver")
        
        for item in items {
            item.notify(with: message)
        }
    }
    
    public func subscripte<TMessage: Message>(me token: AnyObject, to messageType: TMessage.Type, onReceive delegate: @escaping (_ message: TMessage) -> ()) {
        let storeName = "\(TMessage.self)"
        
        self.store.store(item: Receiver.build(for: token, with: delegate), in: storeName)
    }
}
