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
        
        self.resolveAfter()
        self.resolveAfterWithChain()
        self.resolveBefore()
        
        self.rejectAfter()
        self.rejectBefore()
        
        self.allResolve()
        self.allReject()
        
    }
    
    func resolveAfter() {
        println("\n\nRESOLVED AFTER")
        
        let deferred = Deferred()
        
        let promise = deferred.promise
        promise
            .then { (object) -> (AnyObject?) in
                println("Will be \"Yay\" - \(object)")
                return "Yay 1"
            }
            .then { (object) -> (AnyObject?) in
                println("Will be \"Yay 1\" - \(object)")
                return "Yay 2"
            }
            .then { (object) -> (AnyObject?) in
                println("Will be \"Yay 2\" - \(object)")
                return "Yay 3"
            }
            .then { (object) -> () in
                println("Will be \"Yay 3\" - \(object)")
            }
            .catch { (object) -> () in
                println("Catch - \(object)")
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
            .then { (object) -> (AnyObject?) in
                println("Should be \"Yay\" - \(object)")
                return "Yay 1"
            }
            .then { (object) -> () in
                println("Should be \"Yay 1\" - \(object)")
            }
            .then { (object) -> (AnyObject?) in
                println("Should be \"Yay 1\" - \(object)")
                return deferredRet
            }
            .then { (object) -> () in
                println("Should be \"YAY YAY YAY YAY\" - \(object)")
            }
            .catch { (object) -> () in
                println("Catch - \(object)")
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
            .then { (object) -> () in
                println("Then 1 - \(object)")
            }
            .then { (object) -> () in
                println("Then 2 - \(object)")
            }
            .then { (object) -> () in
                println("Then 3 - \(object)")
            }
            .catch { (object) -> () in
                println("Catch - \(object)")
            }
            .finally { () -> () in
                println("Finally")
            }

    }
    
    func rejectAfter() {
        println("\n\nREJECTED AFTER")
        
        let deferred = Deferred()
        deferred
            .then { (object) -> () in
                println("Then 1 - \(object)")
            }
            .then { (object) -> () in
                println("Then 2 - \(object)")
            }
            .then { (object) -> () in
                println("Then 3 - \(object)")
            }
            .catch { (object) -> () in
                println("Catch - \(object)")
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
            .then { (object) -> () in
                println("Then 1 - \(object)")
            }
            .then { (object) -> () in
                println("Then 2 - \(object)")
            }
            .then { (object) -> () in
                println("Then 3 - \(object)")
            }
            .catch { (object) -> () in
                println("Catch - \(object)")
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
        
        deferred1.then { (object) -> () in println("Deferred 1 - \(object)") }
        deferred2.then { (object) -> () in println("Deferred 2 - \(object)") }
        deferred3.then { (object) -> () in println("Deferred 3 - \(object)") }
        
        Promise.all([deferred1, deferred2, deferred3])
            .then { (object) -> () in
                println("Success for all")
            }
            .catch { (object) -> () in
                println("Error in one - \(object)")
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
        
        deferred1.then { (object) -> () in println("Deferred 1 - \(object)") }
        deferred2.then { (object) -> () in println("Deferred 2 - \(object)") }
        deferred3.then { (object) -> () in println("Deferred 3 - \(object)") }
        
        Promise.all([deferred1, deferred2, deferred3])
            .then { (object) -> () in
                println("Success for all")
            }
            .catch { (object) -> () in
                println("Error in one - \(object)")
            }
            .finally { () -> () in
                println("Finished no matter what")
        }
        
        deferred1.resolve("Woo 1")
        deferred2.reject("Woo 2")
        deferred3.resolve("Woo 3")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

