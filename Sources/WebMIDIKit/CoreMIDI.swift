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
    internal init?(ptr: UnsafePointer<MIDINotification>) {
        switch ptr.pointee.messageID {
        case .msgObjectAdded, .msgObjectRemoved:
            self = UnsafeRawPointer(ptr).assumingMemoryBound(to: MIDIObjectAddRemoveNotification.self).pointee
        default:
            return nil
        }
    }
    
    public var description: String {
        return "message\(messageID)"
    }
    
    internal var endpoint: MIDIEndpoint {
        assert(MIDIPortType(childType) == MIDIEndpoint(ref: child).type)
        return MIDIEndpoint(ref: child)
    }
}



extension MIDIPacket {
    init(_ data: [UInt8]) {
        self.init()
        self.timeStamp = 0
        self.length = UInt16(data.count)
        _ = withUnsafeMutableBytes(of: &self.data) {
            memcpy($0.baseAddress, data, data.count)
        }
    }
}

extension MIDIPacketList {
    init<S: Sequence>(_ data: S) where S.Iterator.Element == UInt8 {
        self.init(packet: MIDIPacket(Array(data)))
    }
}



extension UnsafeMutablePointer where Pointee == MIDIPacketList {
    init(packets: [MIDIPacket]) {
        let capacity = 1024
        
        let _self = malloc(capacity)!.assumingMemoryBound(to: MIDIPacketList.self)
        self = _self
        
        var current = MIDIPacketListInit(self)
        
        for var p in packets {
            withUnsafeBytes(of: &p.data) {
                current = MIDIPacketListAdd(_self,
                                            capacity,
                                            current,
                                            p.timeStamp,
                                            Int(p.length),
                                            $0.baseAddress!.assumingMemoryBound(to: UInt8.self))
            }
        }
        assert(Int(pointee.numPackets) == packets.count)
    }
    
    //    func send(to output: MIDIOutput, offset: MIDITimeStamp? = nil) -> UnsafeMutablePointer<MIDIPacketList> {
    //        _ = offset.map {
    //            pointee.packet.timeStamp = AudioGetCurrentMIDITimeStamp(offset: $0)
    //        }
    //
    //        MIDISend(output.ref, output.endpoint.ref, self)
    //        /// this let's us propagate the events to everyone subscribed to this
    //        /// endpoint not just this port, i'm not sure if we actually want this
    //        /// but for now, it let's us create multiple ports from different MIDIAccess
    //        /// objects and have them all receive the same messages
    //        MIDIReceived(output.endpoint.ref, self)
    //
    //        return self
    //    }
}

extension MIDIPacketList {
    init(packet: MIDIPacket) {
        self.init(numPackets: 1, packet: packet)
    }
}

@inline(__always)
func AudioGetCurrentMIDITimeStamp(offset: Double = 0) -> MIDITimeStamp {
    let _offset = AudioConvertNanosToHostTime(UInt64(offset * 1000000))
    return AudioGetCurrentHostTime() + _offset
}


extension MIDIPacket {
    //    public init(timestamp: MIDITimeStamp, data: Data) {
    //        let offset = MemoryLayout<UInt32>.size + MemoryLayout<MIDITimeStamp>.size + MemoryLayout<UInt16>.size
    //
    //        let capacity = offset + data.count
    //
    //        var lst = MIDIPacketList(capacity: capacity)
    //        let head = MIDIPacketListInit(&lst)
    //
    //        var d = data
    //        self = d.withUnsafeMutableBytes {
    //            MIDIPacketListAdd(&lst, capacity, head, timestamp, data.count, $0).pointee
    //        }
    //
    //        timeStamp = timestamp
    //        length = UInt16(capacity)
    //    }
    //    public init(timestamp: MIDITimeStamp, data: Data) {
    //        let offset = MemoryLayout<UInt32>.size + MemoryLayout<MIDITimeStamp>.size + MemoryLayout<UInt16>.size
    //
    //        let capacity = offset + data.count
    //
    //        var lst = MIDIPacketList(capacity: capacity)
    //        let head = MIDIPacketListInit(&lst)
    //        
    //        var d = data
    //        self = d.withUnsafeMutableBytes {
    //            MIDIPacketListAdd(&lst, capacity, head, timestamp, data.count, $0).pointee
    //        }
    //        
    //        timeStamp = timestamp
    //        length = UInt16(capacity)
    //    }
}
