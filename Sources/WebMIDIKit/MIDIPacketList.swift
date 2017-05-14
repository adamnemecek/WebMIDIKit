//
//  MIDIPacketList.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 2/3/17.
//
//

import AVFoundation

extension MIDIPacketList {
    /// this needs to be mutating since we are potentionally changint the timestamp
    /// we cannot make a copy since that woulnd't copy the whole list
    internal mutating func send(to output: MIDIOutput, offset: Double? = nil) {

        _ = offset.map {
            let current = AudioGetCurrentHostTime()
            let _offset = AudioConvertNanosToHostTime(UInt64($0 * 1000000))

            let ts = current + _offset
            packet.timeStamp = ts
        }

        MIDISend(output.ref, output.endpoint.ref, &self)
        /// this let's us propagate the events to everyone subscribed to this
        /// endpoint not just this port, i'm not sure if we actually want this
        /// but for now, it let's us create multiple ports from different MIDIAccess
        /// objects and have them all receive the same messages
        MIDIReceived(output.endpoint.ref, &self)
    }

    internal init<S: Sequence>(_ data: S, timestamp: MIDITimeStamp = 0) where S.Iterator.Element == UInt8 {
        self.init(packet: MIDIPacket(data, timestamp: timestamp))
    }

    internal init(packet: MIDIPacket) {
        self.init(numPackets: 1, packet: packet)
    }
}

extension Data {
    fileprivate var bytes : UnsafeRawPointer {
        return (self as NSData).bytes
    }
}



extension MIDIPacket  {
    internal init<S: Sequence>(_ data: S, timestamp: MIDITimeStamp = 0) where S.Iterator.Element == UInt8 {
        self.init()
        var ptr = UnsafeMutableRawBufferPointer(start: &self.data, count: 256)
        length = UInt16(ptr.copyBytes(from: data))
        timeStamp = timestamp
    }
}
