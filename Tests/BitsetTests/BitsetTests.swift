import XCTest
import Foundation
@testable import Bitset
class BitsetTests: XCTestCase {
  func testAddPerformance() {
    measure {
      let b = Bitset()
      for i in stride(from: 0, to: 100_000_000, by: 100) {
          b.add(i)
      }
    }
  }

  func testCountPerformance() {
    let b1 = Bitset()
    for i in stride(from: 0, to: 100_000_000, by: 100) {
          b1.add(i)
    }
    measure {
      _ = b1.count()
    }
  }

  func testIteratorPerformance() {
    let b1 = Bitset()
    for i in stride(from: 0, to: 100_000_000, by: 100) {
          b1.add(i)
    }
    var sum = 0
    measure {
      for _ in  b1 {
        sum = sum &+ 1
      }
    }
  }

  func testForEachPerformance() {
    let b1 = Bitset()
    for i in stride(from: 0, to: 100_000_000, by: 100) {
          b1.add(i)
    }
    var sum = 0
    measure {
      b1.forEach({ _ in
        sum = sum &+ 1
      })
    }
  }

  func testUnionPerformance() {
    let b1 = Bitset()
    for i in stride(from: 0, to: 100_000_000, by: 100) {
          b1.add(i)
    }
    let b2 = Bitset()
    for i in stride(from: 0, to: 1_000_000_000, by: 99) {
          b2.add(i)
    }
    var sum = 0
    measure {
      let z = Bitset(b1)
      z |= b2
      sum += z.count()
    }
  }

  func testSetGet() {
    let b = Bitset()
    XCTAssertEqual(b.isEmpty(), true, "Bad empty")
    print(b)
    b.add(1)
    print(b)
    b.add(63)
    print(b.hashValue)
    print(b)
    XCTAssertEqual(b.isEmpty(), false, "Bad empty")
    XCTAssertEqual(b.contains(1), true, "Bad set/get")
    XCTAssertEqual(b.contains(63), true, "Bad set/get")
    XCTAssertEqual(b.count(), 2, "Bad count")
  }

  func testLiteral() {
    let b1: Bitset = [1, 2, 3]
    let b2 = Bitset (arrayLiteral: 1, 2, 3)
    XCTAssertEqual(b1, b2, "Bad litteral")
    XCTAssertEqual(b1.contains(1), true, "Bad set/get")
    XCTAssertEqual(b1.contains(2), true, "Bad set/get")
    XCTAssertEqual(b1.contains(3), true, "Bad set/get")
    XCTAssertEqual(b1[1], true, "Bad set/get")
    XCTAssertEqual(b1[2], true, "Bad set/get")
    XCTAssertEqual(b1[3], true, "Bad set/get")
    XCTAssertEqual(b1.count(), 3, "Bad count")
  }

  func testSetGetLarge() {
    let b = Bitset()
    b.add(Int(UInt16.max))
    XCTAssertEqual(b.contains(Int(UInt16.max)), true, "Bad set/get")
    if Int.max != Int(UInt16.max) {
      XCTAssertEqual(b.contains(Int.max), false, "Bad set/get")
    }
    XCTAssertEqual(b.count(), 1, "Bad count")
  }
  func testRemove() {
    let b = Bitset(arrayLiteral: 1, 4, 10, 1000, 10000)
    print(b)
    XCTAssertEqual(b.count(), 5, "Bad count")
    for i in b {
      b.remove(i)
    }
    XCTAssertEqual(b.count(), 0, "Bad count")
  }

  func testIntersection() {
    let b1 = Bitset(arrayLiteral: 1, 4, 10, 1000, 10000)
    let b2 = Bitset(arrayLiteral: 1, 3, 10, 1000)
    let bexpected = Bitset(arrayLiteral: 1, 10, 1000)
    b2.intersection(b1)
    XCTAssertEqual(b2, bexpected, "Bad intersection")
    XCTAssertEqual(b2.count(), 3, "Bad intersection count")
  }

  func testOperator1() {
    let b1 = Bitset(arrayLiteral: 1, 4, 10, 1000, 10000)
    print(b1)
    let b2 = Bitset(arrayLiteral: 1, 3, 10, 1000)
    print(b2)
    let B1 = Bitset(b1)
    print(B1)
    let B2 = Bitset(b2)
    print(B2)

    b2 ^= b1
    B2.symmetricDifference(B1)
    XCTAssertEqual(B2, b2, "Bad operator")
  }
  func testOperator2() {
    let b1 = Bitset(arrayLiteral: 1, 4, 10, 1000, 10000)
    let b2 = Bitset(arrayLiteral: 1, 3, 10, 1000)
    let B1 = Bitset(b1)
    let B2 = Bitset(b2)

    let b3 = b2 ^ b1
    B2.symmetricDifference(B1)
    XCTAssertEqual(B2, b3, "Bad operator")
  }

