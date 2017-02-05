//
//  MIDIOutput.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI

public final class MIDIOutput : MIDIPort {
  public typealias Timestamp = MIDITimeStamp
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

//  public func send(_ data: [UInt8], timestamp: MIDITimeStamp = 0) {
//    open()
//
//    var pkt = UnsafeMutablePointer<MIDIPacket>.allocate(capacity: 1)
//    let pktList = UnsafeMutablePointer<MIDIPacketList>.allocate(capacity: 1)
//    pkt = MIDIPacketListInit(pktList)
//    pkt = MIDIPacketListAdd(pktList, 1024, pkt, 0, data.count, data)
//    it's
//    MIDISend(ref, endpoint.ref, pktList)
//
////    MIDIReceived(endpoint.ref, pktList)
//  }

  public func send(_ data: [UInt8], timestamp: Timestamp = 0) {
    open()
    let p = MIDIList(data: data)
    print(p.head)
    p.send(to: self)
  }

  public func clear() {
    endpoint.flush()
  }

  internal convenience init(virtual client: MIDIClient, block: @escaping MIDIReadBlock) {
    self.init(client: client, endpoint: VirtualMIDIDestination(client: client, block: block))
  }
}

fileprivate final class VirtualMIDIDestination: VirtualMIDIEndpoint {
  init(client: MIDIClient, block: @escaping MIDIReadBlock) {
    super.init(ref: MIDIDestinationCreate(ref: client.ref, block: block))
  }

  func send(lst: UnsafePointer<MIDIPacketList>) {
    fatalError()
//    MIDISend(ref, endpoint.ref, lst)
  }
}


fileprivate func MIDIDestinationCreate(ref: MIDIClientRef, block: @escaping MIDIReadBlock) -> MIDIEndpointRef {
  var endpoint: MIDIEndpointRef = 0
  MIDIDestinationCreateWithBlock(ref, "Virtual MIDI destination endpoint" as CFString, &endpoint, block)
  return endpoint
}


