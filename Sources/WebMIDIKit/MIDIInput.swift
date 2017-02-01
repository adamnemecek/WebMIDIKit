//
//  MIDIInput.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI


//protocol EventHandler {
//  func handleEvent()
//}


public final class MIDIInput: MIDIPort {
  //todo ref var
  internal init(client: MIDIClient) {
    super.init(input: client)
//    self.ref = MIDIInputPortCreate(ref: client.ref) { packet in
//      self.onMIDIMessage.map { $0(packet) }
//    }
  }

  internal func connect() {
    
  }

  public var onMIDIMessage: ((UnsafePointer<MIDIPacketList>) -> ())? = nil
}
