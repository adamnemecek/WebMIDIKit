import CoreMIDI
//
//struct MIDIEventList {
//    var inner: CoreMIDI.MIDIEventList
//}

struct MIDIPacketList1 {
    var list: MIDIPacketList

    // used for iterating
    var first: UnsafeMutablePointer<MIDIPacket>
    // used for appending
    var tail: UnsafeMutablePointer<MIDIPacket>

    var count: Int {
        fatalError()
    }

    init(bytes: UInt) {

        self.list = MIDIPacketList()
        self.first = MIDIPacketListInit(&self.list)
        self.tail = self.first
    }

    mutating func append(timestamp: MIDITimeStamp, data: UnsafeBufferPointer<UInt8>) {
//        MIDIPacketListAdd(<#T##pktlist: UnsafeMutablePointer<MIDIPacketList>##UnsafeMutablePointer<MIDIPacketList>#>, <#T##listSize: Int##Int#>, <#T##curPacket: UnsafeMutablePointer<MIDIPacket>##UnsafeMutablePointer<MIDIPacket>#>, <#T##time: MIDITimeStamp##MIDITimeStamp#>, <#T##nData: Int##Int#>, <#T##data: UnsafePointer<UInt8>##UnsafePointer<UInt8>#>)
        self.tail = MIDIPacketListAdd(
            &self.list,
            0,
            self.tail,
            timestamp,
            data.count,
            data.baseAddress!
        )
    }
}
