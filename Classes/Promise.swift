//
//  Promise.swift
//  SwiftPromises
//
//  Created by Josh Holtz on 8/25/14.
//  Copyright (c) 2014 RokkinCat. All rights reserved.
//

import Foundation

typealias thenClosure = (AnyObject?) -> ()
typealias catchClosure = (AnyObject?) -> ()
typealias finalyClosure = () -> ()

public enum Status: String {
    case PENDING = "Pending"
    case RESOLVED = "Resolved"
    case REJECTED = "Rejected"
    
    private func resolve(promise: Promise, object: AnyObject?) {
        promise.sync { () in
            promise.status = .RESOLVED
            promise.object = object
            
            for then in promise.thens {
                then(promise.object)
            }
            
            promise.fin?()
        }
    }
    
    private func reject(promise: Promise, error: AnyObject?) {
        promise.sync { () in
            promise.status = .REJECTED
            promise.object = error
            
            promise.cat?(promise.object)
            promise.fin?()
        }
    }
}

class Deferred: Promise {
    
    let promise = Promise()
    
    override init() {
        
    }
    
    func resolve(object: AnyObject?) {
        promise.status.resolve(promise, object: object)
    }
    
    func reject(error: AnyObject?) {
        promise.status.reject(promise, error: error)
    }
    
    override func then(then: thenClosure) -> Promise {
        return promise.then(then)
    }
    
    override func catch(catch: catchClosure) -> Promise {
        return promise.catch(catch)
    }
    
    override func finally(finally: finalyClosure) -> Promise {
        return promise.finally(finally)
    }
    
}

class Promise {

    var thens = Array<thenClosure>()
    var cat: catchClosure?
    var fin: finalyClosure?
 
    var status: Status = .PENDING
    var object: AnyObject?
    
    private init() {
        
    }
    
    func then(then: thenClosure) -> Promise {
        self.sync { () in
            
            if (self.status == .PENDING) {
                self.thens.append(then)
            } else if (self.status == .RESOLVED) {
                then(self.object)
            }
            
        }
        
        return self
    }
    
    func catch(catch: catchClosure) -> Promise {
        if (self.cat? != nil) { return self }
        
        self.sync { () in
            
            if (self.status == .PENDING) {
                self.cat = catch
            } else if (self.status == .REJECTED) {
                catch(self.object)
            }
            
        }
        
        return self
    }
    
    func finally(finally: finalyClosure) -> Promise {
        if (self.fin? != nil) { return self }
        
        self.sync { () in
            
            if (self.status == .PENDING) {
                self.fin = finally
            } else {
                finally()
            }
            
        }
        
        return self
    }
    
    func sync(closure: () -> ()) {
        let lockQueue = dispatch_queue_create("com.rokkincat.promises.LockQueue", nil)
        dispatch_sync(lockQueue, closure)
    }
    
}