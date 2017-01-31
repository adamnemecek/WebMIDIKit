//
//  MIDIConnection.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/30/17.
//
//

import AVFoundation

internal final class MIDIEndpoint: Equatable, Hashable {
  let ref: MIDIEndpointRef

  internal init(ref: MIDIEndpointRef) {
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
  internal let port: MIDIInput
  internal let source: MIDIEndpoint

  internal init(port: MIDIInput, source: MIDIEndpoint) {
    (self.source, self.port) = (source, port)
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
