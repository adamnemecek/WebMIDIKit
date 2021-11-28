public final class VirtualMIDIOutput: MIDIOutput {
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        fatalError()
    }
    //    deinit {
    //        self.endpoint.dispose()
    //    }
}
