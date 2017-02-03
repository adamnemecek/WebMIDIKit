//
//  Utils.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/30/17.
//
//
import CoreMIDI

extension MIDIObjectAddRemoveNotification : CustomStringConvertible {
  internal init?(ptr: UnsafePointer<MIDINotification>) {
    switch ptr.pointee.messageID {
    case .msgObjectAdded, .msgObjectRemoved:
      self = ptr.withMemoryRebound(to: MIDIObjectAddRemoveNotification.self, capacity: 1) {
        $0.pointee
      }
    default: return nil
    }
  }

  public var description: String {
    return "\(messageID)"
  }

  internal var endpoint: MIDIEndpoint {
    assert(MIDIPortType(childType) == MIDIEndpoint(ref: child).type)
    return MIDIEndpoint(ref: child)
  }

}




