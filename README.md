# Swift Promises - iOS/Swift

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
    - The always block executes when all promises are no longer pending

## Installation

### Drop-in Classes
Clone the repository and drop in the .swift files from the "Classes" directory into your project.

## Example Usage

### Then, Catch, Finally

```swift
let deferred = Deferred()
        
let promise = deferred.promise
promise
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
```

### When

```swift
let deferred1 = Deferred()
let deferred2 = Deferred()
let deferred3 = Deferred()

deferred1.then { (object) -> () in println("Deferred 1 - \(object)") }
deferred2.then { (object) -> () in println("Deferred 2 - \(object)") }
deferred3.then { (object) -> () in println("Deferred 3 - \(object)") }

When.all([deferred1, deferred2, deferred3])
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
RokkinCat - Hand-Coded in Milwaukee, WI

## License

Harmonic is available under the MIT license. See the LICENSE file for more info.
