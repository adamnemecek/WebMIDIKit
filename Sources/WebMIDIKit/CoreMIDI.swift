//
//  Utils.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/30/17.
//
//

import AudioToolbox

extension MIDIObjectAddRemoveNotification : CustomStringConvertible {

    public var description: String {
        return "message\(messageID)"
    }

    internal init?(ptr: UnsafePointer<MIDINotification>) {
        switch ptr.pointee.messageID {
        case .msgObjectAdded, .msgObjectRemoved:
            self = UnsafeRawPointer(ptr).assumingMemoryBound(to: MIDIObjectAddRemoveNotification.self).pointee
        default:
            return nil
        }
    }
}

//@inline(__always) internal
//func AudioGetCurrentMIDITimeStamp(offset: Double = 0) -> MIDITimeStamp {
//    let _offset = AudioConvertNanosToHostTime(UInt64(offset * 1000000))
//    return AudioGetCurrentHostTime() + _offset
//}

@inline(__always) internal
func OSAssert(_ err: OSStatus, function: String = #function) {
    //assert(err == noErr, "Error (osstatus: \(err)) in \(function)")
}
