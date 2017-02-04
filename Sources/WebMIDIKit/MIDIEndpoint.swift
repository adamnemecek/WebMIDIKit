//
//  MIDIEndpoint.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 2/2/17.
//
//

import CoreMIDI
import func AXMIDI.MIDISendExt

//
// you can think of this as the HW input/output or virtual endpoint
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
