 //
//  MIDIPacketList.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 2/3/17.
//
//

import CoreMIDI
import AXMIDI

//extension MIDIPacketListIterator: IteratorProtocol {
//  public typealias Element = MIDIPacket
//  public typealias Index = Int
//
//  init() {
//    startIndex_ = 0
//    endIndex_ = 0
////    base = nil
//    fatalError()
//  }
//
//  init(lst: UnsafePointer<MIDIPacketList>) {
//    fatalError()
////    self.init(
////    self = 
//  }
//
//  public var startIndex: Index {
//    return Index(startIndex_)
//  }
//
//  public var endIndex: Index {
//    return Index(startIndex_)
//  }
//   public subscript(index: Index) -> Element {
////    return base[index]
//    fatalError()
//  }
//
//  public func index(after i: Index) -> Index {
//    return i + 1
//  }
//
//  public func next() -> MIDIPacket? {
//    return nil
//  }
//}

//protocol Builder: MutableCollection {
//  func append(element: Iterator.Element)
//}
//
//extension Builder where Self: RangeReplaceableCollection {
//  func append(element: Iterator.Element) {
//
//  }
//
//
//}

//struct MIDIChomper: Sequence {
//  typealias Element = ArraySlice<UInt8>
//  let content: [UInt8]
//
//  init(content: [UInt8]) {
//    self.content = content
//  }
//
//  func makeIterator() -> AnyIterator<Element> {
//
//    var start = 0
//    var current = 0
//
//    return AnyIterator {
//      while current < self.content.endIndex {
//        current += 1
//      }
//      defer {
//        start = current
//      }
//      return self.content[start..<current]
//    }
//  }
//}

func dump(_ lst: MIDIPacketList) {
  print("numPackets: \(lst.numPackets) packet: \(lst.packet)")
}

class MIDIPacketListBuilder {
  init(data: [UInt8]) {
    let pkt = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
    head = pkt.withMemoryRebound(to: MIDIPacketList.self, capacity: 1) {
      $0
    }
//    dump(head)
    _currentPacket = MIDIPacketListInit(head)
//    dump(head)
    _first = _currentPacket
//    size = 0
    add(data: data)
//    _first = _currentPacket
//    dump(head)
  }

  func add(data: [UInt8]) {
    _currentPacket = MIDIPacketListAdd(head, 1024, _currentPacket, 0, data.count, data)
    print(_currentPacket.pointee)
//    _currentPacket = MIDIPacketListAdd(&head, size, _currentPacket, 0, data.count, data)
//    size += data.count
  }

//  private var size: Int
  private(set) var head: UnsafeMutablePointer<MIDIPacketList>
  var _first: UnsafeMutablePointer<MIDIPacket>
  private var _currentPacket: UnsafeMutablePointer<MIDIPacket>


  deinit {
//    head.d
  }
  func send(to output: MIDIOutput) {
      
      MIDISend(output.ref, output.endpoint.ref, head)
  }
  typealias Element = MIDIPacket

  public func makeIterator() -> AnyIterator<Element> {

    let s = sequence(first: _first) { MIDIPacketNext($0) }
      .prefix(Int(head.pointee.numPackets)).makeIterator()
    return AnyIterator { s.next()?.pointee }
  }
}

extension Collection where Iterator.Element == UInt8 {
  public func iterateMIDI() -> AnyIterator<MIDIPacket> {
    return AnyIterator {
      todo()
      return nil
    }
  }
}

//extension Sequence where Iterator.Element == MIDIPacket {
//  public func flatten() -> [UInt8] {
//    return flatMap { $0 }
//  }
//}

//public struct MIDIPacketListSlice : Sequence {
//  public typealias Element = MIDIPacket
//  public typealias Base = UnsafePointer<MIDIPacketList>
//  public let base: Base
//
//  private let range: ClosedRange<Element.Timestamp>?
//
//  internal init(base: Base, range: ClosedRange<Element.Timestamp>? = nil) {
//    self.base = base
//    self.range = range
//
//  }
//
//  public func makeIterator() -> AnyIterator<Element> {
//    return AnyIterator { nil }
//  }
//
//
//}

func describe(_ obj: Any) -> String {
  return Mirror(reflecting: obj).children.map { "\($0.label): \($0.value)" }.joined(separator: "\n")
}

///
/// [midipacket] -> [uint8] -> midipacketlist
/// midipacketlist ptr ->
///

