public final class VirtualMIDIInput: MIDIInput {
    deinit {
        self.endpoint.dispose()
    }
}
