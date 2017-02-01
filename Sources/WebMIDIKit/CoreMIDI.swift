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
  var ref = MIDIClientRef()
  MIDIClientCreateWithBlock(name as CFString, &ref, callback)
  return ref
}

extension MIDIPacket: MutableCollection {
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

extension MIDIPacket: ExpressibleByArrayLiteral {
  public init(arrayLiteral literal: Element...) {
//      self.init()
//      todo does this work?
//      memcmp(&data, literal, literal.count/4)
      self = MIDIPacketCreate(0, literal, Int32(literal.count))
      assert(elementsEqual(literal))
  }
}

// todo: chrome has this
//extension MIDIPacket {
//  var seconds: Double {
//    let ns = Double(AudioConvertHostTimeToNanos(timeStamp))
//    return ns / 1_000_000_000
//  }
//}

extension MIDIPacketList: Sequence {
	public typealias Element = MIDIPacket

	//
	// Note that, despite the fact that MIDIPacketList has a count property
	// you cannot make it a Collection because the single packets are variable
	// length
	//
	public var count: Int {
		@inline(__always)
		get {
			return Int(numPackets)
		}
	}

	public func makeIterator() -> AnyIterator<Element> {
		var first = packet
		let s = sequence(first: &first) { MIDIPacketNext($0) }
           .prefix(count).makeIterator()
		return AnyIterator { s.next()?.pointee }
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

extension MIDIPacketList: ExpressibleByArrayLiteral {
  //  public init<S: Sequence>(seq: S) where S.Iterator.Element == Element {
  //
  //  }

  public init(arrayLiteral literal: Element...) {
    self.init()
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




