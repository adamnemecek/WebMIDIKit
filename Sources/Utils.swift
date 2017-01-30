//
//  Utils.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/30/17.
//
//

import Foundation
import AVFoundation

internal func MIDIObjectGetStringProperty(ref: MIDIObjectRef, property: CFString) -> String {
  var string: Unmanaged<CFString>? = nil
  MIDIObjectGetStringProperty(ref, property, &string)
  return (string?.takeRetainedValue())! as String
}

internal func MIDIObjectGetIntProperty(ref: MIDIObjectRef, property: CFString) -> Int {
  var val: Int32 = 0
  MIDIObjectGetIntegerProperty(ref, property, &val)
  return Int(val)
}

internal func MIDIObjectGetType(id: Int) -> MIDIObjectType {
  var ref: MIDIObjectRef = 0
  var type: MIDIObjectType = .other
  MIDIObjectFindByUniqueID(MIDIUniqueID(id), &ref, &type)
  return type
}

internal func MIDISources() -> [MIDIEndpointRef] {
  return (0..<MIDIGetNumberOfSources()).map(MIDIGetSource)
}

internal func MIDIDestinations() -> [MIDIEndpointRef] {
  return (0..<MIDIGetNumberOfDestinations()).map(MIDIGetDestination)
}

internal func MIDIPortRefCreate(ref: MIDIClientRef) -> MIDIPortRef {
  var ref = MIDIPortRef()
  MIDIOutputPortCreate(ref, "MIDI output" as CFString, &ref)
  return ref
}

internal func MIDIClientCreate(callback: @escaping (UnsafePointer<MIDINotification>) -> ()) -> MIDIClientRef {
  var ref =  MIDIClientRef()
  MIDIClientCreateWithBlock("WebMIDIKit" as CFString, &ref) {
    callback($0)
  }
  return ref
}


internal func MIDIInputPortCreate(ref: MIDIClientRef, readmidi: @escaping (MIDIPacketList) -> ()) -> MIDIPortRef {
  var ref = MIDIPortRef()

  MIDIInputPortCreateWithBlock(ref, "MIDI input" as CFString, &ref) {
    packetlist, srcconref in
    readmidi(packetlist.pointee)
  }
  return ref
}


