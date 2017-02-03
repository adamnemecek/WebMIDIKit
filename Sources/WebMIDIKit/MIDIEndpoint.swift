//
//  MIDIEndpoint.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 2/2/17.
//
//

import CoreMIDI

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


//
// you can think of this as the HW port
//

internal final class MIDIEndpoint : Equatable, Comparable, Hashable {
  let ref: MIDIEndpointRef
  let isVirtual: Bool

  init(ref: MIDIEndpointRef, isVirtual: Bool = false) {
    self.ref = ref
    self.isVirtual = isVirtual
  }

  init(input client: MIDIClient) {
    self.ref = MIDISourceCreate(ref: client.ref)
    self.isVirtual = true
  }

  init(output client: MIDIClient, block: @escaping MIDIReadBlock) {
    self.ref = MIDIDestinationCreate(ref: client.ref, block: block)
    self.isVirtual = true
  }

  deinit {
    if isVirtual {
      MIDIEndpointDispose(ref)
    }
  }

  var hashValue: Int {
    return id
  }

  static func ==(lhs: MIDIEndpoint, rhs: MIDIEndpoint) -> Bool {
    return lhs.id == rhs.id
  }

  static func <(lhs: MIDIEndpoint, rhs: MIDIEndpoint) -> Bool {
    return lhs.id < rhs.id
  }

  var id: Int {
    return self[int: kMIDIPropertyUniqueID]
  }

  var manufacturer: String {
    return self[string: kMIDIPropertyManufacturer]
  }

  var name: String {
    //todo fullanme
    return self[string: kMIDIPropertyName]
  }

  /// For our purposes, enpoint can only be an input, output or other (if it's
  /// virtual). If it's virtual, we cannot determine whether it's an input 
  /// or output based on the
  var type: MIDIPortType {
    return MIDIPortType(MIDIObjectGetType(id: id))
  }

  var version: Int {
    return self[int: kMIDIPropertyDriverVersion]
  }

  private subscript(string property: CFString) -> String {
    return MIDIObjectGetStringProperty(ref: ref, property: property)
  }

  private subscript(int property: CFString) -> Int {
    return MIDIObjectGetIntProperty(ref: ref, property: property)
  }

  func flush() {
    MIDIFlushOutput(ref)
  }
}


