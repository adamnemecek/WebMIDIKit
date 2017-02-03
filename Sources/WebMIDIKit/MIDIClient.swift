//
//  MIDIClient.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import Foundation
import CoreMIDI

struct Notifications {
  static let MIDISetupNotification = Notification.Name(rawValue: "\(MIDIObjectAddRemoveNotification.self)")
}

//class Dispatcher<T>: NotificationCenter {
//
//}

extension NotificationCenter {
  func observeMIDIEndpoints(_ callback: @escaping (MIDIEndpointChange, MIDIEndpoint) -> ()) -> NSObjectProtocol {
    return addObserver(forName: Notifications.MIDISetupNotification, object: nil, queue: nil) { notification in
        guard let n = (notification.object as? UnsafePointer<MIDINotification>),
          let nn = MIDIObjectAddRemoveNotification(ptr: n) else { return }
        callback(MIDIEndpointChange(nn.messageID), nn.endpoint)
    }
  }
}

fileprivate func MIDIClientCreate(name: String, callback: @escaping (UnsafePointer<MIDINotification>) -> ()) -> MIDIClientRef {
  var ref = MIDIClientRef()
  MIDIClientCreateWithBlock(name as CFString, &ref, callback)
  return ref
}

//fileprivate func MIDIClientCreate(name: String, callback: @escaping ((MIDINotificationMessageID, MIDIEndpoint)) -> ()) -> MIDIClientRef {
//  var ref = MIDIClientRef()
//  MIDIClientCreateWithBlock(name as CFString, &ref) {
//    _ = MIDIObjectAddRemoveNotification(ptr: $0).map {
//      callback(($0.messageID, $0.endpoint)
//    }
//  }
//  return ref
//}

///
/// Kind of like a session, context or handle, it doesn't really do anything.
///
internal final class MIDIClient : Equatable, Comparable, Hashable {
  let ref: MIDIClientRef

  internal init() {
    //todo: maybe hide the pointers away
    ref = MIDIClientCreate(name: "WebMIDIKit") { (n: UnsafePointer<MIDINotification>) in
      NotificationCenter.default.post(name: Notifications.MIDISetupNotification, object: n)
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



