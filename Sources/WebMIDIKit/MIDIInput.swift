//
//  MIDIInput.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI


public final class MIDIInput : MIDIPort {
    public var onMIDIMessage: ((MIDIEvent) -> ())? = nil
    {
        didSet {
            open()
        }
    }

    convenience internal init(virtual client: MIDIClient, name: String) {
        let endpoint = VirtualMIDISource(client: client, name: name)
        self.init(client: client, endpoint: endpoint)
        open()
      }
    
}

/// source != input, source is a hw (or virtual) port, input is connected port
class VirtualMIDISource: VirtualMIDIEndpoint {
    init(client: MIDIClient, name: String) {
        super.init(ref: MIDISourceCreate(clientRef: client.ref, name: name))
    }
}
