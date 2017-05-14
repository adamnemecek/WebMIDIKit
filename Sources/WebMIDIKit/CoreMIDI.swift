//
//  Utils.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/30/17.
//
//

import AudioToolbox
import Foundation

extension MIDIObjectAddRemoveNotification : CustomStringConvertible {


    public var description: String {
        return "message\(messageID)"
    }

    internal var endpoint: MIDIEndpoint {
        assert(MIDIPortType(childType) == MIDIEndpoint(ref: child).type)
        return MIDIEndpoint(ref: child)
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

@inline(__always)
func AudioGetCurrentMIDITimeStamp(offset: Double = 0) -> MIDITimeStamp {
    let _offset = AudioConvertNanosToHostTime(UInt64(offset * 1000000))
    return AudioGetCurrentHostTime() + _offset
}
