import XCTest
@testable import Bitset
class BitsetTests : XCTestCase {
  func testAddPerformance() {
    measure() {
      let b = Bitset();
      for i in stride(from: 0, to: 100_000_000, by: 100){
          b.add(i)
      }
    }
  }

  func testCountPerformance() {
    let b1 = Bitset();
    for i in stride(from: 0, to: 100_000_000, by: 100){
          b1.add(i)
    }
    measure() {
      let _ = b1.count();
    }
  }


  func testIteratorPerformance() {
    let b1 = Bitset();
    for i in stride(from: 0, to: 100_000_000, by: 100){
          b1.add(i)
    }
    var sum = 0;
    measure() {
      for _ in  b1 {
        sum += 1;
      }
    }
  }



  func testUnionPerformance() {
    let b1 = Bitset();
    for i in stride(from: 0, to: 100_000_000, by: 100){
          b1.add(i)
    }
    let b2 = Bitset();
    for i in stride(from: 0, to: 1_000_000_000, by: 99){
          b1.add(i)
    }
    var sum = 0
    measure() {
      let z = Bitset(b1);
      z |= b2;
      sum += z.count();
    }
  }
  
  func testSetGet() {
    let b = Bitset();
    XCTAssertEqual(b.isEmpty(), true, "Bad empty");
    print(b);
    b.add(1);
    print(b);
    b.add(63);
    print(b.hashValue);
    print(b);
    XCTAssertEqual(b.isEmpty(), false, "Bad empty");
    XCTAssertEqual(b.contains(1), true, "Bad set/get");
    XCTAssertEqual(b.contains(63), true, "Bad set/get");
    XCTAssertEqual(b.count(), 2, "Bad count");
  }

  func testLiteral() {
    let b1 : Bitset = [1, 2, 3];
    let b2 = Bitset (1,2,3);
    XCTAssertEqual(b1, b2, "Bad litteral");
    XCTAssertEqual(b1.contains(1), true, "Bad set/get");
    XCTAssertEqual(b1.contains(2), true, "Bad set/get");
    XCTAssertEqual(b1.contains(3), true, "Bad set/get");
    XCTAssertEqual(b1[1], true, "Bad set/get");
    XCTAssertEqual(b1[2], true, "Bad set/get");
    XCTAssertEqual(b1[3], true, "Bad set/get");
    XCTAssertEqual(b1.count(), 3, "Bad count");
  }

  func testSetGetLarge() {
    let b = Bitset();
    b.add(Int(UInt16.max));
    XCTAssertEqual(b.contains(Int(UInt16.max)), true, "Bad set/get");
    if Int.max != Int(UInt16.max) {
      XCTAssertEqual(b.contains(Int.max), false, "Bad set/get");
    }
    XCTAssertEqual(b.count(), 1, "Bad count");
  }
  func testRemove() {
    let b = Bitset(1, 4, 10, 1000, 10000);
    print(b);
    XCTAssertEqual(b.count(), 5, "Bad count");
    for i in b {
      b.remove(i)
    }
    XCTAssertEqual(b.count(), 0, "Bad count");
  }

  func testIntersection() {
    let b1 = Bitset(1, 4, 10, 1000, 10000);
    let b2 = Bitset(1, 3, 10, 1000);
    let bexpected = Bitset(1, 10, 1000);
    b2.intersection(b1);
    XCTAssertEqual(b2, bexpected, "Bad intersection");
    XCTAssertEqual(b2.count(), 3, "Bad intersection count");
  }

  func testOperator1() {
    let b1 = Bitset(1, 4, 10, 1000, 10000);
    let b2 = Bitset(1, 3, 10, 1000);
    let B1 = Bitset(b1);
    let B2 = Bitset(b2);

    b2 ^= b1
    B2.symmetricDifference(B1)
    XCTAssertEqual(B2, b2, "Bad operator");
  }
  func testOperator2() {
    let b1 = Bitset(1, 4, 10, 1000, 10000);
    let b2 = Bitset(1, 3, 10, 1000);
    let B1 = Bitset(b1);
    let B2 = Bitset(b2);

    let b3 = b2 ^ b1
    B2.symmetricDifference(B1)
    XCTAssertEqual(B2, b3, "Bad operator");
  }