class MIDIList: Sequence {
  private(set) var ptr: UnsafeMutablePointer<MIDIPacketList>? = nil
//  private let ownsPtr: Bool

  typealias Index = Int
  typealias Element = UnsafeMutablePointer<MIDIPacket>

  private(set) var first: Element?

  let count: Int

  init?(data: [UInt8], packets: Int, timestamp: MIDITimeStamp = 0) {
//    ownsPtr = true
    self.count = packets
    guard let f = MIDIPacketListCreate(data, UInt32(data.count), UInt32(packets), timestamp, &ptr) else  { return nil }
    first = f
  }

//  init?(data: [UInt8]) {
//    while true {
//      MIDIPacket(data: data)
//    }
//  }

  init(ptr: UnsafeMutablePointer<MIDIPacketList>) {
//    ownsPtr = true
    self.ptr = ptr
    self.count = Int(ptr.pointee.numPackets)
  }

  deinit {
//    if ownsPtr {
      MIDIPacketListFree(&ptr!)
//    }
  }


  func makeIterator() -> AnyIterator<Element> {
    var cur = first
    var current = 0

    return AnyIterator {
      guard current < self.count else { return nil }
      defer {
        cur = MIDIPacketNext(cur!)
        current += 1
      }
      return cur
    }
  }
}

extension MIDIList : Equatable, Comparable, Hashable, CustomStringConvertible {
//  public typealias Element = MIDIPacket
  public typealias Timestamp = MIDITimeStamp

  public static func ==(lhs: MIDIList, rhs: MIDIList) -> Bool {
    return lhs.count == rhs.count && lhs.elementsEqual(rhs)
  }

  public static func <(lhs: MIDIList, rhs: MIDIList) -> Bool {
    return lhs.timestamp < rhs.timestamp
  }

  public var hashValue: Int {
    return count.hashValue ^ (first?.hashValue ?? 0)
  }

  public var timestamp: Timestamp {
    fatalError()
    return 0
  }

//  //
//  //
//  //
//  public init?<S : Sequence>(seq: S) where S.Iterator.Element == UInt8 {
//    let data = Array(seq)
//
//    fatalError()
//    var packet = MIDIPacketList()
//    MIDIPacketListInit(&packet)
//
//    self = packet
//  }

//  mutating
//  func add(_ packet: MIDIPacket, timestamp: MIDITimeStamp? = nil) -> MIDIPacket {
//    var p = packet
//    return MIDIPacketListAdd(&self, MemoryLayout<MIDIPacketList>.size, &p, timestamp ?? 0, packet.count, Array(packet)).pointee
//  }

//  init(data: [UInt8], timestamp: MIDITimeStamp = 0) {
//    var pkt = UnsafeMutablePointer<MIDIPacket>.allocate(capacity: 1)
//    let pktList = UnsafeMutablePointer<MIDIPacketList>.allocate(capacity: 1)
//    pkt = MIDIPacketListInit(pktList)
//    pkt = MIDIPacketListAdd(pktList, 1024, pkt, timestamp, data.count, data)
//    self = pktList.pointee
//  }

  public var description: String {
    return "MIDIPacketList: count: \(count)" + Array(self).description
  }

//  public init(arrayLiteral literal: Element...) {
//    self.init()
    //validator
    //    self = MIDIPacketListInit
    //    MIDIPacketListInit(&self)
    //    literal.forEach {
    //      var p = $0
    //      MIDIPacketListAdd(&self, 0, &p, 0, 0, )
    //    }

    //    literal.forEach {
    //      MIDIPacketListAdd(<#T##pktlist: UnsafeMutablePointer<MIDIPacketList>##UnsafeMutablePointer<MIDIPacketList>#>, <#T##listSize: Int##Int#>, <#T##curPacket: UnsafeMutablePointer<MIDIPacket>##UnsafeMutablePointer<MIDIPacket>#>, <#T##time: MIDITimeStamp##MIDITimeStamp#>, <#T##nData: Int##Int#>, <#T##data: UnsafePointer<UInt8>##UnsafePointer<UInt8>#>)
    //    }

    //    assert(literal.count == 1, "implement with pointers")

    //    self.init(numPackets: UInt32(literal.count), packet: literal[0])
    //    self.init(numPackets: 1, packet: literal[0])

//    todo("initialization")
//  }
}


