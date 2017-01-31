//
//  WebMIDI.swift
//  WarpKit
//
//  Created by Adam Nemecek on 12/6/16.
//
//

import CoreMIDI

fileprivate struct MIDIPortState: Equatable {
  let state: MIDIPortDeviceState, connection: MIDIPortConnectionState

  static func ==(lhs: MIDIPortState, rhs: MIDIPortState) -> Bool {
    return (lhs.state, lhs.connection) == (rhs.state, rhs.connection)
  }
}

public class MIDIPort: Hashable, Comparable {

  internal let ref: MIDIPortRef

  internal init(ref: MIDIPortRef) {
    self.ref = ref
    todo("initportstate")
  }

  private subscript(string property: CFString) -> String {
    return MIDIObjectGetStringProperty(ref: ref, property: property)
  }

  private subscript(int property: CFString) -> Int {
    return MIDIObjectGetIntProperty(ref: ref, property: property)
  }

  public var id: Int {
    return self[int: kMIDIPropertyUniqueID]
  }

  public var manufacturer: String {
    return self[string: kMIDIPropertyManufacturer]
  }

  public var name: String {
    return self[string: kMIDIPropertyDisplayName]
  }

  public var version: Int {
    return self[int: kMIDIPropertyDriverVersion]
  }

  public var type: MIDIPortType {
    return MIDIPortType(MIDIObjectGetType(id: id))
  }

  public var hashValue: Int {
    return ref.hashValue
  }

  public static func ==(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
    return lhs.ref == rhs.ref
  }

  public static func <(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
    return lhs.ref < rhs.ref
  }

  //
  // TODO: when is this set again
  //

  private var _portState: MIDIPortState {
    didSet {
      guard _portState != oldValue else { return }
      todo("dispatch connection event")
    }
  }
  public var state: MIDIPortDeviceState {
    return _portState.state
  }

  public var connection: MIDIPortConnectionState {
    return _portState.connection
  }

//  public var onStateChange: ((MIDIPort) -> ())? = nil


  public func close() {
    guard state != .disconnected else { return }
    todo()
  }

  public func open() {
//    switch state {
//      case .open: break
//      case .closed: break
//      case .pending: break
//    }
  }

}

extension MIDIPort: CustomStringConvertible {
  public var description: String {
    return "Manufacturer: \(manufacturer)\n" +
           "Name: \(name)\n" +
           "Version: \(version)\n" +
           "Type: \(type)\n"
  }
}

public final class MIDIInput: MIDIPort {

  internal init(client: MIDIClient, readmidi: @escaping (UnsafePointer<MIDIPacketList>) -> ()) {

    let port = MIDIInputPortCreate(ref: client.ref) { //packet in
      _ in
      todo("self.onMIDIMessage.map { $0(packet) }")
    }
    super.init(ref: port)
  }

  public var onMIDIMessage: ((UnsafePointer<MIDIPacketList>) -> ())? = nil
}

extension Collection where Index == Int {
  public func index(after i: Index) -> Index {
    return i + 1
  }
}

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

