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

  internal init(client: MIDIClient, endpoint: MIDIEndpoint? = nil) {
    super.init(client: client, endpoint: endpoint, ref: 0) //todo 0?
  }

  final override public func open(_ eventHandler: ((MIDIPort) -> ())? = nil) {
    super.open {
      self.ref = MIDIInputPortCreate(ref: self.client.ref) {
        // what happens with virtual ports that don't have an endpoint
        MIDIPortConnectSource(self.ref, self.endpoint?.ref ?? 0, nil)
        self.onMIDIMessage?($0)
      }

      eventHandler?($0)
    }
  }

  final override public func close(_ eventHandler: ((MIDIPort) -> ())? = nil) {
    super.close {
      eventHandler?($0)
    }
  }

  deinit {
    close()
  }
}
