//
//  Extension.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import AVFoundation

fileprivate func generatorForTuple(_ tuple: Any) -> AnyIterator<Any> {
  let children = Mirror(reflecting: tuple).children
  return AnyIterator(children.makeIterator().lazy.map { $0.value }.makeIterator())
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

    switch index {
      case 0: return data.0
      case 1: return data.1
      case 2: return data.2
      case 3: return data.3
      case 4: return data.4
      case 5: return data.5
      default:
        fatalError("todo: implement generator")
    }
  }
}
extension MIDIPacket: Hashable {
  public var hashValue: Int {
    return Int(timeStamp) ^ count
  }

  public static func ==(lhs: MIDIPacket, rhs: MIDIPacket) -> Bool {
    return lhs.timeStamp == rhs.timeStamp &&
           lhs.count == rhs.count &&
           lhs.elementsEqual(rhs)
  }
}

extension MIDIPacketList: Sequence, Hashable {
  public typealias Element = MIDIPacket

  public func makeIterator() -> AnyIterator<Element> {
    var current = packet
    var idx: UInt32 = 0

    return AnyIterator {
      guard idx < self.numPackets else { return nil }
      defer {
        current = MIDIPacketNext(&current).pointee
        idx += 1
      }
      return current
    }
  }

  public var hashValue: Int {
    return numPackets.hashValue ^ packet.hashValue
  }

  public static func ==(lhs: MIDIPacketList, rhs: MIDIPacketList) -> Bool {
    fatalError()
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

extension MIDIPacket {
  var seconds: Double {
    let ns = Double(AudioConvertHostTimeToNanos(timeStamp))
    return ns / 1_000_000_000
  }
}
