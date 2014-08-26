# Swift Promises - iOS/Swift

A Swift library for implementing [Q-like](https://github.com/kriskowal/q) promises

```swift
let deferred = Deferred()

let promise = deferred.promise
promise
    .then { (object) -> () in
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


## Author

Josh Holtz, josh@rokkincat.com, [@joshdholtz](https://twitter.com/joshdholtz)

## License

Harmonic is available under the MIT license. See the LICENSE file for more info.
