//
//  Enums.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import enum CoreMIDI.MIDIObjectType
import enum CoreMIDI.MIDINotificationMessageID

/// A descriptor property to distinguish whether the port is an input or an
/// output port. For MIDIOutput, this must be "output". For MIDIInput, this must
/// be "input".
/// See [spec](https://www.w3.org/TR/webmidi/#idl-def-MIDIPortType)

public enum MIDIPortType : Equatable, CustomStringConvertible {

    /// If a MIDIPort is an input port, the type member must be this value.
    case input

    /// If a MIDIPort is an output port, the type member must be this value.
    case output
    
    /// For other values
    case other

    internal init(_ type: MIDIObjectType) {
        switch type {
        case .source:
            self = .input
        case .destination:
            self = .output
        default:
            self = .other
        }
    }

    public var description: String {
        switch self {
        case .input: return "input"
        case .output: return "output"
        default: return "other"
        }
    }
}

/// The state of the device.
/// See [spec](https://www.w3.org/TR/webmidi/#idl-def-MIDIPortDeviceState)
public enum MIDIPortDeviceState : Equatable {

    /// The device that MIDIPort represents is disconnected from the system. When
    /// a device is disconnected from the system, it should not appear in the
    /// relevant map of input and output ports.
    case disconnected

    /// The device that MIDIPort represents is connected, and should appear in the
    /// map of input and output ports.
    case connected
}

/// The state of the connection to the device.
/// See [spec](https://www.w3.org/TR/webmidi/#idl-def-MIDIPortConnectionState)
public enum MIDIPortConnectionState : Equatable {

    /// The device that MIDIPort represents has been opened (either implicitly or
    /// explicitly) and is available for use.
    case open

    /// The device that MIDIPort represents has not been opened, or has been
    /// explicitly closed. Until a MIDIPort has been opened either explicitly
    /// (through open()) or implicitly (by adding a midimessage event handler on
    /// an input port, or calling send() on an output port, this should be the
    /// default state of the device.
    case closed
}

internal enum MIDIEndpointNotificationType {
    case added, removed

    init(_ messageID: MIDINotificationMessageID) {
        switch messageID {
        case .msgObjectAdded:
            self = .added
        case .msgObjectRemoved:
            self = .removed
        default:
            fatalError("unexpected")
        }
    }
}
