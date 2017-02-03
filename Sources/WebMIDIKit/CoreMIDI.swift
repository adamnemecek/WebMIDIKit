//
//  Utils.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/30/17.
//
//


import CoreMIDI
import AXMIDI

internal func MIDIObjectGetStringProperty(ref: MIDIObjectRef, property: CFString) -> String {
  var string: Unmanaged<CFString>? = nil
  MIDIObjectGetStringProperty(ref, property, &string)
  return (string?.takeRetainedValue())! as String
}

internal func MIDIObjectGetIntProperty(ref: MIDIObjectRef, property: CFString) -> Int {
  var val: Int32 = 0
  MIDIObjectGetIntegerProperty(ref, property, &val)
  return Int(val)
}

internal func MIDIObjectGetType(id: Int) -> MIDIObjectType {
  var ref: MIDIObjectRef = 0
  var type: MIDIObjectType = .other
  MIDIObjectFindByUniqueID(MIDIUniqueID(id), &ref, &type)
  return type
}

internal func MIDISources() -> [MIDIEndpoint] {
  return (0..<MIDIGetNumberOfSources()).map {
    MIDIEndpoint(ref: MIDIGetSource($0))
  }
}

internal func MIDIDestinations() -> [MIDIEndpoint] {
  return (0..<MIDIGetNumberOfDestinations()).map{
    MIDIEndpoint(ref: MIDIGetDestination($0))
  }
}

internal func MIDIInputPortCreate(ref: MIDIClientRef, readmidi: @escaping (UnsafePointer<MIDIPacketList>) -> ()) -> MIDIPortRef {
  var port = MIDIPortRef()
  MIDIInputPortCreateWithBlock(ref, "MIDI input" as CFString, &port) {
    packetlist, srcconref in
    readmidi(packetlist)
  }
  return port
}

internal func MIDIOutputPortRefCreate(ref: MIDIClientRef) -> MIDIPortRef {
  var port = MIDIPortRef()
  MIDIOutputPortCreate(ref, "MIDI output" as CFString, &port)
  return port
}

internal func MIDIClientCreate(name: String, callback: @escaping (UnsafePointer<MIDINotification>) -> ()) -> MIDIClientRef {
  var ref = MIDIClientRef()
  MIDIClientCreateWithBlock(name as CFString, &ref, callback)
  return ref
}

extension MIDIPacket : MutableCollection, Equatable, Comparable, Hashable, ExpressibleByArrayLiteral, MutableEventType {
  public typealias Element = UInt8
  public typealias Index = Int

  public var startIndex: Index {
    return 0
  }

  public var endIndex: Index {
    return Index(length)
  }

  public subscript(index: Index) -> Element {
    get {
      return MIDIPacketGetValue(self, Int32(index))
    }
    set {
      MIDIPacketSetValue(&self, Int32(index), newValue)
    }
  }

  public static func ==(lhs: MIDIPacket, rhs: MIDIPacket) -> Bool {
    return (lhs.timeStamp, lhs.count) == (rhs.timeStamp, rhs.count) &&
      lhs.elementsEqual(rhs)
  }

  public static func <(lhs: MIDIPacket, rhs: MIDIPacket) -> Bool {
    return lhs.timeStamp < rhs.timeStamp
  }

  public var hashValue: Int {
    return Int(timeStamp) ^ count
  }

  public init(arrayLiteral literal: Element...) {
    self = MIDIPacketCreate(0, literal, Int32(literal.count))
    assert(elementsEqual(literal))
  }

  public typealias Timestamp = MIDITimeStamp

  public var timestamp: Timestamp {
    get {
      return timeStamp
    }
    set {
      timeStamp = newValue
    }
  }
}

//extension MIDIPacket : RangeReplaceableCollection {
//  mutating
//  public func replaceSubrange<C : Collection>(_ subrange: Range<Index>, with newElements: C) where C.Iterator.Element == Element {
////    let diff = Int(numericCast(newElements.count)) - Int(numericCast(count))
//
//    fatalError()
//  }
//}

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
  public init?<S: Sequence>(seq: S) where S.Iterator.Element == UInt8 {
    fatalError()
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

extension MIDIObjectAddRemoveNotification: CustomStringConvertible {
  internal init?(ptr: UnsafePointer<MIDINotification>) {
    switch ptr.pointee.messageID {
    case .msgObjectAdded, .msgObjectRemoved:
      self = ptr.withMemoryRebound(to: MIDIObjectAddRemoveNotification.self, capacity: 1) {
        $0.pointee
      }
    default: return nil
    }
  }

  public var description: String {
    return Mirror(reflecting: self).children.map { "\($0.label): \($0.value)" }.joined(separator: "\n")
  }

  internal var endpoint: MIDIEndpoint {
    return MIDIEndpoint(ref: child)
  }

//  var type: M
}




