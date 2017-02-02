//
//  MIDIAccess.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/7/16.
//
//

import CoreMIDI

public typealias EventHandler<T> = ((T) -> ())?

public protocol EventTarget {
  associatedtype Event
  var onStateChange: EventHandler<Event> { get set }
}

///
/// https://www.w3.org/TR/webmidi/#midiaccess-interface
public final class MIDIAccess : EventTarget, CustomStringConvertible {
//  static let sharedInstance = MIDIAccess()
  public typealias Event = MIDIPort

  public private(set) var inputs: MIDIInputMap! = nil
  public private(set) var outputs: MIDIOutputMap! = nil

  public var onStateChange: EventHandler<Event> = nil

  internal let client: MIDIClient
  private let clients: Set<MIDIClient> = []

  private var input: MIDIInput! = nil
  private var output: MIDIOutput! = nil

  public init() {
    // the callback ReceiveMidiNotify

    let client = MIDIClient()

    self.client = client
    self.inputs = MIDIInputMap(client: client)
    self.outputs = MIDIOutputMap(client: client)


    /// these are virtual ports, i.e. ports without an associated endpoint
    self.input = MIDIInput(client: client)
    self.output = MIDIOutput(client: client)

//    self.sources = MIDISources().map {
//      //
//      // connect
//      //
//      MIDIConnection(port: input,
//                     source: MIDIEndpoint(ref: $0))
//    }
//    
//    self.destinations = MIDIDestinations().map {
//      MIDIEndpoint(ref: $0)
//    }


    self.input.onMIDIMessage = {
      self.midi(src: 0, lst: $0)
    }

  }

//  private(set) var sources: [MIDIConnection] = []

//  private(set) var destinations: [MIDIEndpoint] = []

  private func notification(ptr: UnsafePointer<MIDINotification>) {
    //todo string(p.id)
    _ = MIDIObjectAddRemoveNotification(ptr: ptr).map {
      let endpoint = $0.endpoint
      let type = MIDIPortType($0.childType)

      switch (ptr.pointee.messageID, type) {

      case (.msgObjectAdded, .input):
        let p = MIDIInput(client: self.client, endpoint: endpoint)
        self.inputs[String(p.id)] = p

      case (.msgObjectAdded, .output):
        let p = MIDIOutput(client: self.client, endpoint: endpoint)
        self.outputs[String(p.id)] = p

      case (.msgObjectRemoved, .input):
        assert(self.inputs[endpoint] != nil)
        self.inputs[endpoint] = nil

      case (.msgObjectRemoved, .output):
        assert(self.outputs[endpoint] != nil)
        self.outputs[endpoint] = nil

      default:
        break
      }
    }
  }

  public var description: String {
    fatalError()
  }

  internal func send<S: Sequence>(port: MIDIOutput, data: S, timestamp: Int = 0) where S.Iterator.Element == UInt8 {
      guard var p = MIDIPacketList(seq: data) else { return }
//      timestamp = timestamp == 0 ? 

      MIDISend(port.ref, 0, &p)
      todo("endpoint, timestamp = 0 ?? now, notify all clients?")

  }

  private func midi(src: MIDIEndpointRef, lst: UnsafePointer<MIDIPacketList>) {
//    _ = sources.first { $0.source.ref == src }.map {
//      _ in
//      lst.pointee.forEach {
//          packet in
//      }
//    }
  }



  deinit {

  }
}


func test() {
  let access = MIDIAccess()
  let p: MIDIPacket = [1,2,3]




}






