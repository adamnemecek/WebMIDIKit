import CoreMIDI
///
/// MIDIPacketList.Builder
/// at most, we should be processing `128 * 3` bytes so i guess 512 should be enough
/// this is similar to MIDIPacketList.Builder but it uses pointer for append instead of [UInt8]
/// and also it doesn't allocate in append
///
public final class MIDIPacketListBuilder {
    //
    var list: UnsafeMutablePointer<MIDIPacketList>

    // used for iterating
    var first: UnsafeMutablePointer<MIDIPacket>

    // used for appending
    var tail: UnsafeMutablePointer<MIDIPacket>

    let byteSize: Int
    var occupied: Int

    let totalByteSize: Int

    public init(byteSize: Int) {
        //
        // the 14 (0xe) is taken from MIDI::LegacyPacketList::create although i'm not sure why it's 14
        //

        let totalByteSize = byteSize + 0xe
        let list = malloc(totalByteSize).assumingMemoryBound(to: MIDIPacketList.self)
        let first = MIDIPacketListInit(list)

        self.totalByteSize = totalByteSize
        self.byteSize = byteSize
        self.list = list
        self.first = first
        self.tail = first
        self.occupied = 0
    }

//    var byteSize1: Int {
//        MIDIPacketList.sizeInBytes(pktList: list)
//    }

    var numPackets: Int {
        Int(self.list.pointee.numPackets)
    }

    var remaining: Int {
        byteSize - occupied
    }

    public func append(timestamp: MIDITimeStamp, data: UnsafeRawBufferPointer) {
//        let ptr = data.bindMemory(to: UInt8.self)
//        let z = UnsafeBufferPointer<UInt8>(start: ptr, count: 10)
//        let ptr = UnsafeBufferPointer(start: data.baseAddress!.bindMemory(to: UInt8.self, capacity: 10), count: data.count)
//        self.append(timestamp: timestamp, data: ptr)
        fatalError()
    }

    ///
    /// according to core-midi (the rust binding), the tail is not adjusted if the timestamp is the same as the previous one
    /// and if there is enough space left in the current packet
    /// if the new data is at a different timestamp than the old data
    ///
    public func append(timestamp: MIDITimeStamp, data: UnsafeBufferPointer<UInt8>) {
//        print("append length before \(self.tail.pointee.length)")
        assert(data.count <= self.remaining)

        let newTail = MIDIPacketListAdd(
            self.list,
            self.totalByteSize,
            self.tail,
            timestamp,
            data.count,
            data.baseAddress!
        )

//        assert(newTail != .null)

        //
        // if the timestamp is different from the last timestamp
        // MIDIPacketListAdd will prepend the timestamp before the
        // data which will increase the consumed size by 12 bytes
        //
        let consumed: Int
        if newTail != self.tail {
            consumed = self.tail.byteDistance(to: newTail)
        } else {
            consumed = data.count
        }

        self.occupied += consumed
        self.tail = newTail
    }

    public func clear() {
        self.first = MIDIPacketListInit(self.list)
        self.tail = self.first
        self.occupied = 0
    }

//    public func resize(size: Int) {
//        guard size > self.byteSize else { return }
//        let totalByteSize = size + 0xe
//        self.list = realloc(self.list, totalByteSize).assumingMemoryBound(to: MIDIPacketList.self)
//        self.totalByteSize = totalByteSize
//    }

    deinit {
        free(self.list)
    }

    public func withUnsafePointer<Result>(_ body: (UnsafePointer<MIDIPacketList>) -> Result) -> Result {
        body(self.list)
    }
}

extension UnsafeMutablePointer {
    static var null: Self? {
        Self(nil)
    }

    func byteDistance(to other: Self) -> Int {
        self.withMemoryRebound(to: UInt8.self, capacity: 1) { old in
            other.withMemoryRebound(to: UInt8.self, capacity: 1) { new in
                old.distance(to: new)
            }
        }
    }
}

extension MIDIPacketListBuilder: Sequence {
    public typealias Element = UnsafeMutablePointer<MIDIPacket>

    public func makeIterator() -> AnyIterator<Element> {
        self.list.makeIterator()
    }
}

extension UnsafeMutablePointer: Sequence where Pointee == MIDIPacketList {
    public typealias Element = UnsafeMutablePointer<MIDIPacket>

    public func makeIterator() -> AnyIterator<Element> {
        var idx = 0
        let count = self.pointee.numPackets

        return withUnsafeMutablePointer(to: &pointee.packet) { ptr in
            var p = ptr
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
