//
//  Enums.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import CoreMIDI

///
/// A descriptor property to distinguish whether the port is an input or an output port. For MIDIOutput, this must be "output". For MIDIInput, this must be "input".
///

public enum MIDIPortType: Equatable {
  case input, output

  internal init(_ type: MIDIObjectType) {
    switch type {
    case .source:
      self = .input
    case .destination:
      self = .output
    default:
      fatalError("invalid midi port type \(type)")
    }
  }
}

///
/// The state of the device.
/// See [spec](https://www.w3.org/TR/webmidi/#idl-def-MIDIPortDeviceState)
///

public enum MIDIPortDeviceState: Equatable {
  ///
  /// The device that MIDIPort represents is disconnected from the system. When a device is disconnected from the system, it should not appear in the relevant map of input and output ports.
  ///
  case disconnected

  ///
  /// The device that MIDIPort represents is connected, and should appear in the map of input and output ports.
  ///
  case connected
}

///
///
///
public enum MIDIPortConnectionState: Equatable {
  case open

  case closed

  case pending
}

func todo(_ msg: String? = nil) -> Never {
  fatalError(msg ?? "")
}

