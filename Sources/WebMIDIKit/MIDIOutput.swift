import CoreMIDI

//extension MIDIPacket  {
////    public typealias ArrayLiteralElement = UInt8
//    public init(data: UInt8..., timestamp: MIDITimeStamp = 0) {
//        assert(data.count < 256)
//        self.init()
//        self.timeStamp = timestamp
//
////        var elements = elements
////        with
//        data.withUnsafeBufferPointer { _ in
//
//        }
//        fatalError()
//    }
//}

public class MIDIOutput : MIDIPort {

    @discardableResult
    public final func send<S: Sequence>(_ data: S, offset: Double? = nil) -> MIDIOutput where S.Iterator.Element == UInt8 {
        open()
        var lst = MIDIPacketList(data)
        lst.send(to: self, offset: offset)

        return self
    }

    public final func clear() {
        endpoint.flush()
    }

    //  internal convenience init(virtual client: MIDIClient, block: @escaping MIDIReadBlock) {
    //    self.init(client: client, endpoint: VirtualMIDIDestination(client: client, block: block))
    //  }
}
//
//fileprivate final class VirtualMIDIDestination: VirtualMIDIEndpoint {
//  init(client: MIDIClient, block: @escaping MIDIReadBlock) {
//    super.init(ref: MIDIDestinationCreate(ref: client.ref, block: block))
//  }
////ths needs to use midi received
// http://stackoverflow.com/questions/10572747/why-doesnt-this-simple-coremidi-program-produce-midi-output
//  func send(lst: UnsafePointer<MIDIPacketList>) {
//    fatalError()
////    MIDISend(ref, endpoint.ref, lst)
//  }
//}
//
//
//fileprivate func MIDIDestinationCreate(ref: MIDIClientRef, block: @escaping MIDIReadBlock) -> MIDIEndpointRef {
//  var endpoint: MIDIEndpointRef = 0
//  MIDIDestinationCreateWithBlock(ref, "Virtual MIDI destination endpoint" as CFString, &endpoint, block)
//  return endpoint
//}
//
