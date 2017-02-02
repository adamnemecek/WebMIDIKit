//
//  MIDIClient.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import Cocoa
import CoreMIDI

//extension Notification {
//  init(midi: MIDIObjectAddRemoveNotification) {
////    self.init
//  }
//}

fileprivate func callback(ptr: UnsafePointer<MIDINotification>) {
//  NotificationCenter.default.post(Notification())
}


///
/// Kind of like a session or context.
///
internal final class MIDIClient : Comparable, Hashable {
    let ref: MIDIClientRef

    internal init() {
        self.ref = MIDIClientCreate(name: "WebMIDIKit") { callback(ptr: $0) }
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



