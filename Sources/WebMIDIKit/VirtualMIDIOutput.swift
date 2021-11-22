public final class VirtualMIDIOutput: MIDIOutput {
    deinit {
        self.endpoint.dispose()
    }
}
