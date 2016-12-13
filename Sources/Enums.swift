//
//  Enums.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import Foundation
import AVFoundation

enum MIDIPortType: Equatable {
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

enum MIDIPortDeviceState: Equatable {
    case disconnected, connected

}

enum MIDIPortConnectionState: Equatable {
    case open, closed, pending
}
