//
//  MIDIEndpoint.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 2/2/17.
//
//

import CoreMIDI

//
// you can think of this as the HW port
//

internal class MIDIEndpoint : Equatable, Comparable, Hashable {
  final let ref: MIDIEndpointRef

  init(ref: MIDIEndpointRef) {
    self.ref = ref
  }

  final var hashValue: Int {
    return id
  }

  static func ==(lhs: MIDIEndpoint, rhs: MIDIEndpoint) -> Bool {
    return lhs.id == rhs.id
  }

  static func <(lhs: MIDIEndpoint, rhs: MIDIEndpoint) -> Bool {
    return lhs.id < rhs.id
  }

  final var id: Int {
    return self[int: kMIDIPropertyUniqueID]
  }

  final var manufacturer: String {
    return self[string: kMIDIPropertyManufacturer]
  }

  final var name: String {
    //todo fullanme
    return self[string: kMIDIPropertyName]
  }

  /// For our purposes, enpoint can only be an input, output or other (if it's
  /// virtual). If it's virtual, we cannot determine whether it's an input 
  /// or output based on the
  final var type: MIDIPortType {
    return MIDIPortType(MIDIObjectGetType(id: id))
  }

  final var version: Int {
    return self[int: kMIDIPropertyDriverVersion]
  }

  private subscript(string property: CFString) -> String {
    return MIDIObjectGetStringProperty(ref: ref, property: property)
  }

  private subscript(int property: CFString) -> Int {
    return MIDIObjectGetIntProperty(ref: ref, property: property)
  }

  final func flush() {
    MIDIFlushOutput(ref)
  }

}

class VirtualMIDIEndpoint: MIDIEndpoint {
  deinit {
    MIDIEndpointDispose(ref)
  }
}

///
/// source != input, source is a hw (or virtual) port, input is connected port
///
final class VirtualMIDISource: VirtualMIDIEndpoint {
  init(client: MIDIClient) {
    super.init(ref: MIDISourceCreate(ref: client.ref))
  }
}

final class VirtualMIDIDestination: VirtualMIDIEndpoint {
  init(client: MIDIClient, block: @escaping MIDIReadBlock) {
    super.init(ref: MIDIDestinationCreate(ref: client.ref, block: block))
  }

  func send(lst: UnsafePointer<MIDIPacketList>) {
    MIDIReceived(ref, lst)
  }
}

//todo cleanup
fileprivate func MIDISourceCreate(ref: MIDIClientRef) -> MIDIEndpointRef {
  var endpoint: MIDIEndpointRef = 0
  MIDISourceCreate(ref, "Virtual MIDI source endpoint" as CFString, &endpoint)
  return endpoint
}

fileprivate func MIDIDestinationCreate(ref: MIDIClientRef, block: @escaping MIDIReadBlock) -> MIDIEndpointRef {
  var endpoint: MIDIEndpointRef = 0
  MIDIDestinationCreateWithBlock(ref, "Virtual MIDI destination endpoint" as CFString, &endpoint, block)
  return endpoint
}

fileprivate func MIDIObjectGetStringProperty(ref: MIDIObjectRef, property: CFString) -> String {
  var string: Unmanaged<CFString>? = nil
  MIDIObjectGetStringProperty(ref, property, &string)
  return (string?.takeRetainedValue())! as String
}

fileprivate func MIDIObjectGetIntProperty(ref: MIDIObjectRef, property: CFString) -> Int {
  var val: Int32 = 0
  MIDIObjectGetIntegerProperty(ref, property, &val)
  return Int(val)
}

fileprivate func MIDIObjectGetType(id: Int) -> MIDIObjectType {
  var ref: MIDIObjectRef = 0
  var type: MIDIObjectType = .other
  MIDIObjectFindByUniqueID(MIDIUniqueID(id), &ref, &type)
  return type
}
