//
//  MIDIPacket.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 2/3/17.
//
//

import CoreMIDI
import AXMIDI

@_exported import struct CoreMIDI.MIDIPacket

//enum MIDIMessageType: UInt8 {
//
//}



extension MIDIPacket : MutableCollection, Equatable, Comparable, Hashable, ExpressibleByArrayLiteral, CustomStringConvertible, MutableEventType {
  public typealias Element = UInt8
  public typealias Index = Int

  public var startIndex: Index {
    return 0
  }

  public var endIndex: Index {
    //todo this needs to be fixed and like do the right
    assert(length <= 256)
    return Int(length)
  }


  public subscript(index: Index) -> Element {
    get {
      print("index \(index), value: \(MIDIPacketGetValue(self, Int32(index))), length: \(count)")
      return MIDIPacketGetValue(self, Int32(index))
    }
    set {
      MIDIPacketSetValue(&self, Int32(index), newValue)
    }
  }

  public static func ==(lhs: MIDIPacket, rhs: MIDIPacket) -> Bool {
    return
      (lhs.timestamp, lhs.count) == (rhs.timestamp, rhs.count) &&
      lhs.elementsEqual(rhs)
  }

  public static func <(lhs: MIDIPacket, rhs: MIDIPacket) -> Bool {
    return lhs.timestamp < rhs.timestamp
  }

  public var hashValue: Int {
    return Int(timeStamp) ^ count
  }

  init(data: [Element]) {
    self = MIDIPacketCreate(data, Int32(data.count), 0)
  }

  public init(arrayLiteral literal: Element...) {
    self = MIDIPacketCreate(literal, Int32(literal.count), 0)
    assert(count == literal.count && elementsEqual(literal))
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

  public var description: String {
    return ""
  }

  public init?<S: Sequence>(seq: S) where S.Iterator.Element == Element {
    fatalError()
  }

  var type: UInt8 {
    return UInt8(data.0 >> 4)
  }

  public var byte: UInt8 {
    return data.1
  }
}
