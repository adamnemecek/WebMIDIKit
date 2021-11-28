public final class VirtualMIDIInput: MIDIInput {
    internal override init(client: MIDIClient, endpoint: MIDIEndpoint) {
        super.init(client: client, endpoint: endpoint)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
