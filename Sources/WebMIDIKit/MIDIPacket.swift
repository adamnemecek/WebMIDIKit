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

extension MIDIPacket : MutableCollection, Equatable, Comparable, Hashable, ExpressibleByArrayLiteral, CustomStringConvertible, CustomDebugStringConvertible, MutableEventType {
  public typealias Element = UInt8
  public typealias Index = Int

  public var startIndex: Index {
    return 0
  }

  public var endIndex: Index {
    //todo this needs to be fixed and like do the right
    // note that I think that technically
    assert(length <= 256)
    return Int(length)
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

  init(data: [Element], timestamp: Double = 0) {
    self = MIDIPacketCreate(data, Int32(data.count), MIDITimeStamp(timestamp))
    assert(count == data.count && elementsEqual(data))
  }

  public init(arrayLiteral literal: Element...) {
    self.init(data: Array(literal))
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

  var isSysEx: Bool {
     return data.0 >= 240
  }

  public var description: String {
    return "\(Array(self))"
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
