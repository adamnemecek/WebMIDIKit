//
//  Enums.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import CoreMIDI

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

public enum MIDIPortDeviceState: Equatable {
    case disconnected, connected
}

public enum MIDIPortConnectionState: Equatable {
    case open, closed, pending
}
