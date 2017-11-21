# SwiftBitset

<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift4-compatible-green.svg?style=flat" alt="Swift 4 compatible" /></a>
<a href="https://github.com/apple/swift-package-manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg"/></a>


A bitset class in Swift for fast and concise set operations over integers. Works under both Linux and MacOS.
It is engineered to be really fast, on par with portable C/C++ implementations.

It can be orders of magnitude faster than an IndexSet:

```
$ git clone https://github.com/lemire/SwiftBitsetBenchmark.git
$ cd SwiftBitsetBenchmark
$ swift build  -Xcc -march=native  --configuration release

$ .build/release/SwiftBitsetBenchmark
testAddPerformance  10.693318  ms
testIndexSetAddPerformance  231.737616  ms

testCountPerformance  0.617098  ms
testIndexSetCountPerformance  0.007483  ms

testIteratorPerformance  5.503873  ms
testIndexSetIteratorPerformance  234.289692  ms

testIntersectionPerformance  3.157883  ms
testIndexSetIntersectionPerformance  2774.959423  ms
```

See https://github.com/lemire/SwiftBitsetBenchmark

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
   .package(url: "https://github.com/lemire/SwiftBitset.git",  from: "0.3.0")
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
swift build  -Xcc -march=native  --configuration release
.build/release/fun
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
let d1 = b1 & b2;// intersection
let d2 = b1 | b2;// union
let d3 = b1 &^ b2;// difference
let d4 = b1 ^ b2;// symmetric difference
b1 &= b2;// inplace intersection
b1 |= b2;// inplace union
b1 &^= b2;// inplace difference
b1 ^= b2;// inplace symmetric difference
```

## Usage for contributors

```bash
swift build -Xcc -march=native --configuration release
swift test # optional
```

To dissamble a function...

```bash
swift build -Xcc -march=native --configuration release
lldb ./.build/release/Bitset.build/Bitset.swift.o
disassemble -n intersectionCount
```

To benchmark from the command line:
```
swift test -Xswiftc -Ounchecked -s BitsetTests.BitsetTests/testForEachPerformance
```

For interactive use:
```bash
swift build -Xcc -march=native --configuration release
swift -I .build/release -L .build/release -lBitset
```

## For Xcode users (Mac Only)

```bash
$ swift package generate-xcodeproj
generated: ./Bitset.xcodeproj
$ open ./Bitset.xcodeproj
```

## Licensing

Apache 2.0
