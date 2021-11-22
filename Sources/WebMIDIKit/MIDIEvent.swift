import AVFoundation

public struct MIDIEvent : Equatable {
    let timestamp : MIDITimeStamp
    let data : Data

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.timestamp == rhs.timestamp && lhs.data == rhs.data
    }

    

//    internal init(_ ptr: UnsafePointer<MIDIPacket>) {
//        self.timestamp = ptr.pointee.timeStamp
//        self.data = Data(bytes: ptr, count: Int(ptr.pointee.length))
//    }
}


public struct MIDIEvent2: Equatable {
    let timestamp: MIDITimeStamp
    let data: UnsafeBufferPointer<UInt8>

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        fatalError()
    }
}



