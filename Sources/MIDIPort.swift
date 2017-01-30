//
//  WebMIDI.swift
//  WarpKit
//
//  Created by Adam Nemecek on 12/6/16.
//
//

import AVFoundation

public class MIDIPort: Comparable, Hashable, CustomStringConvertible {
  internal let ref: MIDIPortRef

  fileprivate weak var client: MIDIClient? = nil

  internal init(client: MIDIClient?, ref: MIDIPortRef) {
    self.ref = ref

    _ = client.map {
      self.client = $0
      fatalError("connect")
    }
  }

//  internal init?(client: MIDIClient, where: (MIDIPort) -> Bool) {
//    fatalError()
//  }

  deinit {
    _ = self.client.map {
      MIDIPortDisconnectSource(ref, $0.ref)
      fatalError("")
    }
    //        MIDIPortDispose(ref)
  }

  public var hashValue: Int {
    return ref.hashValue
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

  public internal(set) var state: MIDIPortDeviceState = .disconnected

  public var type: MIDIPortType {
    return MIDIPortType(MIDIObjectGetType(id: id))
  }

  public var connection: MIDIPortConnectionState {
    fatalError()
  }

  public var description: String {
    return "Manufacturer: \(manufacturer)\n" +
          "Name: \(name)\n" +
          "Version: \(version)\n" +
          "Type: \(type)\n"
  }

  public static func ==(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
    return lhs.ref == rhs.ref
  }

  public static func <(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
    return lhs.ref < rhs.ref
  }

  open func onstatechange(event: Int) {

  }

  public func close() {
    guard state != .disconnected else { return }
    fatalError()
  }

  private subscript(string property: CFString) -> String {
    return MIDIObjectGetStringProperty(ref: ref, property: property)
  }


  private subscript(int property: CFString) -> Int {
    return MIDIObjectGetIntProperty(ref: ref, property: property)
  }
}

public final class MIDIInput: MIDIPort {

  internal init(client: MIDIClient, readmidi: @escaping (MIDIPacketList) -> ()) {
    let port = MIDIInputPortCreate(ref: client.ref, readmidi: readmidi)
    super.init(client: client, ref: port)
  }

  //    func onmidimessage(event: Int) {
  //
  //    }

}

extension Collection where Index == Int {
  public func index(after i: Index) -> Index {
    return i + 1
  }
}

//public struct MIDIInputMap: Collection {
//    public typealias Index = Int
//    public typealias Element = MIDIInput
//
//    public var startIndex: Index {
//        return 0
//    }
//
//    public var endIndex: Index {
//        return MIDIGetNumberOfSources()
//    }
//
//    public subscript (index: Index) -> Element {
//        return Element(ref: MIDIGetSource(index)) {
//          _ in
//        }
//
//    }
//}

public final class MIDIOutput: MIDIPort {
  internal init(client: MIDIClient) {
    super.init(client: client,
               ref: MIDIPortRefCreate(ref: client.ref))
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

//struct MIDIOutputMap {
//    typealias Index = Int
//    typealias Element = MIDIOutput
//
//    var startIndex: Index {
//        return 0
//    }
//
//    var endIndex: Index {
//        return MIDIGetNumberOfDestinations()
//    }
//
//    subscript (index: Index) -> Element {
////        return Element(ref: MIDIGetDestination(index))
//        fatalError()
//    }
//}
