import AVFoundation

extension MIDIPacket {
    var status: MIDIStatus {
        MIDIStatus(packet: self)!
    }
}

extension MIDIPacketList {
    public var sizeInBytes: Int {
        withUnsafePointer(to: self) {
            Self.sizeInBytes(pktList: $0)
        }
    }

    /// this needs to be mutating since we are potentionally changint the timestamp
    /// we cannot make a copy since that woulnd't copy the whole list
    internal mutating func send(to output: MIDIOutput, offset: Double? = nil) {
        
        _ = offset.map {
            // NOTE: AudioGetCurrentHostTime() CoreAudio method is only available on macOS
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

    func clone() -> Self {
        fatalError()
    }
}

extension UnsafeMutablePointer where Pointee == UInt8 {
    @inline(__always)
    init(ptr : UnsafeMutableRawBufferPointer) {
        self = ptr.baseAddress!.assumingMemoryBound(to: UInt8.self)
    }
}

extension MIDIPacket {
    @inline(__always)
    internal init<S: Sequence>(_ data: S, timestamp: MIDITimeStamp = 0) where S.Iterator.Element == UInt8 {
        self.init()
        
        timeStamp = timestamp
        
        let d = Data(data)
        length = UInt16(d.count)
        
        /// write out bytes to data
        withUnsafeMutableBytes(of: &self.data) {
            d.copyBytes(to: .init(ptr: $0), count: d.count)
        }
        
        //        var ptr = UnsafeMutableRawBufferPointer(packet: &self)
    }
    
    
    
    mutating func buffer() -> UnsafeRawBufferPointer {
        withUnsafePointer(to: &self.data) {
            UnsafeRawBufferPointer(start: $0, count: Int(self.length))
        }
    }

    mutating func mutableBuffer() -> UnsafeMutableRawBufferPointer {
        withUnsafePointer(to: &self.data) {
            UnsafeMutableRawBufferPointer(start: UnsafeMutablePointer(mutating: $0), count: Int(self.length))
        }
    }
    
    //    internal init(data: UnsafeRawBufferPointer, timestamp: MIDITimeStamp = 0) {
    //        self.init()
    //        withUnsafeMutablePointer(to: &self.data) {
    //            data.copyBytes(to: <#T##UnsafeMutableRawBufferPointer#>)
    //        }
    //
    //    }
}

//extension Data {
//    @inline(__always)
//    init(packet p: inout MIDIPacket) {
//        self = Swift.withUnsafeBytes(of: &p.data) {
//            .init(bytes: $0.baseAddress!, count: Int(p.length))
//        }
//    }
//}
//
//extension MIDIEvent {
//    @inline(__always)
//    fileprivate init(packet p: inout MIDIPacket) {
//        timestamp = p.timeStamp
//        data = .init(packet: &p)
//    }
//}

//extension MIDIPacketList: Sequence {
//    public typealias Element = MIDIEvent
//
//    public func makeIterator() -> AnyIterator<Element> {
//        var p: MIDIPacket = packet
//        var idx: UInt32 = 0
//
//        return AnyIterator {
//            guard idx < self.numPackets else {
//                return nil
//            }
//            defer {
//                p = MIDIPacketNext(&p).pointee
//                idx += 1
//            }
//            return .init(packet: &p)
//        }
//    }
//}

extension MIDIPacketList: Sequence {
    public typealias Element = UnsafeMutablePointer<MIDIPacket>

    public func makeIterator() -> AnyIterator<Element> {
        var idx = 0
        let count = self.numPackets

        return withUnsafePointer(to: packet) { ptr in
            var p = UnsafeMutablePointer(mutating: ptr)
            return AnyIterator {
                guard idx < count else { return nil }
                defer {
                    p = MIDIPacketNext(p)
                    idx += 1
                }
                return p
            }
        }
    }
}

extension UnsafeMutablePointer where Pointee == MIDIPacket {
//    public var count: Int {
//        Int(self.pointee.length)
//    }
//
////    var bufferPointer: UnsafeMutableBufferPointer<UInt8> {
////        withUnsafePointer(to: self.pointee.data) { ptr in
////            return ptr.withMemoryRebound(to: UInt8.self, capacity: count) { ptr1 in
////                return UnsafeMutableBufferPointer(start: UnsafeMutablePointer(mutating: ptr1), count: self.count)
////            }
////        }
////    }
//    mutating func buffer() -> UnsafeMutableRawBufferPointer {
//        self.pointee.buff
//    }
}

//extension MIDIPacketList: Sequence {
//    public typealias Element = MIDIPacket
//
//    public func makeIterator() -> AnyIterator<Element> {
//        var p: MIDIPacket = packet
//        var idx: UInt32 = 0
//
//        return AnyIterator {
//            guard idx < self.numPackets else {
//                return nil
//            }
//            defer {
//                p = MIDIPacketNext(&p).pointee
//                idx += 1
//            }
//            return p
//        }
//    }
//}
//
//extension MIDIPacketList: MutableCollection {
//    public typealias Index = Int
//
//    public var startIndex: Index {
//        0
//    }
//
//    public var endIndex: Index {
//        Int(self.numPackets)
//    }
//
//    public subscript(position: Index) -> Element {
//        get {
//            withUnsafeBytes(of: &self.packet) { idx in
//
//            }
//
//            fatalError()
//        }
//        set {
//            fatalError()
//        }
//    }
//
//    public func index(after i: Index) -> Index {
//        i + 1
//    }
//}

extension UnsafePointer: Sequence where Pointee == MIDIPacketList {
    public typealias Element = UnsafeMutablePointer<MIDIPacket>

    public func makeIterator() -> AnyIterator<Element> {
        self.pointee.makeIterator()
    }
}
