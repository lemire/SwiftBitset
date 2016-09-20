
// a class that can be used as an efficient set container for non-negative integers
public class Bitset : Sequence, Equatable {
  var data = [UInt64]()

  // copy construction
  public init(_ other : Bitset) { data = other.data }

  // make a bitset containing the list of integers, all values must be non-negative
  // adding the value i to the bitset will cause the use of least (i+8)/8 bytes
  public init(_ allints : Int...) {
      for i in allints { add(i) }
  }


  // create an iterator over the values contained in the bitset
  public func makeIterator()->AnyIterator<Int> {
    var i : Int = -1;
    return AnyIterator {
      i += 1;
      var x = Bitset.logicalrightshift(x : i, s : 6);
      if x >= self.data.count {
        return nil
      }
      var w = self.data[x];
      w >>= UInt64(i & 63);
      if w != 0 {
        i += Bitset.trailingZeroes(w);
        return i
      }
      x += 1;
      while x < self.data.count {
        let w = self.data[x];
        if w != 0 {
          i = x * 64 + Bitset.trailingZeroes(w);
          return i
        }
        x += 1
      }
      return nil
    }
  }

  // count how many values have been stored in the bitset (this function is not free of computation)
  public func count()->Int {
    var sum : Int = 0
    for w in data {
      sum += Bitset.popcount(w)
    }
    return sum
  }

  // proxy for "count"
  public func cardinality()->Int { return count() }


  // add a value to the bitset, all values must be non-negative
  // adding the value i to the bitset will cause the use of least (i+8)/8 bytes
  public func add(_ i : Int) {
    let index = Bitset.logicalrightshift(x : i, s : 6);
    if index >= data.count { ensureCapacity(i) }
    let one : UInt64 = 1;
    let shiftamount : UInt64 = UInt64(i & 63);
    data[index] |= one << shiftamount
  }

  // add all the values  to the bitset
  // adding the value i to the bitset will cause the use of least (i+8)/8 bytes
  public func addMany(_ allints : Int...) {
    var mymax = 0;
    for i in allints { mymax = mymax < i ? i : mymax }
    ensureCapacity(mymax);
    for i in allints { add(i) }
  }

  // check that a value is in the bitset, all values must be non-negative
  public func contains(_ i : Int)->Bool {
    let index = Bitset.logicalrightshift(x : i, s : 6);
    if index >= data.count { return false }
    let one : UInt64 = 1;
    let shiftamount  = UInt64(i & 63);
    let shiftedbit = one << shiftamount;
    return data[index] & shiftedbit != 0
  }

  // compute the intersection (in place) with another bitset
  public func intersection(_ other : Bitset) {
    let mincount = other.data.count < data.count ? other.data.count : data.count;
    for i in 0..<mincount { data[i] &= other.data[i] }
    for i in mincount..<data.count { data[i] = 0 }
  }

  // compute the union (in place) with another bitset
  public func union(_ other : Bitset) {
    let mincount = other.data.count < data.count ? other.data.count : data.count;
    for  i in 0..<mincount {
      data[i] |= other.data[i]
    }
    if other.data.count > data.count {
      data.reserveCapacity(other.data.count)
      for i in mincount..<other.data.count {
        data.append(other.data[i])
      }
    }
  }

  // remove a value, must be non-negative
  public func remove(_ i : Int) {
    let index = Bitset.logicalrightshift(x : i, s : 6);
    if index < data.count {
        let one : UInt64 = 1;
        let shiftamount = UInt64(i & 63);
        let shiftedbit = one << shiftamount;
        let negshiftedbit = ~shiftedbit;
        data[index] &= negshiftedbit
      }
  }

  // remove many values, all must be non-negative
  public func removeMany(_ allints : Int...) {
    for i in allints { remove(i) }
  }

  // return the memory usage of the backing array in bytes
  public func memoryUsage() -> Int {
    return data.count * 8
  }

  // check whether the value is empty
  public func isEmpty()->Bool {
    for w in data {
        if w != 0 { return false; }
    }
    return true
  }

  // remove all elements, optionally keeping the capacity intact
  public func removeAll(keepingCapacity keepCapacity: Bool = false) {
    data.removeAll(keepingCapacity : keepCapacity)
  }

  func ensureCapacity(_ index : Int) {
    let newcount = Bitset.logicalrightshift(x : index, s : 6) + 1;
    data.reserveCapacity(newcount);
    while data.count < newcount {
      data.append(0)
    }
  }

  static func logicalrightshift(x : Int, s : Int)->Int {
    return Int(UInt(x) >> UInt(s))
  }

  static let deBruijn = [ 0, 1, 56, 2, 57, 49, 28, 3, 61, 58, 42, 50, 38, 29, 17, 4, 62, 47, 59, 36, 45, 43, 51, 22, 53, 39, 33, 30, 24, 18, 12, 5, 63, 55, 48, 27, 60, 41, 37, 16, 46, 35, 44, 21, 52, 32, 23, 11, 54, 26, 40, 15, 34, 20, 31, 10, 25, 14, 19, 9, 13, 8, 7, 6, ]

  static func trailingZeroes(_ v : UInt64)->Int {
    let lowbit = Int64(v) & (-Int64(v));
    let lowbitmulti = UInt64(lowbit) &* 0x03f79d71b4ca8b09;
    return deBruijn[Int(lowbitmulti >> 58)]
  }

  static func popcount(_ i : UInt64)->Int {
    var x = i;
    x -= (x >> 1) & 0x5555555555555555;
    x = (x >> 2) & 0x3333333333333333 + x & 0x3333333333333333;
    x += x >> 4;
    x &= 0x0f0f0f0f0f0f0f0f;
    x = x &* 0x0101010101010101;
    return Int(x >> 56)
  }

}

public func == (lhs : Bitset, rhs : Bitset) ->Bool {
  if (lhs.data.count > rhs.data.count) {
        for  i in rhs.data.count..<lhs.data.count {
            if lhs.data[i] != 0 { return false; }
        }
  } else if (lhs.data.count < rhs.data.count) {
        for i in lhs.data.count..<rhs.data.count {
            if rhs.data[i] != 0 { return false; }
          }
  }
  let mincount =
      lhs.data.count < rhs.data.count ? lhs.data.count : rhs.data.count;
      for  i in 0..<mincount {
          if  rhs.data[i] != lhs.data[i] { return false }
        }
      return true
}
