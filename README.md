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
- Call `Promise.all` to link `Promise` objects together
    - The then block executes when all promise object states are "resolved"
    - The catch block executes when one promise object state is "rejected"
    - The finally block executes when all promises are no longer pending

## Installation

### Drop-in Classes
Clone the repository and drop in the .swift files from the "Classes" directory into your project.

## Tutorial

```swift
promiseMeSomething()
    .then { (value) -> () in
        
    }
    .catch { (error) -> () in
        println("Catch - \(error)")
    }
```

### Propagation

```swift
let promise: Promise = getInputPromise()
    .then { (value) -> () in

    }
```

```swift
let promise: Promise = getInputPromise()
    .catch { (value) -> () in

    }
```

```swift
let promise: Promise = getInputPromise()
    .finally { (value) -> () in

    }
```

### Chaining

```swift
return getUsername()
    .then { (username) -> (AnyObject?) in
        getUser(username)
            .then { (user) -> () in
        
            }
    }
```

```swift
return getUsername()
    .then { (username) -> (AnyObject?) in
        return getUser(username)
    }
    .then { (user) -> () in
    
    }
```

### All

```swift
Promise.all( [ getSomething1(), getSomething2()  ] )
    .then { (values) -> () in
    
    }
    .catch { (values) -> () in
    
    }

```

### Using Deferreds

```swift
let deferred = Deferred()

dispatch_after(1, dispatch_get_main_queue()) { 
    deferred.resolve("Yay stuff")
    
    // or if error
    // deferred.reject("Boo stuff")
}

return deferred.promise
```

## Author

Josh Holtz, josh@rokkincat.com, [@joshdholtz](https://twitter.com/joshdholtz)

[RokkinCat](http://www.rokkincat.com/) - Hand-Coded in Milwaukee, WI

## License

Swift-Promises is available under the MIT license. See the LICENSE file for more info.
