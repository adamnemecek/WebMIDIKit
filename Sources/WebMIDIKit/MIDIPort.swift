//
//  WebMIDI.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/6/16.
//
//

import CoreMIDI

/// This interface represents a MIDI input or output port.
/// See [spec](https://www.w3.org/TR/webmidi/#midiport-interface)
public class MIDIPort : Equatable, Comparable, Hashable, CustomStringConvertible, EventTarget {

  public typealias Event = MIDIPort

  /// A unique ID of the port. This can be used by developers to remember ports
  /// the user has chosen for their application. This is maintained across
  /// instances of the application - e.g., when the system is rebooted - and a
  /// device is removed from the system. Applications may want to cache these
  /// ids locally to re-create a MIDI setup. Applications may use the comparison
  /// of id of MIDIPorts to test for equality.
  public var id: Int {
    return endpoint.id
  }

  /// The manufacturer of the port.
  public var manufacturer: String {
    return endpoint.manufacturer
  }

  /// The system name of the port.
  public var name: String {
    return endpoint.name
  }

  /// A descriptor property to distinguish whether the port is an input or an
  /// output port. For MIDIOutput, this must be "output". For MIDIInput, this
  /// must be "input".
  public var type: MIDIPortType {
    return endpoint.type
  }

  /// The version of the port.
  public var version: Int {
    return endpoint.version
  }

  /// The state of the device.
  public private(set) var state: MIDIPortDeviceState = .connected
  //{
  //    didSet {
  //      guard oldValue != state else { return }
  //      onStateChange?(self)
  //    }
  //  }

  /// The state of the connection to the device.
  public private(set) var connection: MIDIPortConnectionState = .closed {
    didSet {
      guard oldValue != connection else { return }
      onStateChange?(self)
    }
  }

  ///
  ///
  ///
  public var onStateChange: ((MIDIPort) -> ())? = nil

  ///
  ///
  ///
  public func open(_ eventHandler: ((MIDIPort) -> ())? = nil) {
    guard connection != .open else { return }
    assert(ref == 0)
    
    switch type {

    case .input:
      let input = self as! MIDIInput
      ref = MIDIInputPortCreate(ref: client.ref) { (lst, src) in
        lst.pointee.forEach {
          input.onMIDIMessage?($0)
        }
      }

    case .output:
      ref = MIDIOutputPortRefCreate(ref: client.ref)
    }
    connection = .open
    eventHandler?(self)
  }

  ///
  ///
  ///
  public func close(_ eventHandler: ((MIDIPort) -> ())? = nil) {
    guard connection != .closed else { return }
    assert(ref != 0)

    switch type {
    case .input:
      MIDIPortDisconnectSource(ref, endpoint.ref)
    case .output:
      break
    }

    connection = .closed
    ref = 0
    onStateChange = nil
    eventHandler?(self)
  }

  public var hashValue: Int {
    return endpoint.hashValue
  }

  public static func ==(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
    return lhs.endpoint == rhs.endpoint
  }

  public static func <(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
    return lhs.endpoint < rhs.endpoint
  }

  public var description: String {
    return "type: \(type)\n" +
          "name: \(name)\n" +
          "manufacturer: \(manufacturer)\n" +
          "id: \(id)\n" +
          "state: \(state)\n" +
          "connection: \(connection)\n" +
          "version: \(version)"
  }

  internal private(set) var ref: MIDIPortRef

  //todo: should this be weak?
  //  internal let access: MIDIAccess
  internal let client: MIDIClient
  internal let endpoint: MIDIEndpoint

  internal init(client: MIDIClient, endpoint: MIDIEndpoint) {
    self.client = client
    self.endpoint = endpoint
    self.ref = 0
  }
}

fileprivate func MIDIInputPortCreate(ref: MIDIClientRef, readmidi: @escaping MIDIReadBlock) -> MIDIPortRef {
  var port = MIDIPortRef()
  MIDIInputPortCreateWithBlock(ref, "MIDI input" as CFString, &port) {
    packetlist, srcconref in
    readmidi(packetlist, srcconref)
  }
  return port
}

fileprivate func MIDIOutputPortRefCreate(ref: MIDIClientRef) -> MIDIPortRef {
  var port = MIDIPortRef()
  MIDIOutputPortCreate(ref, "MIDI output" as CFString, &port)
  return port
}





