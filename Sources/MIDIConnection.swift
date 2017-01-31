//
//  MIDIConnection.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/30/17.
//
//

import CoreMIDI

internal final class MIDIEndpoint: Equatable, Hashable {
  let ref: MIDIEndpointRef

  init(ref: MIDIEndpointRef) {
    self.ref = ref
  }

  var hashValue: Int {
    return ref.hashValue
  }

  static func ==(lhs: MIDIEndpoint, rhs: MIDIEndpoint) -> Bool {
    return lhs.ref == rhs.ref
  }
}

internal final class MIDIConnection: Hashable {
  let port: MIDIInput, source: MIDIEndpoint

  init(port: MIDIInput, source: MIDIEndpoint) {
    (self.port, self.source) = (port, source)
    MIDIPortConnectSource(port.ref, source.ref, nil)
  }

  deinit {
    MIDIPortDisconnectSource(port.ref, source.ref)
  }

  static func ==(lhs: MIDIConnection, rhs: MIDIConnection) -> Bool {
    return (lhs.port, lhs.source) == (rhs.port, rhs.source)
  }

  var hashValue: Int {
    return port.hashValue ^ source.hashValue
  }
}
