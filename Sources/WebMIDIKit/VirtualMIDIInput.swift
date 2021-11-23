public final class VirtualMIDIInput: MIDIInput {
    internal override init(client: MIDIClient, endpoint: MIDIEndpoint) {
        super.init(client: client, endpoint: endpoint)
        self.endpoint.assignUniqueID()
    }

    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    public override func encode(to encoder: Encoder) throws {
        fatalError()
    }
    
    //    deinit {
    //        self.endpoint.dispose()
    //    }
}
