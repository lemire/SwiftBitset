# SwiftBitset

[![Swift 3.0](https://img.shields.io/badge/swift-3.0-orange.svg)](https://swift.org)


A bitset class in Swift for fast and concise set operations over integers.



## Complete example for library users

Create a directory where you will create your application:

```bash
mkdir fun
cd fun
swift package init --type executable
```

Then edit ``Package.swift`` so that it reads:


```swift
import PackageDescription

let package = Package(
    name: "fun",
    dependencies: [
   .Package(url: "https://github.com/lemire/SwiftBitset.git",  majorVersion: 0)
    ]
)
```

Edit ``Sources/main.swift`` so that it looks something like this :

```swift
import Bitset;

let b1 = Bitset (1,4,10,1000,10000);
for i in b1 {
  print(i)
}
```

You can run your example as follows:

```bash    
swift build
.build/debug/fun
```


## Code example

```swift
import Bitset;

let b1 = Bitset ();
b1.add(10000) // can add one
b1.addMany(1,4,10,1000,10000); // can add many
let b2 = Bitset ();
b2.addMany(1,3,10,1000);
let bexpected = Bitset (1,3,4,10,1000,10000); // can init with list
b2.union(b1)
print(b2.count() == 6) // print true
print(b2 == bexpected) // print true
bexpected.intersection(b1)
print(b1 == bexpected) // print true
for i in b1 {
  print(i)
}
// will print 1 4 10 1000 10000
b1.remove(4) // can remove values
```

## Usage for contributors

```bash
swift build
swift test # optional
```


## Licensing

Apache 2.0
