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
    open()
    var list = MIDIPacketList(packet: packet)
    for e in list {
      print("dd", e)
    }
//    MIDISend(ref, endpoint.ref, &list)
    MIDIReceived(endpoint.ref, &list)
  }


  public func clear() {
    endpoint.flush()
  }

  internal convenience init(virtual client: MIDIClient, block: @escaping MIDIReadBlock) {
    self.init(client: client, endpoint: VirtualMIDIDestination(client: client, block: block))
  }
}




