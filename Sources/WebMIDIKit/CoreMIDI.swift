//
//  Utils.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/30/17.
//
//
import CoreMIDI
import func AXMIDI.MIDINotificationToEndpointNotification

extension MIDIObjectAddRemoveNotification : CustomStringConvertible {
  internal init?(ptr: UnsafePointer<MIDINotification>) {
    guard let n = MIDINotificationToEndpointNotification(ptr)?.pointee else { return nil }
    self = n
  }

  public var description: String {
    return "message\(messageID)"
  }

  internal var endpoint: MIDIEndpoint {
    assert(MIDIPortType(childType) == MIDIEndpoint(ref: child).type)
    return MIDIEndpoint(ref: child)
  }
}
