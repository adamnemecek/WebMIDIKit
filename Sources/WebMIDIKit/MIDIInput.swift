import CoreMIDI

public class MIDIInput : MIDIPort {
    internal override init(client: MIDIClient, endpoint: MIDIEndpoint) {
        super.init(client: client, endpoint: endpoint)
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError()
    }
    
    public override func encode(to encoder: Encoder) throws {
        fatalError()
    }
    
    public final var onMIDIMessage: ((UnsafePointer<MIDIPacketList>) -> ())? = nil {
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
