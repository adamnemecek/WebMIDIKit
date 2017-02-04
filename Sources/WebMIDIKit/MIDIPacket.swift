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
    return 3
  }

  public subscript(index: Index) -> Element {
    get {
      let r = MIDIPacketGetValue(self, Int32(index))
      print("index \(index), value: \(r), length: \(count)")
      return r
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

  public init(arrayLiteral literal: Element...) {
    self = MIDIPacketCreate(0, literal, Int32(literal.count))
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
    assert(type == 8 || type == 9)
    return "Note: timestamp: \(timestamp), data: \(Array(self))"
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

//protocol Parser: Collection {
//  associatedtype Raw
//  init?<S: Sequence>(seq: S) where S.Iterator.Element == Raw
//}

//extension MIDIPacket : RangeReplaceableCollection {
//  mutating
//  public func replaceSubrange<C : Collection>(_ subrange: Range<Index>, with newElements: C) where C.Iterator.Element == Element {
////    let diff = Int(numericCast(newElements.count)) - Int(numericCast(count))
//
//    fatalError()
//  }
//}
