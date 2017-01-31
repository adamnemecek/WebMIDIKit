//
//  MIDIOutput.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI

public final class MIDIOutput: MIDIPort {
  internal init(client: MIDIClient) {
    super.init(ref: MIDIOutputPortRefCreate(ref: client.ref))
  }

  public func send<S: Sequence>(data: S, timestamp: Int = 0) where S.Iterator.Element == UInt8 {
    /*
     _ = client.map {
     let list = MIDIPacketList(numPackets: <#T##UInt32#>, packet: <#T##(MIDIPacket)#>)
     for e in data {
     MIDISend(ref, , <#T##pktlist: UnsafePointer<MIDIPacketList>##UnsafePointer<MIDIPacketList>#>)
     }
     }*/
  }

  public func clear() {
    
  }
  
}
