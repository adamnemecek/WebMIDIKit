//
//  WebMIDI.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/6/16.
//
//

import CoreMIDI
import AXMIDI

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
  final public var id: Int {
    return endpoint.id
  }

  /// The manufacturer of the port.
  final public var manufacturer: String {
    return endpoint.manufacturer
  }

  /// The system name of the port.
  final public var name: String {
    return endpoint.name
  }

  /// A descriptor property to distinguish whether the port is an input or an
  /// output port. For MIDIOutput, this must be "output". For MIDIInput, this
  /// must be "input".
  final public var type: MIDIPortType {
    return endpoint.type
  }

  /// The version of the port.
  final public var version: Int {
    return endpoint.version
  }

  /// The state of the connection to the device.
  final public var connection: MIDIPortConnectionState {
    return ref == 0 ? .closed : .open
  }

  final public var state: MIDIPortDeviceState {
    return endpoint.state
  }
  ///
  ///
  ///
  final public var onStateChange: ((MIDIPort) -> ())? = nil

  ///
  ///
  ///
  final public func open(_ eventHandler: ((MIDIPort) -> ())? = nil) {
    guard connection != .open else { return }

    switch type {

    case .input:
      let `self` = self as! MIDIInput
      ref = MIDIInputPortCreateExt(ref: client.ref) {
        `self`.onMIDIMessage?($0)
      }

      MIDIPortConnectSource(ref, endpoint.ref, nil)

    case .output:
      ref = MIDIOutputPortRefCreate(ref: client.ref)
    }

    onStateChange?(self)
    eventHandler?(self)
  }

  ///
  ///
  ///
  final public func close(_ eventHandler: ((MIDIPort) -> ())? = nil) {
    guard connection != .closed else { return }

    switch type {
    case .input:
      MIDIPortDisconnectSource(ref, endpoint.ref)
    case .output:
      break
    }

    ref = 0
    onStateChange?(self)
    onStateChange = nil
    eventHandler?(self)
  }

  final public var hashValue: Int {
    return endpoint.hashValue
  }

  public static func ==(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
    return lhs.endpoint == rhs.endpoint
  }

  public static func <(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
    return lhs.endpoint < rhs.endpoint
  }

  final public var description: String {
    let t = self is MIDIInput ? "MIDIInput" : "MIDIOutput"
    return "\(t): \(name) by \(manufacturer), connection: \(connection) (id: \(id))"
  }

  internal private(set) final var ref: MIDIPortRef

  internal private(set) final weak var client: MIDIClient!
  internal final let endpoint: MIDIEndpoint

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

fileprivate func MIDIInputPortCreateExt(ref: MIDIClientRef, readmidi: @escaping (MIDIPacket) -> ()) -> MIDIPortRef {
  return MIDIInputPortCreate(ref: ref) {
    lst, ref in

    var ptr = MIDIPacketListGetPacketPtr(lst)
    (0..<lst.pointee.numPackets).forEach { _ in
      defer {
        ptr = MIDIPacketNext(ptr)
      }
      readmidi(ptr.pointee)
    }
  }
}

fileprivate func MIDIOutputPortRefCreate(ref: MIDIClientRef) -> MIDIPortRef {
  var port = MIDIPortRef()
  MIDIOutputPortCreate(ref, "MIDI output" as CFString, &port)
  return port
}





