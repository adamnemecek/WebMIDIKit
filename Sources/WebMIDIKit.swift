//
//  WebMIDIManager.swift
//  WarpKit
//
//  Created by Adam Nemecek on 12/7/16.
//
//

import AVFoundation

public class MIDIManager {
  fileprivate let clients: Set<MIDIClient> = []

  let inputs: [MIDIInput] = []
  let outputs: [MIDIOutput] = []

  //    var input: WebMIDIInput {
  //        return WebMIDIInput()
  //    }
  //
  //    var output: WebMIDIOutput {
  //        fatalError()
  //    }
}



public final class WebMIDIKit: MIDIManager {
  static let sharedInstance = WebMIDIKit()

  private var client: MIDIClient? = nil


  //let clients: [MIDIClient]

  let input: MIDIInput
  let output: MIDIOutput

  private(set) var sources: [MIDIConnection] = []

  private(set) var destinations: [MIDIEndpoint] = []

  public var onStateChange: (MIDIPort) -> () = { _ in }

  private func notification(ptr: UnsafePointer<MIDINotification>) {
    _ = MIDIObjectAddRemoveNotification(ptr: ptr).map {
      let endpoint = MIDIEndpoint(ref: $0.child)

      switch (ptr.pointee.messageID, $0.childType) {
      case (.msgObjectAdded, .source):
        if let s = (sources.first { $0.source == endpoint }) {
          s.port.state = .connected
          //notificy clients
        }
        else {
          let conn = MIDIConnection(port: self.input, source: endpoint)
          self.sources.append(conn)
        }
      case (.msgObjectAdded, .destination):
        if let d = (destinations.first { $0 == endpoint }) {

          //setoutputportstate(port, opened)
        }
        else {
          destinations.append(endpoint)
        }

      case (.msgObjectRemoved, .source):
        sources = sources.filter {
          let remove = $0.source == endpoint
          if remove {
            //            $0.port.connection = .disconnected
          }
          return remove
        }
        if let s = (sources.first { $0.source == endpoint }) {

          //setinputportstate, disconnected
        }

      case (.msgObjectRemoved, .destination):
        if let d = (destinations.first { $0 == endpoint }) {
          //setoutputportstate(d, disconnected)
        }
      default: break
      }
    }
  }

  private func midi(src: MIDIEndpointRef, lst: UnsafePointer<MIDIPacketList>) {
    let first = sources.first { $0.source.ref == src }
    _ = first.map {
      _ in
      lst.pointee.forEach {
          packet in
      }
    }
  }

  private override init() {

    // the callback ReceiveMidiNotify
    let client = MIDIClient { _ in
      //      self?.notification(ptr: $0)

      fatalError("stuff")
    }

    let input = MIDIInput(client: client) {
      e in
      //readmididispatch
      //            self.clients
    }
    self.output = MIDIOutput(client: client)

    self.client = client
    self.input = input

    self.sources = MIDISources().map {
      MIDIConnection(port: input,
                     source: MIDIEndpoint(ref: $0))
    }
    
    self.destinations = MIDIDestinations().map {
      MIDIEndpoint(ref: $0)
    }
    
    super.init()
  }

  deinit {

  }
}







