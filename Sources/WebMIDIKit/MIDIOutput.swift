//
//  MIDIOutput.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI

public final class MIDIOutput : MIDIPort {
//  public func send<S: Sequence>(_ data: S, timestamp: Int = 0) where S.Iterator.Element == UInt8 {
//    open()
//    guard var lst = MIDIPacketList(seq: data) else { return }
//    MIDISend(ref, endpoint.ref, &lst)
////    access.send(port: self, data: data, timestamp: timestamp)
//  }

//  public func send(_ packet: MIDIPacket, timestamp: Int = 0) {
//    print(packet)
//    open()
//    var list = MIDIPacketList(packet: packet)
//    for e in list {
//      print("dd", e)
//    }
////    MIDISend(ref, endpoint.ref, &list)
//    MIDIReceived(endpoint.ref, &list)
//  }

  public func send(_ data: [UInt8], timestamp: MIDITimeStamp = 0) {
    open()
//    var midiClient = MIDIClientRef()
//    var result = MIDIClientCreate("Foo Client" as CFString, nil, nil, &midiClient)
//
//
//    var outputPort = MIDIPortRef()
//    result = MIDIOutputPortCreate(midiClient, "Output" as CFString, &outputPort);
//
//    var endPoint = MIDIObjectRef()
//    var foundObj: MIDIObjectType = .other
//    result = MIDIObjectFindByUniqueID(1621423490, &endPoint, &foundObj)

    var pkt = UnsafeMutablePointer<MIDIPacket>.allocate(capacity: 1)
    var pktList = UnsafeMutablePointer<MIDIPacketList>.allocate(capacity: 1)
//    let midiData : [UInt8] = [UInt8(144), UInt8(60), UInt8(5)]
    pkt = MIDIPacketListInit(pktList)
    pkt = MIDIPacketListAdd(pktList, 1024, pkt, 0, 3, data)
    
    MIDISend(ref, endpoint.ref, pktList)

//    MIDIReceived(endpoint.ref, pktList)
  }
  public func clear() {
    endpoint.flush()
  }

  internal convenience init(virtual client: MIDIClient, block: @escaping MIDIReadBlock) {
    self.init(client: client, endpoint: VirtualMIDIDestination(client: client, block: block))
  }
}




