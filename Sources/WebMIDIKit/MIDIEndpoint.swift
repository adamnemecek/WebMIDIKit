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

internal struct MIDIEndpoint : Equatable, Comparable, Hashable {
  let ref: MIDIEndpointRef

  init(ref: MIDIEndpointRef = MIDIEntityRef()) {
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
