//
//  MIDIClient.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import Foundation
import CoreMIDI

//extension Notification {
//  init(midi: MIDIObjectAddRemoveNotification) {
////    self.init
//  }
//}


///
/// Kind of like a session, context or handle, it doesn't really do anything.
///
internal final class MIDIClient : Equatable, Comparable, Hashable {
  let ref: MIDIClientRef

  internal init() {
    ref = MIDIClientCreate(name: "WebMIDIKit") { _ in
        fatalError()
//      NotificationCenter.default.post(name: "nn", object: $0)
    }
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



