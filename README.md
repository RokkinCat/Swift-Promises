# Swift Promises - iOS

A Swift library for implementing [Q-like](https://github.com/kriskowal/q) promises. (Note: this library doe snot follow Q 100%)

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

## Installation

### Drop-in Classes
Clone the repository and drop in the .swift files from the "Classes" directory into your project.

## Tutorial

A `Promise` has a `then` function which is used to get the eventual return value of a routine. If the promise gets "resolved", the then closure will get executed with the value getting passed in as a parameter.

```swift
let promise: Promise = getInputPromise()
    .then { (value) -> () in
        // Probably doing something important with this data now
    }
```

If a promise gets "rejected", the closure defined by the `catch` function will be executed with the error value getting passed in as a parameter. 

```swift
let promise: Promise = getInputPromise()
    .catch { (error) -> () in
        // Display error message, log errors
    }
```

Promises also have `finally` function which gets called last on either a "resolved" or "rejected" state promise.

```swift
let promise: Promise = getInputPromise()
    .finally { () -> () in
        // Close connections, do cleanup
    }
```

### Chain `then`, `catch`, and `finally`

`then`, `catch`, and `finally` all return the `Promise` object they were called on which makes for clean looking chaining of calls.

```swift
let promise: Promise = getInputPromise()
    .then { (value) -> () in
        // Probably doing something important with this data now
    }
    .catch { (error) -> () in
        // Display error message, log errors
    }
    .finally { () -> () in
        // Close connections, do cleanup
    }
```

### Returning Values From `then`

Up to this point, the closure passed into the `then` function has not had a return type. The `then` function however can also take a closure that return `AnyObject?`

```swift
let promise: Promise = getPromiseNumber4()
    .then { (value) -> (AnyObject?) in
        return value + 2
    }
```

The above example does not do much of anything. In order to make use of the return we would need to add another call 'then' onto this example. The value that gets passed into each of the `then` closures is what was return from the previous `then` closure. If a closure with no return value is used, then the same value passed into that closure will get passed into the following. 

### Example 1 - Add 2

This following example will add 2 onto the number `4` that is getting resolved from that promise. You will see the value getting returned a `then` is then passed into the next `then` as a parametere

```swift
let promise: Promise = getPromiseNumber4()
    .then { (value) -> (AnyObject?) in
        // value is 4
        return value + 2
    }
    .then { (value) -> (AnyObject?) in
        // value is 6
        return value + 2
    }
    .then { (value) -> (AnyObject?) in
        // value is 8
        return value + 2
    }
    .then { (value) -> () in
        // value is 10
    }
```

### Example 2 - Do nothing

This following example will not do anything with the number `4` that is getting resolved from that promise. You will see the value getting passed to all the `thens` will be 4.

```swift
let promise: Promise = getPromiseNumber4()
    .then { (value) -> () in
        // value is 4
    }
    .then { (value) -> () in
        // value is 4
    }
    .then { (value) -> () in
        // value is 4
    }
    .then { (value) -> () in
        // value is 4
    }
```

### Chaining Promises

The `then` allows `AnyObject?` to be returned which can also include a `Promise` object. When a promise gets returned in a `then` closure, any chained `thens` will not get executed until that promise being return is "resolved". 

To show this, look at the following two code example. These exaples are equivalent

```swift
// getUsername() returns a promise that we attach a "then" to
return getUsername()
    .then { (username) -> (AnyObject?) in
        // when resolved, getUser() gets called which also
        // returns a promise that we attach a "then" too
        getUser(username)
            .then { (user) -> () in
                // when resolved, we know have a user object
                // to do something this
            }
    }
```

The above works great but is a bit ugly and kind of hard to read. What we can do instead is chain two `thens` together

```swift
// getUsername() returns a promise that we attach a "then" to
return getUsername()
    .then { (username) -> (AnyObject?) in
        // when resolved, getUser() gets called which also
        // returns a promise that we attach a "then" too
        return getUser(username)
    }
    .then { (user) -> () in
        // when resolved, we know have a user object
        // to do something this
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

dispatch_after( dispatch_time(5.0, Int64(delay * Double(NSEC_PER_SEC)) ), dispatch_get_main_queue()) { 
    deferred.resolve("Yay stuff")
    
    // or if error
    // deferred.reject("Boo stuff")
}

return deferred.promise
```

### Alternative Promise Creation

```swift
var promise = Promise { (resolve: (AnyObject?) -> (), reject: (AnyObject?) -> ()) -> () in
    // Probably do some logic like an API call or something
    resolve("We got something back from API?")
}
```

## Author

Josh Holtz, josh@rokkincat.com, [@joshdholtz](https://twitter.com/joshdholtz)

[RokkinCat](http://www.rokkincat.com/) - Hand-Coded in Milwaukee, WI

## License

Swift-Promises is available under the MIT license. See the LICENSE file for more info.
