//
//  CacheStorage.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

import Foundation

final class WrapperObject<T> {
    let value: T
    
    init(value: T) {
        self.value = value
    }
}

final class CacheStorage<T> {
    private let cache = NSCache<NSNumber, WrapperObject<T>>()
    private let lock = NSLock()
    
    func fetch(for key: any Hashable) -> T? {
        lock.lock()
        defer { lock.unlock() }
        
        guard let object = cache.object(forKey: NSNumber(value: key.hashValue)) else {
            return nil
        }
        
        return object.value
    }
    
    func store(_ object: T, for key: any Hashable) {
        lock.lock()
        defer { lock.unlock() }
        
        cache.setObject(WrapperObject(value: object), forKey: NSNumber(value: key.hashValue))
    }
    
    func isCached(_ key: any Hashable) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        
        return cache.object(forKey: NSNumber(value: key.hashValue)) != nil
    }
}
