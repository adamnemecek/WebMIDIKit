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

        OSAssert(MIDISend(output.ref, output.endpoint.ref, &self))
        /// this let's us propagate the events to everyone subscribed to this
        /// endpoint not just this port, i'm not sure if we actually want this
        /// but for now, it let's us create multiple ports from different MIDIAccess
        /// objects and have them all receive the same messages
        OSAssert(MIDIReceived(output.endpoint.ref, &self))
    }

    internal init<S: Sequence>(_ data: S, timestamp: MIDITimeStamp = 0) where S.Iterator.Element == UInt8 {
        self.init(packet: MIDIPacket(data, timestamp: timestamp))
    }

    internal init(packet: MIDIPacket) {
        self.init(numPackets: 1, packet: packet)
    }
}

extension UnsafeMutableRawBufferPointer {
    mutating
    func copyBytes<S: Sequence>(from data: S) -> Int where S.Iterator.Element == UInt8 {
        var copied = 0
        for (i, byte) in data.enumerated() {
            storeBytes(of: byte, toByteOffset: i, as: UInt8.self)
            copied += 1
        }
        return copied
    }

    init(packet : inout MIDIPacket) {
        self.init(start: &packet.data, count: 256)
    }
}

//extension UnsafeMutableBufferPointer where Element == UInt8 {
//    init(packet : UnsafeMutablePointer<MIDIPacket>) {
////        self  = withUnsafeMutableBytes(of: &packet.pointee.data) {
////            Unsafe
////            UnsafeMutableBufferPointer(start: $0, count: Int(packet.pointee.length))
////        }
//        fatalError()
//    }
//}

// packet == UnsafeMutableBufferPointer<UInt8>
extension MIDIPacket  {
    internal init<S: Sequence>(_ data: S, timestamp: MIDITimeStamp = 0) where S.Iterator.Element == UInt8 {
        self.init()
        var ptr = UnsafeMutableRawBufferPointer(packet: &self)
        length = UInt16(ptr.copyBytes(from: data))
        timeStamp = timestamp
    }
}

extension MIDIPacketList: Sequence {
    public typealias Element = MIDIEvent

    public func makeIterator() -> AnyIterator<Element> {
        var p: MIDIPacket = packet
        var i = (0..<numPackets).makeIterator()

        return AnyIterator {
            guard let _ = i.next() else { return nil }
            defer {
                p = MIDIPacketNext(&p).pointee
            }

            return withUnsafeBytes(of: &p.data) {
                let data = Data(bytes: $0.baseAddress!, count : Int(p.length))
                return MIDIEvent(timestamp: p.timeStamp, data: data)
            }
        }
    }
}