  func testOperator3() {
    let b1 = Bitset(1, 4, 10, 1000, 10000);
    let b2 = Bitset(1, 3, 10, 1000);
    let B1 = Bitset(b1);
    let B2 = Bitset(b2);

    b2 &= b1
    B2.intersection(B1)
    XCTAssertEqual(B2, b2, "Bad operator");
  }
  func testOperator4() {
    let b1 = Bitset(1, 4, 10, 1000, 10000);
    let b2 = Bitset(1, 3, 10, 1000);
    let B1 = Bitset(b1);
    let B2 = Bitset(b2);

    let b3 = b2 & b1
    B2.intersection(B1)
    XCTAssertEqual(B2, b3, "Bad operator");
  }

  func testOperator5() {
    let b1 = Bitset(1, 4, 10, 1000, 10000);
    let b2 = Bitset(1, 3, 10, 1000);
    let B1 = Bitset(b1);
    let B2 = Bitset(b2);

    b2 |= b1
    B2.union(B1)
    XCTAssertEqual(B2, b2, "Bad operator");
  }

  func testOperator6() {
    let b1 = Bitset(1, 4, 10, 1000, 10000);
    let b2 = Bitset(1, 3, 10, 1000);
    let B1 = Bitset(b1);
    let B2 = Bitset(b2);

    let b3 = b2 | b1
    B2.union(B1)
    XCTAssertEqual(B2, b3, "Bad operator");
  }

  func testOperator7() {
    let b1 = Bitset(1, 4, 10, 1000, 10000);
    let b2 = Bitset(1, 3, 10, 1000);
    let B1 = Bitset(b1);
    let B2 = Bitset(b2);

    b2 &^= b1
    B2.difference(B1)
    XCTAssertEqual(B2, b2, "Bad operator");
  }
  func testOperator8() {
    let b1 = Bitset(1, 4, 10, 1000, 10000);
    let b2 = Bitset(1, 3, 10, 1000);
    let B1 = Bitset(b1);
    let B2 = Bitset(b2);

    let b3 = b2 &^ b1
    B2.difference(B1)
    XCTAssertEqual(B2, b3, "Bad operator");
  }

  func testIntersection2() {
    let b1 = Bitset(1, 4, 10, 1000, 10000);
    XCTAssertEqual(b1.contains(4), true, "Bad init");
    XCTAssertEqual(b1.contains(5), false, "Bad init");
    let b2 =  Bitset(1, 3, 10, 1000);
    let bexpected = Bitset(1, 10, 1000);
    b1.intersection(b2);
    XCTAssertEqual(b1, bexpected, "Bad intersection");
  }

  func testExample() {
    let b1 = Bitset();
    b1.add(10000)                          // can add one
    b1.addMany(1, 4, 10, 1000, 10000); // can add many
    let b2 = Bitset();
    b2.addMany(1, 3, 10, 1000);
    let bexpected = Bitset(1, 3, 4, 10, 1000, 10000); // can init with list
    b2.union(b1)
    XCTAssertEqual(b2.count(), 6, "Bad example");
    XCTAssertEqual(b2, bexpected, "Bad example");
    bexpected.intersection(b1);
    XCTAssertEqual(b1, bexpected, "Bad example");
    for i in b1 {
       print(i)
    }
     // will print 1 4 10 1000 10000
    let _ = b1 & b2;// intersection
    let _ = b1 | b2;// union
    let _ = b1 &^ b2;// difference
    let _ = b1 ^ b2;// symmetric difference
    b1 &= b2;// inplace intersection
    b1 |= b2;// inplace union
    b1 &^= b2;// inplace difference
    b1 ^= b2;// inplace symmetric difference
  }

  func testIterator() {
    let b = Bitset(30, 30 + 30, 30 + 30 + 30, 30 + 30 + 30 + 30);
    var counter = 30;
    for x in b {
     XCTAssertEqual(x, counter, "Bad iter");
     counter += 30;
   }
  }

  func testUnion() {
    let b1 = Bitset();
    b1.addMany(1, 4, 10, 1000, 10000);
    let b2 = Bitset();
    b2.addMany(1, 3, 10, 1000);
    let bexpected = Bitset();
    bexpected.addMany(1, 3, 4, 10, 1000, 10000);
    b2.union(b1);
    XCTAssertEqual(b2, bexpected, "Bad intersection")
  }

}

#if os(Linux)
extension TodoTests {
  static var allTests : [(String, TodoTests->() throws->Void)] {
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
      ("testAddPerformance()", testPerformance),
      ("testCountPerformance()", testPerformance),
      ("testIteratorPerformance()", testPerformance)
    ]
  }
}
#endif
