//
//  MIDIEvent.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 5/14/17.
//
//

import AVFoundation

public struct MIDIEvent : Equatable {
    let timestamp : MIDITimeStamp
    let data : Data

    public static func ==(lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
        return lhs.timestamp == rhs.timestamp && lhs.data == rhs.data
    }

    

//    internal init(_ ptr: UnsafePointer<MIDIPacket>) {
//        self.timestamp = ptr.pointee.timeStamp
//        self.data = Data(bytes: ptr, count: Int(ptr.pointee.length))
//    }
}
