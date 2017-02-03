
//  MIDIPacketList.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 2/3/17.
//
//

import CoreMIDI

@_exported import struct CoreMIDI.MIDIPacketList

extension MIDIPacketList : Sequence, Equatable, Comparable, Hashable, ExpressibleByArrayLiteral {
  public typealias Element = MIDIPacket
  public typealias Timestamp = Element.Timestamp

  public func makeIterator() -> AnyIterator<Element> {
    var first = packet
    let s = sequence(first: &first) { MIDIPacketNext($0) }
      .prefix(Int(numPackets)).makeIterator()
    return AnyIterator { s.next()?.pointee }
  }

  public static func ==(lhs: MIDIPacketList, rhs: MIDIPacketList) -> Bool {
    return lhs.numPackets == rhs.numPackets && lhs.elementsEqual(rhs)
  }

  public static func <(lhs: MIDIPacketList, rhs: MIDIPacketList) -> Bool {
    return lhs.timestamp < rhs.timestamp
  }

  public var hashValue: Int {
    return numPackets.hashValue ^ packet.hashValue
  }

  public var timestamp: Timestamp {
    return packet.timestamp
  }

  //
  //
  //
  public init?<S : Sequence>(seq: S) where S.Iterator.Element == UInt8 {
    let data = Array(seq)

    fatalError()
    var packet = MIDIPacketList()
    MIDIPacketListInit(&packet)

    self = packet
  }

  mutating
  func add(_ packet: MIDIPacket, timestamp: MIDITimeStamp? = nil) -> MIDIPacket {
    var p = packet
    return MIDIPacketListAdd(&self, MemoryLayout<MIDIPacketList>.size, &p, timestamp ?? 0, packet.count, Array(packet)).pointee
  }

  init(packet: MIDIPacket) {
    fatalError()
//    var lst = MIDIPacketList()
//    MIDIPacketListInit(&lst)
//    lst.packet = packet
//    lst.numPackets = 1
//    self = lst

  }

  public init(arrayLiteral literal: Element...) {
    self.init()
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

    todo("initialization")
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

