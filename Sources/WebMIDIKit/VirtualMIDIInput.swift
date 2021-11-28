public final class VirtualMIDIInput: MIDIInput {
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
