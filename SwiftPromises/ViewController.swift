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
        self.resolveBefore()
        
        self.rejectAfter()
        self.rejectBefore()
        
    }
    
    func resolveAfter() {
        println("\n\nRESOLVED AFTER")
        
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
        
        deferred.resolve("YAY")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