  func testOperator3() {
    let b1 = Bitset(arrayLiteral: 1, 4, 10, 1000, 10000)
    let b2 = Bitset(arrayLiteral: 1, 3, 10, 1000)
    let B1 = Bitset(b1)
    let B2 = Bitset(b2)

    b2 &= b1
    B2.intersection(B1)
    XCTAssertEqual(B2, b2, "Bad operator")
  }
  func testOperator4() {
    let b1 = Bitset(arrayLiteral: 1, 4, 10, 1000, 10000)
    let b2 = Bitset(arrayLiteral: 1, 3, 10, 1000)
    let B1 = Bitset(b1)
    let B2 = Bitset(b2)

    let b3 = b2 & b1
    B2.intersection(B1)
    XCTAssertEqual(B2, b3, "Bad operator")
  }

  func testOperator5() {
    let b1 = Bitset(arrayLiteral: 1, 4, 10, 1000, 10000)
    let b2 = Bitset(arrayLiteral: 1, 3, 10, 1000)
    let B1 = Bitset(b1)
    let B2 = Bitset(b2)

    b2 |= b1
    B2.union(B1)
    XCTAssertEqual(B2, b2, "Bad operator")
  }

  func testOperator6() {
    let b1 = Bitset(arrayLiteral: 1, 4, 10, 1000, 10000)
    let b2 = Bitset(arrayLiteral: 1, 3, 10, 1000)
    let B1 = Bitset(b1)
    let B2 = Bitset(b2)

    let b3 = b2 | b1
    B2.union(B1)
    XCTAssertEqual(B2, b3, "Bad operator")
  }

  func testOperator7() {
    let b1 = Bitset(arrayLiteral: 1, 4, 10, 1000, 10000)
    let b2 = Bitset(arrayLiteral: 1, 3, 10, 1000)
    let B1 = Bitset(b1)
    let B2 = Bitset(b2)

    b2 -= b1
    B2.difference(B1)
    XCTAssertEqual(B2, b2, "Bad operator")
  }
  func testOperator8() {
    let b1 = Bitset(arrayLiteral: 1, 4, 10, 1000, 10000)
    let b2 = Bitset(arrayLiteral: 1, 3, 10, 1000)
    let B1 = Bitset(b1)
    let B2 = Bitset(b2)

    let b3 = b2 - b1
    B2.difference(B1)
    XCTAssertEqual(B2, b3, "Bad operator")
  }

  func testIntersection2() {
    let b1 = Bitset(arrayLiteral: 1, 4, 10, 1000, 10000)
    XCTAssertEqual(b1.contains(4), true, "Bad init")
    XCTAssertEqual(b1.contains(5), false, "Bad init")
    let b2 =  Bitset(arrayLiteral: 1, 3, 10, 1000)
    let bexpected = Bitset(arrayLiteral: 1, 10, 1000)
    b1.intersection(b2)
    XCTAssertEqual(b1, bexpected, "Bad intersection")
  }

  func testExample() {
    let b1 = Bitset()
    b1.add(10000)                          // can add one
    b1.addMany(1, 4, 10, 1000, 10000); // can add many
    let b2 = Bitset()
    b2.addMany(1, 3, 10, 1000)
    let bexpected = Bitset(arrayLiteral: 1, 3, 4, 10, 1000, 10000); // can init with list
    b2.union(b1)
    XCTAssertEqual(b2.count(), 6, "Bad example")
    XCTAssertEqual(b2, bexpected, "Bad example")
    bexpected.intersection(b1)
    XCTAssertEqual(b1, bexpected, "Bad example")
    var count = 0
    for i in b1 {
       print(i)
       count += 1
    }
    XCTAssertEqual(b1.count(), count, "Bad example")
     // will print 1 4 10 1000 10000
    _ = b1 & b2;// intersection
    _ = b1 | b2;// union
    _ = b1 - b2;// difference
    _ = b1 ^ b2;// symmetric difference
    b1 &= b2;// inplace intersection
    b1 |= b2;// inplace union
    b1 -= b2;// inplace difference
    b1 ^= b2;// inplace symmetric difference
  }

  func testIterator() {
    let b = Bitset(arrayLiteral: 30, 30 + 30, 30 + 30 + 30, 30 + 30 + 30 + 30)
    var counter = 30
    for x in b {
     XCTAssertEqual(x, counter, "Bad iter")
     counter += 30
   }
  }

