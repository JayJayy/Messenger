//
//  Receiver.swift
//  Messenger
//
//  Created by Johannes Starke on 31.01.17.
//  Copyright © 2017 Johannes Starke. All rights reserved.
//

import Foundation

struct Receiver: WeakStoreable {
    weak var object: AnyObject?
    var delegate: Any
    
    static func build<T: Message>(for object: AnyObject, with delegate: @escaping (_ message: T) -> ()) -> Receiver {
        return Receiver(object: object, delegate: delegate)
    }
    
    func notify<T: Message>(with message: T) {
        guard let delegate = self.delegate as? ((_ message: T) -> ()) else {
            return
        }
        
        delegate(message)
    }
    
    var canRemove: Bool {
        return object == nil
    }
}
