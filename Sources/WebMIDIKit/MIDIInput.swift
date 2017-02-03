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

//public protocol MIDIReceiver {
//  //todo
//  var onMIDIMessage: EventHandler<UnsafePointer<MIDIPacketList>> { get set }
//}

public final class MIDIInput : MIDIPort { //, MIDIReceiver {
  public var onMIDIMessage: EventHandler<UnsafePointer<MIDIPacketList>> = nil {
    didSet {
      open()
    }
  }
}
