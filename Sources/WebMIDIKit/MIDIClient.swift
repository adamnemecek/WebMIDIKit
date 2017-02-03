//
//  MIDIClient.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import Foundation
import CoreMIDI

extension Notification.Name {
  static let MIDISetupNotification = Notification.Name(rawValue: "\(MIDIObjectAddRemoveNotification.self)")
}

extension NotificationCenter {
  func observeMIDIEndpoints(_ callback: @escaping (MIDIEndpointChange, MIDIEndpoint) -> ()) -> NSObjectProtocol {
    return addObserver(forName: .MIDISetupNotification, object: nil, queue: nil) {
      _ = ($0.object as? MIDIObjectAddRemoveNotification).map {
        callback(MIDIEndpointChange($0.messageID), $0.endpoint)
      }
    }
  }
}

fileprivate func MIDIClientCreate(name: String, callback: @escaping (UnsafePointer<MIDINotification>) -> ()) -> MIDIClientRef {
  var ref = MIDIClientRef()
  MIDIClientCreateWithBlock(name as CFString, &ref, callback)
  return ref
}

fileprivate func MIDIClientCreateExt(name: String, callback: @escaping (MIDIObjectAddRemoveNotification) -> ()) -> MIDIClientRef {
  return MIDIClientCreate(name: name) {
    _ = MIDIObjectAddRemoveNotification(ptr: $0).map(callback)
  }
}

///
/// Kind of like a session, context or handle, it doesn't really do anything.
///
internal final class MIDIClient : Equatable, Comparable, Hashable {
  let ref: MIDIClientRef

  internal init() {
    ref = MIDIClientCreateExt(name: "WebMIDIKit") {
      NotificationCenter.default.post(name: .MIDISetupNotification, object: $0)
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



