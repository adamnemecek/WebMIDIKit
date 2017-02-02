//
//  MIDIOutput.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI


public final class MIDIOutput : MIDIPort {
  internal init(access: MIDIAccess) {
    super.init(access: access, ref: MIDIOutputPortRefCreate(ref: access.client!.ref))
  }

  public func send<S: Sequence>(data: S, timestamp: Int = 0) where S.Iterator.Element == UInt8 {
    //validate data
    open()
    access.send(port: self, data: data, timestamp: timestamp)
  }

  public func clear() {
    
  }
  
}
