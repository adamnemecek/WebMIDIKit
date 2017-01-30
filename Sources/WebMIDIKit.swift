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



internal final class MIDIEndpoint: Equatable, Hashable {
  let ref: MIDIEndpointRef

  fileprivate init(ref: MIDIEndpointRef) {
    self.ref = ref
  }

  internal var hashValue: Int {
    return ref.hashValue
  }

  internal static func ==(lhs: MIDIEndpoint, rhs: MIDIEndpoint) -> Bool {
    return lhs.ref == rhs.ref
  }
}

internal final class MIDIConnection: Hashable {
  fileprivate let port: MIDIPort
  fileprivate let source: MIDIEndpoint

  fileprivate init(port: MIDIPort, source: MIDIEndpoint) {
    self.port = port
    self.source = source
    MIDIPortConnectSource(port.ref, source.ref, nil)
  }

  deinit {
    MIDIPortDisconnectSource(port.ref, source.ref)
  }

  internal static func ==(lhs: MIDIConnection, rhs: MIDIConnection) -> Bool {
    return lhs.port == rhs.port && lhs.source == rhs.source
  }

  internal var hashValue: Int {
    return port.hashValue ^ source.hashValue
  }
}


public final class WebMIDIKit: MIDIManager {
  static let sharedInstance = WebMIDIKit()

  var client: MIDIClient? = nil


  //let clients: [MIDIClient]

  let input: MIDIInput
  let output: MIDIOutput

  private(set) var sources: [MIDIConnection] = []

  private(set) var destinations: [MIDIEndpoint] = []


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
    self.client = client
    self.input = input
    self.output = MIDIOutput(client: client)

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







