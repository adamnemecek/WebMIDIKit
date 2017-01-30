//
//  Extension.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//


import AVFoundation

extension MIDIPacketList: Sequence {
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
}

extension MIDIObjectAddRemoveNotification {
  init?(ptr: UnsafePointer<MIDINotification>) {
    switch ptr.pointee.messageID {
    case .msgObjectAdded, .msgObjectRemoved:
      self = ptr.withMemoryRebound(to: MIDIObjectAddRemoveNotification.self, capacity: 1) {
        $0.pointee
      }
    default: return nil
    }
  }
}
