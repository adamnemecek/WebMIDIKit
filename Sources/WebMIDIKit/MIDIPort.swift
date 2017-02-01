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

///
/// https://www.w3.org/TR/webmidi/#midiport-interface
///

public class MIDIPort: Hashable, Comparable, CustomStringConvertible, EventTarget {
  //todo this isn't an int
  public typealias Event = MIDIPort

  ///
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
  ///
  public var id: Int {
    return self[int: kMIDIPropertyUniqueID]
  }

  ///
  /// The manufacturer of the port.
  ///

  public var manufacturer: String {
    return self[string: kMIDIPropertyManufacturer]
  }

  ///
  /// The system name of the port.
  ///

  public var name: String {
    return self[string: kMIDIPropertyDisplayName]
  }

  ///
  /// A descriptor property to distinguish whether the port is an input or an
  /// output port. For MIDIOutput, this must be "output". For MIDIInput, this
  /// must be "input".
  ///

  public var type: MIDIPortType {
    return MIDIPortType(MIDIObjectGetType(id: id))
  }

  ///
  /// The version of the port.
  ///
  public var version: Int {
    return self[int: kMIDIPropertyDriverVersion]
  }

  ///
  /// The state of the device.
  ///
  public private(set) var state: MIDIPortDeviceState = .disconnected

  ///
  /// The state of the connection to the device.
  /// https://www.w3.org/TR/webmidi/#idl-def-MIDIPortConnectionState
  ///
  public private(set) var connection: MIDIPortConnectionState = .closed

  ///
  ///
  ///
  public var onStateChange: ((MIDIPort) -> ())? = nil

  ///
  ///
  ///
  open func open(_ eventHandler: ((MIDIPort) -> ())? = nil) {
    //    guard connection != .open else { return }
    connection = .open
    eventHandler?(self)
  }

  ///
  ///
  ///
  open func close(_ eventHandler: ((MIDIPort) -> ())? = nil) {
    //    guard connection != .closed else { return }
    connection = .closed
    onStateChange = nil
    eventHandler?(self)
  }

  public var hashValue: Int {
    return ref.hashValue
  }

  public static func ==(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
    //    return lhs.ref == rhs.ref todo read documnetation?
    return lhs.id == rhs.id
  }

  public static func <(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
    return lhs.id < rhs.id
  }

  public var description: String {
    return "Manufacturer: \(manufacturer)\n" +
      "Name: \(name)\n" +
      "Version: \(version)\n" +
    "Type: \(type)\n"
  }

  internal private(set) var ref: MIDIPortRef
  //todo: should this be weak?
  internal let access: MIDIAccess

  internal init(ref: MIDIPortRef = 0) {
    self.ref = ref
    todo("initportstate")
  }

  internal init(access: MIDIAccess/*port state*/) {
    self.access = access
    todo("initportstate")
  }

  //  internal init(input client: MIDIClient) {
  //    self.ref = 0
  //    self.ref = MIDIInputPortCreate(ref: client.ref) {
  //      _ in
  //    }
  //
  ////    todo("initportstate")
  //  }

  private subscript(string property: CFString) -> String {
    return MIDIObjectGetStringProperty(ref: ref, property: property)
  }

  private subscript(int property: CFString) -> Int {
    return MIDIObjectGetIntProperty(ref: ref, property: property)
  }


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





