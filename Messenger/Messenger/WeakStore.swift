//
//  WeakStore.swift
//  Budget
//
//  Created by Johannes Starke on 29.10.16.
//  Copyright © 2016 Johannes Starke. All rights reserved.
//

import Foundation

internal protocol WeakStoreable {
    var canRemove: Bool { get }
}


internal class WeakStore<T: WeakStoreable> {
    let queue = DispatchQueue(label: "de.jstarke.weakStoreQueue", attributes: .concurrent)
    
    var stores: [String: [T]]
    
    init() {
        stores = [String: [T]]()
    }
    
    func store(item: T, in storeKey: String) {
        queue.async(flags: .barrier) { [weak self] in
            var store = self?.stores[storeKey] ?? [T]()
            store.append(item)
            
            self?.stores[storeKey] = store
        }
    }
    
    func items(from storeKey: String) -> [T] {
        var items: [T]? = nil
        
        queue.sync {
            clean(store: storeKey)
            items = self.stores[storeKey]
        }
        
        return items ?? [T]()
    }
    
    fileprivate func clean(store storeKey: String) {
        stores[storeKey] = stores[storeKey]?.filter({ !$0.canRemove })
    }
}
