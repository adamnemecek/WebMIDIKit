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

///
/// https://www.w3.org/TR/webmidi/#midiport-interface
///

public class MIDIPort: Hashable, Comparable, EventTarget {
  //todo this isn't an int
  public typealias Event = Int

  public var id: Int {
    return self[int: kMIDIPropertyUniqueID]
  }

  public var manufacturer: String {
    return self[string: kMIDIPropertyManufacturer]
  }

  public var name: String {
    return self[string: kMIDIPropertyDisplayName]
  }

  public var type: MIDIPortType {
    return MIDIPortType(MIDIObjectGetType(id: id))
  }

  public var version: Int {
    return self[int: kMIDIPropertyDriverVersion]
  }

  public var state: MIDIPortDeviceState {
//    return _portState.state
    fatalError()
  }

  public var connection: MIDIPortConnectionState {
//    return _portState.connection
    fatalError()
  }

  public var onStateChange: EventHandler<Event> = nil

  public func open() {
//    switch state {
//      case .open: break
//      case .closed: break
//      case .pending: break
//    }
  }

  public func close() {
    guard state != .disconnected else { return }
    todo()
  }

  public var hashValue: Int {
    return ref.hashValue
  }

  public static func ==(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
    return lhs.ref == rhs.ref
  }

  public static func <(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
    return lhs.ref < rhs.ref
  }

  internal private(set) var ref: MIDIPortRef
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

//  public var onStateChange: ((MIDIPort) -> ())? = nil




}

extension MIDIPort: CustomStringConvertible {
  public var description: String {
    return "Manufacturer: \(manufacturer)\n" +
           "Name: \(name)\n" +
           "Version: \(version)\n" +
           "Type: \(type)\n"
  }
}




