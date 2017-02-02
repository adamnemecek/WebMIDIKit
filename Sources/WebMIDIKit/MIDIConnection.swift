//
//  MIDIConnection.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/30/17.
//
//

import CoreMIDI

//
//
//
internal struct MIDIEndpoint : Equatable, Comparable, Hashable {
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

  static func <(lhs: MIDIEndpoint, rhs: MIDIEndpoint) -> Bool {
    return lhs.ref < rhs.ref
  }
}

public final class MIDIConnection : Equatable, Comparable, Hashable {
  public let port: MIDIInput
  internal let source: MIDIEndpoint

  internal init(port: MIDIInput, source: MIDIEndpoint) {
    (self.port, self.source) = (port, source)
    MIDIPortConnectSource(port.ref, source.ref, nil)
  }

  deinit {
    MIDIPortDisconnectSource(port.ref, source.ref)
    //the docs say that you don't need to call MIDIPortDispose but idk
  }

  public static func ==(lhs: MIDIConnection, rhs: MIDIConnection) -> Bool {
    return (lhs.port, lhs.source) == (rhs.port, rhs.source)
  }

  public static func <(lhs: MIDIConnection, rhs: MIDIConnection) -> Bool {
    return lhs.port < rhs.port
  }

  public var hashValue: Int {
    return port.hashValue ^ source.hashValue
  }
}
