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
    
    private func resolve(promise: Promise, object: AnyObject?, shouldRunFinally: Bool = true) {
        promise.sync { () in
            if (promise.status != .PENDING) { return }
            promise.status = .RESOLVED
            promise.object = object
            
            for then in promise.thens {
                then(promise.object)
            }
            
            if (shouldRunFinally) { promise.fin?() }
        }
    }
    
    private func reject(promise: Promise, error: AnyObject?, shouldRunFinally: Bool = true) {
        promise.sync { () in
            if (promise.status != .PENDING) { return }
            promise.status = .REJECTED
            promise.object = error
            
            promise.cat?(promise.object)
            if (shouldRunFinally) { promise.fin?() }
        }
    }
    
    private func finally(promise: Promise) {
        if (promise.status == .PENDING) { return }
        promise.fin?()
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

class When: Promise {
    
    var promiseCount: Int = 0
    var numberOfThens: Int = 0
    var numberOfCatches: Int = 0
    var total: Int {
        get { return numberOfThens + numberOfCatches }
    }
    
    private func then(object: AnyObject?) {
        self.sync { () in
            self.numberOfThens += 1
            
            if (self.total >= self.promiseCount) {
                if (self.status == .PENDING) {
                    self.status.resolve(self, object: nil, shouldRunFinally: false)
                }
                
                self.status.finally(self)
            }
        }
    }
    
    private func catch(object: AnyObject?) {
        self.sync { () in
            self.numberOfCatches += 1
            
            if (self.status == .PENDING) {
                self.status.reject(self, error: nil, shouldRunFinally: false)
            }
            
            if (self.total >= self.promiseCount) {
                self.status.finally(self)
            }
        }
    }
    
    class func all(promises: Array<Promise>) -> Promise {
        return When().all(promises)
    }
    
    func all(promises: Array<Promise>) -> Promise {
        self.promiseCount = promises.count
        
        for promise in promises {
            promise.then(then)
            promise.catch(catch)
        }
        
        return self;
    }
    
}