  func testUnion() {
    let b1 = Bitset()
    b1.addMany(1, 4, 10, 1000, 10000)
    let b2 = Bitset()
    b2.addMany(1, 3, 10, 1000)
    let bexpected = Bitset()
    bexpected.addMany(1, 3, 4, 10, 1000, 10000)
    b2.union(b1)
    XCTAssertEqual(b2, bexpected, "Bad intersection")
  }

  func testDeserialisation() {
    let d1 = Data([UInt8]([
      0b00000001, 0, 0, 0, 0, 0, 0, 0b01000000, // first word: 8-bytes
      0b00000100, 0, 0, 0, 0, 0, 0b00010000 // second word: 7-bytes
    ]))
    let d2 = Data([UInt8]([
      0b00000010, 0, 0, 0, 0, 0, 0, 0b10100000, // first word: 8-bytes
      0b00001010, 0, 0, 0, 0, 0, 0b00101000 // second word: 7-bytes
    ]))
    let b1 = Bitset(bytes: d1)
    let b2 = Bitset([0, 62, 66, 116])
    let b3 = Bitset(bytes: d2)
    XCTAssertEqual(b1.count(), 4)
    XCTAssertEqual(b1.wordcount, 2)
    XCTAssertEqual(b1.symmetricDifferenceCount(b2), 0)
    XCTAssertEqual(b1.symmetricDifferenceCount(b3), 11)
  }

  func testSerialisation() {
    let b1 = Bitset([0, 62, 66, 116])
    let d1 = b1.toData()
    let d2 = Data([UInt8]([
      0b00000001, 0, 0, 0, 0, 0, 0, 0b01000000, // first word: 8-bytes
      0b00000100, 0, 0, 0, 0, 0, 0b00010000 // second word: 7-bytes
    ]))
    XCTAssertEqual(d1.count, d2.count)
    for idx in 0..<d1.count {
      XCTAssertEqual(d1[idx], d2[idx])
    }
  }

  func testSerialisationAtBoundaries() {
    let d0 = Data([UInt8]([ 0, 0, 0, 0, 0, 0, 0, 0 ])) // zero
    let d1 = Data([UInt8]([ 0b1 ])) // first bit set
    let d2 = Data([UInt8]([ // first bit of second word set
      0, 0, 0, 0, 0, 0, 0, 0, // first word: 8-bytes
      0b00000001 // second word: 1-byte
    ]))
    let b0 = Bitset(bytes: d0)
    let b1 = Bitset(bytes: d1)
    let b2 = Bitset(bytes: d2)
    let b0_comp = Bitset()
    let b1_comp = Bitset([0])
    let b2_comp = Bitset([64])
    let d0_comp = b0.toData()
    let d1_comp = b1.toData()
    let d2_comp = b2.toData()
    XCTAssertEqual(b0.count(), 0)
    XCTAssertEqual(b0.wordcount, 1)
    XCTAssertEqual(b0.symmetricDifferenceCount(b0_comp), 0)
    XCTAssertEqual(Data(), d0_comp)
    XCTAssertEqual(b1.count(), 1)
    XCTAssertEqual(b1.wordcount, 1)
    XCTAssertEqual(d1_comp.count, 1)
    XCTAssertEqual(b1.symmetricDifferenceCount(b1_comp), 0)
    XCTAssertEqual(d1, d1_comp)
    XCTAssertEqual(b2.count(), 1)
    XCTAssertEqual(b2.wordcount, 2)
    XCTAssertEqual(d2_comp.count, 9)
    XCTAssertEqual(b2.symmetricDifferenceCount(b2_comp), 0)
    XCTAssertEqual(d2, d2_comp)
  }

}

#if os(Linux)
extension BitsetTests {
  static var allTests: [(String, (BitsetTests) -> () throws->())] {
    return [
      ("testUnion", testUnion),
      ("testIterator", testIterator),
      ("testExample", testExample),
      ("testIntersection2", testIntersection2),
      ("testIntersection", testIntersection),
      ("testSetGet", testSetGet),
      ("testSetGetLarge", testSetGetLarge),
      ("testRemove()", testRemove),
      ("testOperator1()", testOperator1),
      ("testOperator2()", testOperator2),
      ("testOperator3()", testOperator3),
      ("testOperator4()", testOperator4),
      ("testOperator5()", testOperator5),
      ("testOperator6()", testOperator6),
      ("testOperator7()", testOperator7),
      ("testOperator8()", testOperator8),
      ("testLiteral()", testLiteral),
      ("testAddPerformance()", testAddPerformance),
      ("testCountPerformance()", testCountPerformance),
      ("testIteratorPerformance()", testIteratorPerformance)
    ]
  }
}
#endif
