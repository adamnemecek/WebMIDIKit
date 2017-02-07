 //
//  MIDIPacketList.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 2/3/17.
//
//

import AVFoundation
import AXMIDI

internal final class MIDIList {
  init<S: Sequence>(data: S) where S.Iterator.Element == UInt8 {
    let pkt = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
    head = pkt.withMemoryRebound(to: MIDIPacketList.self, capacity: 1) {
      $0
    }
    _currentPacket = MIDIPacketListInit(head)
    _first = _currentPacket
    add(data: Array(data))
  }


  func add(data: [UInt8]) {
    _currentPacket = MIDIPacketListAdd(head, 1024, _currentPacket, 0, data.count, data)
    print(_currentPacket.pointee)
  }

  private(set) var head: UnsafeMutablePointer<MIDIPacketList>
  private var _first: UnsafeMutablePointer<MIDIPacket>
  private var _currentPacket: UnsafeMutablePointer<MIDIPacket>

  func send(to output: MIDIOutput, offset: Double? = nil) {
    _ = offset.map {
      let current = AudioGetCurrentHostTime()
      let _offset = AudioConvertNanosToHostTime(UInt64($0 * 1000000))

      let ts = current + _offset
      print(current, ts, _offset)
      _first.pointee.timeStamp = ts

      assert(head.pointee.packet.timeStamp == ts)
    }

    MIDISend(output.ref, output.endpoint.ref, head)
    /// this let's us propagate the events to everyone subscribed to this
    /// endpoint not just this port, i'm not sure if we actually want this
    /// but for now, it let's us create multiple ports from different MIDIAccess
    /// objects and have them all receive the same messages
    MIDIReceived(output.endpoint.ref, head)
  }

  deinit {
    head.deallocate(capacity: 1)
  }

  typealias Element = MIDIPacket

  public func makeIterator() -> AnyIterator<Element> {
    let s = sequence(first: _first) { MIDIPacketNext($0) }
      .prefix(Int(head.pointee.numPackets)).makeIterator()
    return AnyIterator { s.next()?.pointee }
  }
}


//class MIDIList: Sequence {
//  private(set) var ptr: UnsafeMutablePointer<MIDIPacketList>? = nil
//
//  typealias Index = Int
//  typealias Element = UnsafeMutablePointer<MIDIPacket>
//
//  private(set) var first: Element?
//
//  let count: Int
//
//  init?(data: [UInt8], packets: Int, timestamp: MIDITimeStamp = 0) {
////    ownsPtr = true
//    self.count = packets
//    guard let f = MIDIPacketListCreate(data, UInt32(data.count), UInt32(packets), timestamp, &ptr) else  { return nil }
//    first = f
//  }
//
////  init?(data: [UInt8]) {
////    while true {
////      MIDIPacket(data: data)
////    }
////  }
//
//  init(ptr: UnsafeMutablePointer<MIDIPacketList>) {
////    ownsPtr = true
//    self.ptr = ptr
//    self.count = Int(ptr.pointee.numPackets)
//  }
//
//  deinit {
////    if ownsPtr {
//      MIDIPacketListFree(&ptr!)
////    }
//  }
//
//
//  func makeIterator() -> AnyIterator<Element> {
//    var cur = first
//    var current = 0
//
//    return AnyIterator {
//      guard current < self.count else { return nil }
//      defer {
//        cur = MIDIPacketNext(cur!)
//        current += 1
//      }
//      return cur
//    }
//  }
//}
//
//extension MIDIList : Equatable, Comparable, Hashable, CustomStringConvertible {
////  public typealias Element = MIDIPacket
//  public typealias Timestamp = MIDITimeStamp
//
//  public static func ==(lhs: MIDIList, rhs: MIDIList) -> Bool {
//    return lhs.count == rhs.count && lhs.elementsEqual(rhs)
//  }
//
//  public static func <(lhs: MIDIList, rhs: MIDIList) -> Bool {
//    return lhs.timestamp < rhs.timestamp
//  }
//
//  public var hashValue: Int {
//    return count.hashValue ^ (first?.hashValue ?? 0)
//  }
//
//  public var timestamp: Timestamp {
//    fatalError()
//    return 0
//  }
//
////  //
////  //
////  //
////  public init?<S : Sequence>(seq: S) where S.Iterator.Element == UInt8 {
////    let data = Array(seq)
////
////    fatalError()
////    var packet = MIDIPacketList()
////    MIDIPacketListInit(&packet)
////
////    self = packet
////  }
//
////  mutating
////  func add(_ packet: MIDIPacket, timestamp: MIDITimeStamp? = nil) -> MIDIPacket {
////    var p = packet
////    return MIDIPacketListAdd(&self, MemoryLayout<MIDIPacketList>.size, &p, timestamp ?? 0, packet.count, Array(packet)).pointee
////  }
//
////  init(data: [UInt8], timestamp: MIDITimeStamp = 0) {
////    var pkt = UnsafeMutablePointer<MIDIPacket>.allocate(capacity: 1)
////    let pktList = UnsafeMutablePointer<MIDIPacketList>.allocate(capacity: 1)
////    pkt = MIDIPacketListInit(pktList)
////    pkt = MIDIPacketListAdd(pktList, 1024, pkt, timestamp, data.count, data)
////    self = pktList.pointee
////  }
//
//  public var description: String {
//    return "MIDIPacketList: count: \(count)" + Array(self).description
//  }
//
////  public init(arrayLiteral literal: Element...) {
////    self.init()
//    //validator
//    //    self = MIDIPacketListInit
//    //    MIDIPacketListInit(&self)
//    //    literal.forEach {
//    //      var p = $0
//    //      MIDIPacketListAdd(&self, 0, &p, 0, 0, )
//    //    }
//
//    //    literal.forEach {
//    //      MIDIPacketListAdd(<#T##pktlist: UnsafeMutablePointer<MIDIPacketList>##UnsafeMutablePointer<MIDIPacketList>#>, <#T##listSize: Int##Int#>, <#T##curPacket: UnsafeMutablePointer<MIDIPacket>##UnsafeMutablePointer<MIDIPacket>#>, <#T##time: MIDITimeStamp##MIDITimeStamp#>, <#T##nData: Int##Int#>, <#T##data: UnsafePointer<UInt8>##UnsafePointer<UInt8>#>)
//    //    }
//
//    //    assert(literal.count == 1, "implement with pointers")
//
//    //    self.init(numPackets: UInt32(literal.count), packet: literal[0])
//    //    self.init(numPackets: 1, packet: literal[0])
//
////    todo("initialization")
////  }
//}


