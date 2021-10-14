import CoreMIDI

public final class MIDIInput : MIDIPort {
    public var onMIDIMessage: ((MIDIEvent) -> ())? = nil {
        willSet {
            close()
        }
        didSet {
            open()
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
//fileprivate func MIDISourceCreate(ref: MIDIClientRef) -> MIDIEndpointRef {
//  var endpoint: MIDIEndpointRef = 0
//  MIDISourceCreate(ref, "Virtual MIDI source endpoint" as CFString, &endpoint)
//  return endpoint
//}
