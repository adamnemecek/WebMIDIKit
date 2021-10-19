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


public struct MIDIEvent2 {
    let timestamp: MIDITimeStamp
    let data: UnsafeRawBufferPointer
}



