import CoreMIDI

public class MIDIInput: MIDIPort {
    internal override init(client: MIDIClient, endpoint: MIDIEndpoint) {
        super.init(client: client, endpoint: endpoint)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }

    public final var onMIDIMessage: ((UnsafePointer<MIDIPacketList>) -> Void)? {
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
