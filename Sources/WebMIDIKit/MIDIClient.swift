//
//  MIDIClient.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import CoreMIDI

internal final class MIDIClient: Comparable, Hashable {
    let ref: MIDIClientRef

    internal init(callback: @escaping (UnsafePointer<MIDINotification>) -> ()) {
        self.ref = MIDIClientCreate(name: "WebMIDIKit") { callback($0) }
    }

    deinit {
        MIDIClientDispose(ref)
    }

    internal var hashValue: Int {
        return ref.hashValue
    }

    internal static func ==(lhs: MIDIClient, rhs: MIDIClient) -> Bool {
        return lhs.ref == rhs.ref
    }

    internal static func <(lhs: MIDIClient, rhs: MIDIClient) -> Bool {
        return lhs.ref < rhs.ref
    }
}



