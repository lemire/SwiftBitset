
infix operator &^;// andNot
infix operator &^=;// andNot

private extension Int64 {
    func toUInt64() -> UInt64 { return UInt64(bitPattern:self) }
    func toInt() -> Int { return Int(truncatingIfNeeded:self) }
}

private extension UInt64 {
    func toInt64() -> Int64 { return Int64(bitPattern:self) }
    func toInt() -> Int { return Int(truncatingIfNeeded:self) }
}

// a class that can be used as an efficient set container for non-negative integers
public final class Bitset: Sequence, Equatable, CustomStringConvertible,
                           Hashable, ExpressibleByArrayLiteral {
  var capacity = 8 // how many words have been allocated
  var wordcount = 0 // how many words are used

  var data: UnsafeMutablePointer<UInt64> // we are going to manage our own memory

  // copy construction
  public init(_ other: Bitset) {
    capacity = other.wordcount
    wordcount = other.wordcount
    data = UnsafeMutablePointer<UInt64>.allocate(capacity:capacity)
    for i in 0..<capacity {
      data[i] = other.data[i]
    }
  }

  public init() {
    data = UnsafeMutablePointer<UInt64>.allocate(capacity:capacity)
    wordcount = 0
  }

  deinit {
    data.deallocate(capacity:capacity)
  }

  // make a bitset containing the list of integers, all values must be non-negative
  // adding the value i to the bitset will cause the use of least (i+8)/8 bytes
  public init(_ allints: Int...) {
      var mymax = 0
      for i in allints { mymax = mymax < i ? i : mymax }
      wordcount = (mymax+63)/64 + 1
      capacity = wordcount
      data = UnsafeMutablePointer<UInt64>.allocate(capacity:wordcount)
      for k in 0..<wordcount {
        data[k] = 0
      }
      addMany(allints)
  }

  // initializing from array literal
  public init(arrayLiteral elements: Int...) {
      var mymax = 0
      for i in elements { mymax = mymax < i ? i : mymax }
      wordcount = (mymax+63)/64 + 1
      capacity = wordcount
      data = UnsafeMutablePointer<UInt64>.allocate(capacity:wordcount)
      for k in 0..<wordcount {
          data[k] = 0
      }
      for i in elements { add(i) }
  }

  public typealias Element = Int

  // return an empty bitset
  public static var allZeros: Bitset { return Bitset() }

  // union between two bitsets, producing a new bitset
  public static func | (lhs: Bitset, rhs: Bitset) -> Bitset {
    let mycopy = Bitset(lhs)
    mycopy.union(rhs)
    return mycopy
  }

  // compute the union between two bitsets inplace
  public static func |= (lhs: Bitset, rhs: Bitset) {
    lhs.union(rhs)
  }

  // difference between two bitsets, producing a new bitset
  public static func &^ (lhs: Bitset, rhs: Bitset) -> Bitset {
    let mycopy = Bitset(lhs)
    mycopy.difference(rhs)
    return mycopy
  }

  // inplace difference between two bitsets
  public static func &^= (lhs: Bitset, rhs: Bitset) {
    lhs.difference(rhs)
  }

  // symmetric difference between two bitsets, producing a new bitset
  public static func ^ (lhs: Bitset, rhs: Bitset) -> Bitset {
    let mycopy = Bitset(lhs)
    mycopy.symmetricDifference(rhs)
    return mycopy
  }

  // inplace symmetric difference between two bitsets
  public static func ^= (lhs: Bitset, rhs: Bitset) {
    lhs.symmetricDifference(rhs)
  }

  // compute the union between two bitsets inplace
  public static func &= (lhs: Bitset, rhs: Bitset) {
    lhs.intersection(rhs)
  }

  // computes the intersection between two bitsets and return a new bitset
  public static func & (lhs: Bitset, rhs: Bitset) -> Bitset {
    let mycopy = Bitset(lhs)
    mycopy.intersection(rhs)
    return mycopy
  }

  // hash value for the bitset
  public var hashValue: Int {
      let b: UInt64 = 31
      var hash: UInt64 = 0
      for i in 0..<wordcount {
        let w = data[i]
        hash = hash &* b &+ w
      }
      hash = hash ^ ( hash >> 33)
      hash = hash &* 0xff51afd7ed558ccd
      hash = hash ^ ( hash >> 33)
      hash = hash &* 0xc4ceb9fe1a85ec53
      return hash.toInt()
  }

  // presents a string representation of the bitset
  public var description: String {
    var ret = prefix(100).map { $0.description }.joined(separator: ", ")
    if count() >= 100 {
        ret.append(", ...")
    }
    return "{\(ret)}"
  }

  // create an iterator over the values contained in the bitset
  public func makeIterator() -> BitsetIterator {
    return BitsetIterator(self)
  }

  // count how many values have been stored in the bitset (this function is not free of computation)
  public func count() -> Int {
    var sum: Int = 0
    for i in 0..<wordcount {
      let w = data[i]
      sum = sum &+ w.nonzeroBitCount
    }
    return sum
  }

  // proxy for "count"
  public func cardinality() -> Int { return count() }

  // add a value to the bitset, all values must be non-negative
  // adding the value i to the bitset will cause the use of least (i+8)/8 bytes
  public func add(_ value: Int) {
    let index = value >> 6
    if index >= self.wordcount { increaseWordCount( index + 1) }
    data[index] |= 1 << (UInt64(value & 63))
  }

  // add all the values  to the bitset
  // adding the value i to the bitset will cause the use of least (i+8)/8 bytes
  public func addMany(_ allints: Int...) {
    var mymax = 0
    for i in allints { mymax = mymax < i ? i : mymax }
    let maxindex = mymax >> 6
    if maxindex >= self.wordcount {
      increaseWordCount(maxindex + 1)
    }
    for i in allints { add(i) }
  }

  // add all the values  to the bitset
  // adding the value i to the bitset will cause the use of least (i+8)/8 bytes
  public func addMany(_ allints: [Int]) {
    var mymax = 0
    for i in allints { mymax = mymax < i ? i : mymax }
    let maxindex = mymax >> 6
    if maxindex >= self.wordcount {
        increaseWordCount(maxindex + 1)
    }
    for i in allints { add(i) }
  }

  // check that a value is in the bitset, all values must be non-negative
  public func contains(_ value: Int) -> Bool {
    let index = value >> 6
    if index >= self.wordcount { return false }
    return data[index] & (1 << (UInt64(value & 63))) != 0
  }

  public subscript(value: Int) -> Bool {
    get {
        return contains(value)
    }
    set(newValue) {
        if newValue { add(value)} else {remove(value)}
    }
  }

  // compute the intersection (in place) with another bitset
  public func intersection(_ other: Bitset) {
    let mincount = Swift.min(self.wordcount, other.wordcount)
    for i in 0..<mincount { data[i] &= other.data[i] }
    for i in mincount..<self.wordcount { data[i] = 0 }
  }

  // compute the size of the intersection with another bitset
  public func intersectionCount(_ other: Bitset) -> Int {
    let mincount = Swift.min(self.wordcount, other.wordcount)
    var sum = 0
    for i in 0..<mincount { sum = sum &+ ( data[i] & other.data[i]).nonzeroBitCount }
    return sum
  }

  // compute the union (in place) with another bitset
  public func union(_ other: Bitset) {
    let mincount = Swift.min(self.wordcount, other.wordcount)
    for  i in 0..<mincount {
      data[i] |= other.data[i]
    }
    if other.wordcount > self.wordcount {
      self.matchWordCapacity(other.wordcount)
      self.wordcount = other.wordcount
      for i in mincount..<other.wordcount {
        data[i] = other.data[i]
      }
    }
  }

  // compute the size union  with another bitset
  public func unionCount(_ other: Bitset) -> Int {
    let mincount = Swift.min(self.wordcount, other.wordcount)
    var sum = 0
    for  i in 0..<mincount {
      sum = sum &+ (data[i] | other.data[i]).nonzeroBitCount
    }
    if other.wordcount > self.wordcount {
      for i in mincount..<other.wordcount {
        sum = sum &+ (other.data[i]).nonzeroBitCount
      }
    } else {
      for i in mincount..<self.wordcount {
        sum = sum &+ (data[i]).nonzeroBitCount
      }
    }
    return sum
  }

  // compute the symmetric difference (in place) with another bitset
  public func symmetricDifference(_ other: Bitset) {
    let mincount = Swift.min(self.wordcount, other.wordcount)
    for  i in 0..<mincount {
      data[i] ^= other.data[i]
    }
    if other.wordcount > self.wordcount {
      self.matchWordCapacity(other.wordcount)
      self.wordcount = other.wordcount
      for i in mincount..<other.wordcount {
        data[i] = other.data[i]
      }
    }
  }

  // compute the size union  with another bitset
  public func symmetricDifferenceCount(_ other: Bitset) -> Int {
    let mincount = Swift.min(self.wordcount, other.wordcount)
    var sum = 0
    for  i in 0..<mincount {
      sum = sum &+ (data[i] ^ other.data[i]).nonzeroBitCount
    }
    if other.wordcount > self.wordcount {
      for i in mincount..<other.wordcount {
        sum = sum &+ other.data[i].nonzeroBitCount
      }
    } else {
      for i in mincount..<self.wordcount {
        sum = sum &+ (data[i]).nonzeroBitCount
      }
    }
    return sum
  }

  // compute the difference (in place) with another bitset
  public func difference(_ other: Bitset) {
    let mincount = Swift.min(self.wordcount, other.wordcount)
    for  i in 0..<mincount {
      data[i] &= ~other.data[i]
    }
  }

  // compute the size of the difference with another bitset
  public func differenceCount(_ other: Bitset) -> Int {
    let mincount = Swift.min(self.wordcount, other.wordcount)
    var sum = 0
    for  i in 0..<mincount {
      sum = sum &+ ( data[i] & ~other.data[i]).nonzeroBitCount
    }
    for i in mincount..<self.wordcount {
      sum = sum &+ (data[i]).nonzeroBitCount
    }
    return sum
  }

  // remove a value, must be non-negative
  public func remove(_ value: Int) {
    let index = value >> 6
    if index < self.wordcount {
        data[index] &= ~(1 << UInt64(value & 63))
    }
  }

  // remove a value, if it is present it is removed, otherwise it is added, must be non-negative
  public func flip(_ value: Int) {
    let index = value >> 6
    if index < self.wordcount {
        data[index] ^= 1 << UInt64(value & 63)
    } else {
        increaseWordCount(index + 1)
        data[index] |= 1 << UInt64(value & 63)
    }
  }

  // remove many values, all must be non-negative
  public func removeMany(_ allints: Int...) {
    for i in allints { remove(i) }
  }

  // return the memory usage of the backing array in bytes
  public func memoryUsage() -> Int {
    return self.capacity * 8
  }

  // check whether the value is empty
  public func isEmpty() -> Bool {
    for i in 0..<wordcount {
        let w = data[i]
        if w != 0 { return false; }
    }
    return true
  }

  // remove all elements, optionally keeping the capacity intact
  public func removeAll(keepingCapacity keepCapacity: Bool = false) {
    wordcount = 0
    if !keepCapacity {
      data.deallocate(capacity: self.capacity)
      capacity = 8 // reset to some default
      data = UnsafeMutablePointer<UInt64>.allocate(capacity:capacity)
    }
  }

  private static func nextCapacity(mincap: Int) -> Int {
    return 2 * mincap
  }

   // caller is responsible to ensure that index < wordcount otherwise this function fails!
  func increaseWordCount(_ newWordCount: Int) {
    if(newWordCount <= wordcount) {
     print(newWordCount, wordcount)
    }
    if newWordCount > capacity {
        growWordCapacity(Bitset.nextCapacity(mincap : newWordCount))
    }
    for i in wordcount..<newWordCount {
      data[i] = 0
    }
    wordcount = newWordCount
  }

  func growWordCapacity(_ newcapacity: Int) {
    let newdata = UnsafeMutablePointer<UInt64>.allocate(capacity:newcapacity)
    for i in 0..<self.wordcount {
      newdata[i] = self.data[i]
    }
    data.deallocate(capacity:self.capacity)
    data = newdata
    self.capacity = newcapacity
  }

  func matchWordCapacity(_ newcapacity: Int) {
    if newcapacity > self.capacity {
      growWordCapacity(newcapacity)
    }
  }

  // checks whether the two bitsets have the same content
  public static func == (lhs: Bitset, rhs: Bitset) -> Bool {
    if lhs.wordcount > rhs.wordcount {
          for  i in rhs.wordcount..<lhs.wordcount  where lhs.data[i] != 0 {
            return false
          }
    } else if lhs.wordcount < rhs.wordcount {
          for i in lhs.wordcount..<rhs.wordcount where  rhs.data[i] != 0 {
              return false
            }
    }
    let mincount = Swift.min(rhs.wordcount, lhs.wordcount)
        for  i in 0..<mincount where rhs.data[i] != lhs.data[i] {
            return false
          }
        return true
  }
}
public struct BitsetIterator: IteratorProtocol {
   let bitset: Bitset
   var value: Int = -1

   init(_ bitset: Bitset) {
       self.bitset = bitset
   }

   public mutating func next() -> Int? {
     value = value &+ 1
     var x = value >> 6
     if x >= bitset.wordcount {
       return nil
     }
     var w = bitset.data[x]
     w >>= UInt64(value & 63)
     if w != 0 {
       value = value &+ w.trailingZeroBitCount
       return value
     }
     x = x &+ 1
     while x < bitset.wordcount {
       let w = bitset.data[x]
       if w != 0 {
         value = x &* 64 &+ w.trailingZeroBitCount
         return value
       }
       x = x &+ 1
     }
     return nil
   }
}
