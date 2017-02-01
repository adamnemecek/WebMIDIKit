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
public final class MIDIAccess: EventTarget {
//  static let sharedInstance = MIDIAccess()
  public typealias Event = MIDIPort

  public private(set) var inputs = MIDIInputMap()
  public private(set) var outputs = MIDIOutputMap()

  public var onStateChange: EventHandler<Event> = nil

  internal private(set) var client: MIDIClient? = nil
  private let clients: Set<MIDIClient> = []

  private let input: MIDIInput
  private let output: MIDIOutput

  public init() {

    // the callback ReceiveMidiNotify
    let client = MIDIClient { _ in
//            self.notification(ptr: $0)
      fatalError()

//      fatalError("stuff")
    }
    fatalError()

//    let input = MIDIInput(client: client)

    self.output = MIDIOutput(client: client)

    self.client = client
//    self.input = input

    self.sources = MIDISources().map {
      //
      // connect
      //
      MIDIConnection(port: input,
                     source: MIDIEndpoint(ref: $0))
    }
    
    self.destinations = MIDIDestinations().map {
      MIDIEndpoint(ref: $0)
    }


    self.input.onMIDIMessage = {
      self.midi(src: 0, lst: $0)
    }

  }

  private(set) var sources: [MIDIConnection] = []

  private(set) var destinations: [MIDIEndpoint] = []

  private func notification(ptr: UnsafePointer<MIDINotification>) {
    _ = MIDIObjectAddRemoveNotification(ptr: ptr).map {
      let endpoint = MIDIEndpoint(ref: $0.child)

      switch (ptr.pointee.messageID, $0.childType) {
      case (.msgObjectAdded, .source):
        if let s = (sources.first { $0.source == endpoint }) {
          todo("port.state = .connected")
          clients.forEach {
            _ in
          }
        }
        else {
          let conn = MIDIConnection(port: self.input, source: endpoint)
          self.sources.append(conn)
        }
      case (.msgObjectAdded, .destination):
        if !destinations.appendUnique(newElement: endpoint) {
          //setoutputportstate(port, opened)
        }
      case (.msgObjectRemoved, .source):
        sources = sources.filter {
          let remove = $0.source == endpoint
          if remove {
            //            $0.port.connection = .disconnected
          }
          return remove
        }
        if let _ = (sources.first { $0.source == endpoint }) {

          //setinputportstate, disconnected
        }

      case (.msgObjectRemoved, .destination):
        if destinations.contains(endpoint) {
          //setoutputportstate(d, disconnected)
        }
        else {

        }
      default: break
      }
    }
  }

  internal func send<S: Sequence>(port: MIDIOutput, data: S, timestamp: Int = 0) where S.Iterator.Element == UInt8 {
      guard var p = MIDIPacketList(seq: data) else { return }
//      timestamp = timestamp == 0 ? 

      MIDISend(port.ref, 0, &p)
      todo("endpoint, timestamp = 0 ?? now, notify all clients?")

  }

  private func midi(src: MIDIEndpointRef, lst: UnsafePointer<MIDIPacketList>) {
    _ = sources.first { $0.source.ref == src }.map {
      _ in
      lst.pointee.forEach {
          packet in
      }
    }
  }



  deinit {

  }
}


func test() {
  let access = MIDIAccess()
  let p: MIDIPacket = [1,2,3]




}






