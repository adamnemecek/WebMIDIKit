//
//  WebMIDI.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/6/16.
//
//

import CoreMIDI

fileprivate struct MIDIPortState: Equatable {
  let state: MIDIPortDeviceState, connection: MIDIPortConnectionState

  static func ==(lhs: MIDIPortState, rhs: MIDIPortState) -> Bool {
    return (lhs.state, lhs.connection) == (rhs.state, rhs.connection)
  }
}

//typealias Sink<T> = (T) -> ()

//typealias Source<T> = () -> T

/// This interface represents a MIDI input or output port.
/// See [spec](https://www.w3.org/TR/webmidi/#midiport-interface)
public class MIDIPort : Equatable, Comparable, Hashable, CustomStringConvertible, EventTarget {

  //todo this isn't an int
  public typealias Event = MIDIPort

  /// A unique ID of the port. This can be used by developers to remember ports
  /// the user has chosen for their application. The User Agent must ensure that
  /// the id is unique to only that port. The User Agent should ensure that the
  /// id is maintained across instances of the application - e.g., when the
  /// system is rebooted - and when a device is removed from the system.
  /// Applications may want to cache these ids locally to re-create a MIDI
  /// setup. Some systems may not support completely unique persistent
  /// identifiers; in such cases, it will be more challenging to maintain
  /// identifiers when another interface is added or removed from the system.
  /// (This might throw off the index of the requested port.) It is expected
  /// that the system will do the best it can to match a port across instances
  /// of the MIDI API: for example, an implementation may opaquely use some
  /// form of hash of the port interface manufacturer, name and index as the id,
  /// so that a reference to that port id is likely to match the port when
  /// plugged in. Applications may use the comparison of id of MIDIPorts to test
  /// for equality.
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
    open()
    return endpoint.type
  }

  /// The version of the port.
  public var version: Int {
    return endpoint.version
  }

  /// The state of the device.
  public private(set) var state: MIDIPortDeviceState = .disconnected
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
    //    guard connection != .open else { return }
    connection = .open
    eventHandler?(self)
  }


  internal func connect(ref: @autoclosure () -> MIDIPortRef) {
    self.ref = ref()
  }
  ///
  ///
  ///
  public func close(_ eventHandler: ((MIDIPort) -> ())? = nil) {
    //    guard connection != .closed else { return }
    connection = .closed

    onStateChange = nil
    eventHandler?(self)
  }

  public var hashValue: Int {
    return id
  }

  /// Two ports are equal todo
  public static func ==(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
    //    return lhs.ref == rhs.ref todo read documnetation?
    return lhs.endpoint == rhs.endpoint
  }

  public static func <(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
    return lhs.endpoint == rhs.endpoint
  }

  public var description: String {
    return "Type: \(type)\n" +
           "Name: \(name)\n" +
           "Manufacturer: \(manufacturer)\n" +
           "Id: \(id)"
  }

  internal var ref: MIDIPortRef = 0
  //todo: should this be weak?
//  internal let access: MIDIAccess
  internal let client: MIDIClient
  internal let endpoint: MIDIEndpoint

//  internal init(ref: MIDIPortRef = 0) {
//    self.ref = ref
//    todo("initportstate")
//  }

  internal init(client: MIDIClient, endpoint: MIDIEndpoint, ref: MIDIPortRef) {
    self.client = client
    self.endpoint = endpoint
    self.ref = ref
  }

  //  internal init(input client: MIDIClient) {
  //    self.ref = 0
  //    self.ref = MIDIInputPortCreate(ref: client.ref) {
  //      _ in
  //    }
  //
  ////    todo("initportstate")
  //  }

  //
  // TODO: when is this set again
  //

  //  private var _portState: MIDIPortState {
  //    didSet {
  //      guard _portState != oldValue else { return }
  //      todo("dispatch connection event")
  //    }
  //  }
}





