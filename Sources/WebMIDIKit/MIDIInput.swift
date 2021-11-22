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
