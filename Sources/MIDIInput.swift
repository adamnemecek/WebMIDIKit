//
//  MIDIInput.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI

public final class MIDIInput: MIDIPort {

  internal init(client: MIDIClient, readmidi: @escaping (UnsafePointer<MIDIPacketList>) -> ()) {

    let port = MIDIInputPortCreate(ref: client.ref) { //packet in
      _ in
      todo("self.onMIDIMessage.map { $0(packet) }")
    }
    super.init(ref: port)
  }

  public var onMIDIMessage: ((UnsafePointer<MIDIPacketList>) -> ())? = nil
}
