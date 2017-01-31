//
//  Utils.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/30/17.
//
//

import CoreMIDI

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

internal func MIDISources() -> [MIDIEndpointRef] {
  return (0..<MIDIGetNumberOfSources()).map(MIDIGetSource)
}

internal func MIDIDestinations() -> [MIDIEndpointRef] {
  return (0..<MIDIGetNumberOfDestinations()).map(MIDIGetDestination)
}

internal func MIDIInputPortCreate(ref: MIDIClientRef, readmidi: @escaping (UnsafePointer<MIDIPacketList>) -> ()) -> MIDIPortRef {
  var ref = MIDIPortRef()
  MIDIInputPortCreateWithBlock(ref, "MIDI input" as CFString, &ref) {
    packetlist, srcconref in
    readmidi(packetlist)
  }
  return ref
}

internal func MIDIOutputPortRefCreate(ref: MIDIClientRef) -> MIDIPortRef {
  var ref = MIDIPortRef()
  MIDIOutputPortCreate(ref, "MIDI output" as CFString, &ref)
  return ref
}

internal func MIDIClientCreate(name: String, callback: @escaping (UnsafePointer<MIDINotification>) -> ()) -> MIDIClientRef {
  var ref =  MIDIClientRef()
  MIDIClientCreateWithBlock(name as CFString, &ref, callback)
  return ref
}

extension MIDIPacket: Collection {
  public typealias Element = UInt8
  public typealias Index = Int

  public var startIndex: Index {
    return 0
  }

  public var endIndex: Index {
    return Index(length)
  }

  public subscript(index: Index) -> Element {
    assert(index < count)

//    return withUnsafeBytes(of: &data) {
//
//    }

    //
    // most midi messages are <3 bytes so this is A-OK for now
    //

    switch index {
      case 0: return data.0
      case 1: return data.1
      case 2: return data.2
      case 3: return data.3
      case 4: return data.4
      case 5: return data.5
      case 6: return data.6
      case 7: return data.7
      case 8: return data.8
      default:
        fatalError("todo: implement with generatorForTuple in \(#file)")
    }
  }

  public func makeIterator() -> AnyIterator<Element> {
    let i = Mirror(reflecting: data).children.makeIterator()
    return AnyIterator {
      i.next().map { $0.value as! Element }
    }
  }
}

extension MIDIPacket: Equatable {
  public static func ==(lhs: MIDIPacket, rhs: MIDIPacket) -> Bool {
    return (lhs.timeStamp, lhs.count) == (rhs.timeStamp, rhs.count) &&
           lhs.elementsEqual(rhs)
  }
}

extension MIDIPacket: Comparable {
  public static func <(lhs: MIDIPacket, rhs: MIDIPacket) -> Bool {
    return lhs.timeStamp < rhs.timeStamp
  }
}

extension MIDIPacket: Hashable {
  public var hashValue: Int {
    return Int(timeStamp) ^ count
  }
}
//
//extension MIDIPacket {
//  var seconds: Double {
//    let ns = Double(AudioConvertHostTimeToNanos(timeStamp))
//    return ns / 1_000_000_000
//  }
//}

extension MIDIPacketList: Sequence {
  public typealias Element = MIDIPacket

  public var count: Int {
    @inline(__always)
    get {
      return Int(numPackets)
    }
  }

  public func makeIterator() -> AnyIterator<Element> {
    var current = packet
    var idx = 0

    return AnyIterator {
      guard idx < self.count else { return nil }
      defer {
        current = MIDIPacketNext(&current).pointee
        idx += 1
      }
      return current
    }
  }
}

extension MIDIPacketList: Equatable {
  public static func ==(lhs: MIDIPacketList, rhs: MIDIPacketList) -> Bool {
    return lhs.count == rhs.count && lhs.elementsEqual(rhs)
  }
}

extension MIDIPacketList: Hashable {
  public var hashValue: Int {
    return count.hashValue ^ packet.hashValue
  }
}

extension MIDIObjectAddRemoveNotification {
  internal init?(ptr: UnsafePointer<MIDINotification>) {
    switch ptr.pointee.messageID {
    case .msgObjectAdded, .msgObjectRemoved:
      self = ptr.withMemoryRebound(to: MIDIObjectAddRemoveNotification.self, capacity: 1) {
        $0.pointee
      }
    default: return nil
    }
  }
}
