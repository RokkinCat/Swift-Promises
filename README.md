# Swift Promises - iOS

A Swift library for implementing [Q-like](https://github.com/kriskowal/q) promises

```swift
let deferred = Deferred()

let promise = deferred.promise
promise.then { (object) -> () in
    println("Then 1 - \(object)")
}

deferred.resolve("YAY")
```

### Updates

Version | Changes
--- | ---
**0.1.0** | Initial release

### Features
- `Deferred` objects (the controller for the promise) are used change state for promise behavior which triggers callbacks
- `Promise` objects are just read-only `Deferred` objects
- Add then, catch, and finally blocks to a `Deferred` or `Promise` object
- Call `When.all` to link `Promise` objects together
    - The then block executes when all promise object states are "resolved"
    - The catch block executes when one promise object state is "rejected"
    - The finally block executes when all promises are no longer pending

## Installation

### Drop-in Classes
Clone the repository and drop in the .swift files from the "Classes" directory into your project.

## Example Usage

### Then, Catch, Finally

```swift
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
```

### Chaining

```swift
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
```

### All

```swift
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
```


## Author

Josh Holtz, josh@rokkincat.com, [@joshdholtz](https://twitter.com/joshdholtz)

[RokkinCat](http://www.rokkincat.com/) - Hand-Coded in Milwaukee, WI

## License

Swift-Promises is available under the MIT license. See the LICENSE file for more info.
