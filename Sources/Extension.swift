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


