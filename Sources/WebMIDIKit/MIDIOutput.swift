//
//  MIDIOutput.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI

public final class MIDIOutput : MIDIPort {
  public func send<S: Sequence>(_ data: S, timestamp: Int = 0) where S.Iterator.Element == UInt8 {
    open()
    guard var lst = MIDIPacketList(seq: data) else { return }
    MIDISend(ref, endpoint.ref, &lst)
//    access.send(port: self, data: data, timestamp: timestamp)
  }

  public func send(_ packet: MIDIPacket, timestamp: Int = 0) {
    print(packet)
  }


  public func clear() {

  }
}
