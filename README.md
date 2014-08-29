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

#### Example 1 - Add 2

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

#### Example 2 - Do nothing

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
    .catch { (error) -> () in
        // Catches a "reject" by either of the promises
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
    .catch { (error) -> () in
        // Catches a "reject" by either of the promises
    }
```

### All

Chaining `thens` together works great when you have a promise that dpends on another promise. But sometimes you would like to perform multiple asynchronous tasks and get notified when all are complete. To do that, we make use `all`.

To use `all`, pass in an array of promises. When al the promises get "resolved", the `then` closure will get called. If one of the promises gets "rejected", the `catch` closure will get called.

The `values` that gets passed into the `then` closure will be an array of values in order that the promises were passed in.

```swift
Promise.all( [ getSomething1(), getSomething2()  ] )
    .then { (values) -> () in
        // Returns array of value in same order promises passed in
    }
    .catch { (error) -> () in
    
    }

```

### Getting individual progress

If you need to get the invidual progress of any of the promises passed in to the all, you can simply add a then onto the individual promises themselves

```swift
let promise1 = getSomething1().then { (values) -> () in println("Do something 1")  }
let promise2 = getSomething2().then { (values) -> () in println("Do something 2")  }

Promise.all( [ promise1, promise2  ] )
    .then { (values) -> () in
    
    }
    .catch { (error) -> () in
    
    }
```


### Using Deferreds

Up to this point you have seen function examples that have been `getUsername()` or `getPromseNumber4()`. These methods have returned promises for you to use but we have not seen anything yet on to make a promise as "resolved" or "rejected". That is exactly what a `Deferred` object is used for. A `Deferred` is a `Promise` but allows "write" ability to it to make it has "resolved" or "rejected".  A `Deferred` object would usually be encapsulated in a function.

### Resolved

```swift
func getPromseNumber4() -> Promise {
    let deferred = Deferred()
    
    // This dispatch_after does not need to be here but we all like dramatic effect
    dispatch_after( dispatch_time(5.0, Int64(delay * Double(NSEC_PER_SEC)) ), dispatch_get_main_queue()) { 
        // This runs any closures defined by the "then" function described above
        deferred.resolve(4)
    }
    
    return deferred.promise
}
```

### Rejected

```swift
func getTheLimit() -> Promise {
    let deferred = Deferred()
    
    // This dispatch_after does not need to be here but we all like dramatic effect
    dispatch_after( dispatch_time(5.0, Int64(delay * Double(NSEC_PER_SEC)) ), dispatch_get_main_queue()) { 
        // This runs the clsured defined by the "catch" function described above
        deferred.reject("The limit does not exist")
    }
    
    return deferred.promise
}
```

### Alternative Promise Creation

Sometimes using a `Deferred` can be too much overhead. What you can do instead is create a promise takes a closure in as a parametere which contains its own paremeters for the "resolve" and "reject" functions"

```swift
var promise = Promise { (resolve: (AnyObject?) -> (), reject: (AnyObject?) -> ()) -> () in
    // Probably do some logic like an API call or something
    response = API.login()
    if (response.success) {
        resolve(response.user)
    } else {
        reject(response.error)
    }
}
```

## Author

Josh Holtz, josh@rokkincat.com, [@joshdholtz](https://twitter.com/joshdholtz)

[RokkinCat](http://www.rokkincat.com/) - Hand-Coded in Milwaukee, WI

## License

Swift-Promises is available under the MIT license. See the LICENSE file for more info.
