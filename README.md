# SwiftBitset

[![Swift 3.0](https://img.shields.io/badge/swift-3.0-orange.svg)](https://swift.org)


A fast bitset class in Swift for fast and concise set operations over integers.

## Pre-requisite

Swift 3.0 or better.

## Example

```swift
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

## Usage

```bash
swift build
swift test # optional
```

## Licensing

Apache 2.0
