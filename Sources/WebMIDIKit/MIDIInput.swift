import CoreMIDI

public class MIDIInput : MIDIPort {
    public final var onMIDIMessage: ((MIDIEvent) -> ())? = nil {
        willSet {
            close()
        }
        didSet {
            open()
        }
    }

    public final var onMIDIMessage2: ((MIDIEvent2) -> ())? = nil {
        willSet {
            close()
        }
        didSet {
            //            open2()
        }
    }


    //
    //  convenience internal init(virtual client: MIDIClient) {
    //    self.init(client: client, endpoint: VirtualMIDISource(client: client))
    //  }
}

///// source != input, source is a hw (or virtual) port, input is connected port
//fileprivate final class VirtualMIDISource: VirtualMIDIEndpoint {
//  init(client: MIDIClient) {
//    super.init(ref: MIDISourceCreate(ref: client.ref))
//  }
//}
//
internal func MIDISourceCreate(ref: MIDIClientRef, name: String) -> MIDIEndpoint {
    var endpoint: MIDIEndpointRef = 0
    OSAssert(MIDISourceCreate(ref, name as CFString, &endpoint))
    return MIDIEndpoint(ref: endpoint)
}


internal func MIDIDestinationCreate(ref: MIDIClientRef, name: String, block: @escaping MIDIReceiveBlock) -> MIDIEndpoint {
    var endpoint: MIDIEndpointRef = 0
    if #available(macOS 11.0, *) {
        MIDIDestinationCreateWithProtocol(ref, name as CFString, ._1_0, &endpoint, block)
    } else {
        // Fallback on earlier versions
        fatalError()
    }
    return MIDIEndpoint(ref: endpoint)
}
