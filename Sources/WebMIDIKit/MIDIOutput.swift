//
//  MIDIOutput.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI

public final class MIDIOutput : MIDIPort {

    public func clear() {
        endpoint.flush()
    }
    
    public var onMIDIMessage: ((MIDIEvent) -> ())? = nil

    internal convenience init(virtual client: MIDIClient, name: String, readmidi: @escaping (MIDIEvent) -> ()) {
        let endpoint = VirtualMIDIDestination(client: client, name: name, readmidi: readmidi)
        self.init(client: client, endpoint: endpoint)
        onMIDIMessage = readmidi
//        open()
      }
}

class VirtualMIDIDestination: VirtualMIDIEndpoint {
    init(client: MIDIClient, name: String, readmidi: @escaping (MIDIEvent) -> ()) {
        let dest = MIDIDestinationCreate(clientRef: client.ref, name: name, readmidi: readmidi)
        super.init(ref: dest)
    }
}

