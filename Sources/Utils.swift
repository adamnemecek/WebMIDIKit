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
