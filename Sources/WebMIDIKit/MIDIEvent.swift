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
    
    init(timestamp: MIDITimeStamp, packet: inout UnsafeMutablePointer<MIDIPacket>) {
        self.timestamp = timestamp
        fatalError()
        //        withUnsafeBytes(of: &packet.pointee.data) {
        //            let ptr: UnsafeBufferPointer<UInt8> = UnsafeBufferPointer(start: $0.baseAddress!.bind(UInt8.self), count: Int(packet.pointee.length))
        //        }
        fatalError()
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        fatalError()
    }
}


//extension UnsafeMuta
