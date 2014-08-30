//
//  ViewController.swift
//  SwiftPromises
//
//  Created by Josh Holtz on 8/25/14.
//  Copyright (c) 2014 RokkinCat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.resolveAfter()
//        self.resolveAfterWithChain()
//        self.resolveBefore()
//        
//        self.rejectAfter()
//        self.rejectBefore()
//        
//        self.allResolve()
//        self.allReject()
        
//        self.alternativePromise();
    }
    
    func resolveAfter() {
        println("\n\nRESOLVED AFTER")
        
        let deferred = Deferred()
        
        let promise = deferred.promise
        promise
            .then { (value) -> (AnyObject?) in
                println("Will be \"Yay\" - \(value)")
                return "Yay 1"
            }
            .then { (value) -> (AnyObject?) in
                println("Will be \"Yay 1\" - \(value)")
                return "Yay 2"
            }
            .then { (value) -> (AnyObject?) in
                println("Will be \"Yay 2\" - \(value)")
                return "Yay 3"
            }
            .then { (value) -> () in
                println("Will be \"Yay 3\" - \(value)")
            }
            .catch { (error) -> () in
                println("Catch - \(error)")
            }
            .finally { () -> () in
                println("Finally")
        }
        
        deferred.resolve("Yay")
        
    }
    
    func resolveAfterWithChain() {
        println("\n\nRESOLVED AFTER WITH CHAIN")
        
        let deferred = Deferred()
        let deferredRet = Deferred()
        
        let promise = deferred.promise
        promise
            .then { (value) -> (AnyObject?) in
                println("Should be \"Yay\" - \(value)")
                return "Yay 1"
            }
            .then { (value) -> () in
                println("Should be \"Yay 1\" - \(value)")
            }
            .then { (value) -> (AnyObject?) in
                println("Should be \"Yay 1\" - \(value)")
                return deferredRet
            }
            .then { (value) -> () in
                println("Should be \"YAY YAY YAY YAY\" - \(value)")
            }
            .catch { (error) -> () in
                println("Catch - \(error)")
            }
            .finally { () -> () in
                println("Finally")
            }
        
        deferred.resolve("Yay")
        
        println("Go go other deferred")
        deferredRet.resolve("YAY YAY YAY YAY")

    }
    
    func resolveBefore() {
        println("\n\nRESOLVED BEFORE")
        
        let deferred = Deferred()
        deferred.resolve("YAY")
        deferred
            .then { (value) -> () in
                println("Then 1 - \(value)")
            }
            .then { (value) -> () in
                println("Then 2 - \(value)")
            }
            .then { (value) -> () in
                println("Then 3 - \(value)")
            }
            .catch { (error) -> () in
                println("Catch - \(error)")
            }
            .finally { () -> () in
                println("Finally")
            }

    }
    
    func rejectAfter() {
        println("\n\nREJECTED AFTER")
        
        let deferred = Deferred()
        deferred
            .then { (value) -> () in
                println("Then 1 - \(value)")
            }
            .then { (value) -> () in
                println("Then 2 - \(value)")
            }
            .then { (value) -> () in
                println("Then 3 - \(value)")
            }
            .catch { (error) -> () in
                println("Catch - \(error)")
            }
            .finally { () -> () in
                println("Finally")
            }
        
        deferred.reject("YAY")
    }
    
    func rejectBefore() {
        println("\n\nREJECTED BEFORE")
        
        let deferred = Deferred()
        deferred.reject("YAY")
        deferred
            .then { (value) -> () in
                println("Then 1 - \(value)")
            }
            .then { (value) -> () in
                println("Then 2 - \(value)")
            }
            .then { (value) -> () in
                println("Then 3 - \(value)")
            }
            .catch { (error) -> () in
                println("Catch - \(error)")
            }
            .finally { () -> () in
                println("Finally")
            }
        
    }
    
    func allResolve() {
        
        println("\n\nALL RESOLVED")
        
        let deferred1 = Deferred()
        let deferred2 = Deferred()
        let deferred3 = Deferred()
        
        deferred1.then { (value) -> () in println("Deferred 1 - \(value)") }
        deferred2.then { (value) -> () in println("Deferred 2 - \(value)") }
        deferred3.then { (value) -> () in println("Deferred 3 - \(value)") }
        
        Promise.all([deferred1, deferred2, deferred3])
            .then { (values) -> () in
                println("Success for all - \(values)")
            }
            .catch { (error) -> () in
                println("Error in one - \(error)")
            }
            .finally { () -> () in
                println("Finished no matter what")
            }
        
        deferred1.resolve("Woo 1")
        deferred2.resolve("Woo 2")
        deferred3.resolve("Woo 3")
        
    }
    
    func allReject() {
        
        println("\n\nALL REJECT")
        
        let deferred1 = Deferred()
        let deferred2 = Deferred()
        let deferred3 = Deferred()
        
        deferred1.then { (value) -> () in println("Deferred 1 - \(value)") }
        deferred2.then { (value) -> () in println("Deferred 2 - \(value)") }
        deferred3.then { (value) -> () in println("Deferred 3 - \(value)") }
        
        Promise.all([deferred1, deferred2, deferred3])
            .then { (value) -> () in
                println("Success for all")
            }
            .catch { (error) -> () in
                println("Error in one - \(error)")
            }
            .finally { () -> () in
                println("Finished no matter what")
        }
        
        deferred1.resolve("Woo 1")
        deferred2.reject("Woo 2")
        deferred3.resolve("Woo 3")
        
    }
    
    func alternativePromise() {
        
        println("\n\nALTERNATIVE PROMISE (WITHOUT DEFERRED)")
        
        var promise = Promise { (resolve: (AnyObject?) -> (), reject: (AnyObject?) -> ()) -> () in
            // Probably do some logic like an API call or something
            resolve("We got something back from API?")
        }
        
        promise.then { (value) -> () in
            println("Yay, then was called without a deferred - \(value)")
        }
        
    }
    
    func alternativePromiseFail() {
        
        println("\n\nALTERNATIVE PROMISE FAIL (WITHOUT DEFERRED)")
        
        var promise = Promise { (resolve: (AnyObject?) -> (), reject: (AnyObject?) -> ()) -> () in
            // Probably do some logic like an API call or something
            reject("We got something back from API?")
        }
        
        promise.then { (value) -> () in
            println("Yay, then was called without a deferred - \(value)")
        }
        promise.catch { (error) -> () in
            println("Yay, catch was called without a deferred - \(error)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

