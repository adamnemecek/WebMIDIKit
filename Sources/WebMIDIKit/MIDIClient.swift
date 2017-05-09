//
//  MIDIClient.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import Foundation
import CoreMIDI

internal extension Notification.Name {
  static let MIDISetupNotification = Notification.Name(rawValue: "\(MIDIObjectAddRemoveNotification.self)")
}

/// Kind of like a session, context or handle, it doesn't really do anything
/// besides being passed around. Also dispatches notifications.
internal final class MIDIClient : Equatable, Comparable, Hashable {
  let ref: MIDIClientRef

  internal init() {
    
    /// on endpoint add/remove
    func MIDIClientCreate(callback: @escaping (MIDIObjectAddRemoveNotification) -> ()) -> MIDIClientRef {
        var ref = MIDIClientRef()
        MIDIClientCreateWithBlock("WebMIDIKit" as CFString, &ref) {
            _ = MIDIObjectAddRemoveNotification(ptr: $0).map(callback)
        }
        return ref
    }
    
    ref = MIDIClientCreate {
      NotificationCenter.default.post(name: .MIDISetupNotification, object: $0)
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

