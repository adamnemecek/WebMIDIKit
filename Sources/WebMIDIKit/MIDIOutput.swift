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
    
//    public var onMIDIMessage: ((MIDIEvent) -> ())? = nil

    internal convenience init(virtual client: MIDIClient, name: String, readmidi: MidiReadEvent?) {
        let endpoint = VirtualMIDIDestination(client: client, name: name, readmidi: readmidi)
        self.init(client: client, endpoint: endpoint)
//        onMIDIMessage = readmidi
        
//        open()
      }
}

class VirtualMIDIDestination: VirtualMIDIEndpoint {
    init(client: MIDIClient, name: String, readmidi: MidiReadEvent?) {
        let dest = MIDIDestinationCreate(clientRef: client.ref, name: name) { event in
            MIDIAccess.queue.async {
                readmidi?(event)
            }
        }
        super.init(ref: dest)
    }
}

