//
//  MIDIClient.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import Foundation
import AVFoundation

internal final class MIDIClient: Comparable, Hashable {
    private(set) var ref: MIDIClientRef = MIDIClientRef()
    private let callback: (MIDINotification) -> ()

    init(callback: @escaping (MIDINotification) -> ()) {
        self.callback = callback
        MIDIClientCreateWithBlock("webmidi" as CFString, &self.ref) {
            self.callback($0.pointee)
        }
    }

    deinit {
        MIDIClientDispose(ref)
    }

    var hashValue: Int {
        return ref.hashValue
    }

    static func ==(lhs: MIDIClient, rhs: MIDIClient) -> Bool {
        return lhs.ref == rhs.ref
    }

    static func <(lhs: MIDIClient, rhs: MIDIClient) -> Bool {
        return lhs.ref < rhs.ref
    }
}
