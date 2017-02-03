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

internal final class MIDIEndpoint : Equatable, Comparable, Hashable {
  let ref: MIDIEndpointRef

  init(ref: MIDIEndpointRef) {
    self.ref = ref
    self.isVirtual = false
  }

  init(input client: MIDIClient) {
    self.isVirtual = true
    self.ref = MIDISourceCreate(ref: client.ref)
  }

  init(output client: MIDIClient, block: @escaping MIDIReadBlock) {
    self.isVirtual = true
    self.ref = MIDIDestinationCreate(ref: client.ref, block: block)

  }

  deinit {
    fatalError()
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

  //todo
  let isVirtual: Bool

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


  ///todo comment: note this is an optional, this 
  var type: MIDIPortType? {
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


