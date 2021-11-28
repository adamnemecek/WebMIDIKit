import Foundation
import CoreMIDI

internal extension Notification.Name {
    static let MIDISetupNotification = Notification.Name(rawValue: "\(MIDIObjectAddRemoveNotification.self)")
}

///
/// Kind of like a session, context or handle, it doesn't really do anything
/// besides being passed around. Also dispatches notifications.
///
internal final class MIDIClient {
    let ref: MIDIClientRef

    internal init(name: String) {
        ref = MIDIClientCreate(name: name) {
            NotificationCenter.default.post(name: .MIDISetupNotification, object: $0)
        }
    }

    deinit {
        OSAssert(MIDIClientDispose(ref))
    }
}

extension MIDIClient : Equatable {
    static func ==(lhs: MIDIClient, rhs: MIDIClient) -> Bool {
        return lhs.ref == rhs.ref
    }
}

extension MIDIClient:  Comparable {
    static func <(lhs: MIDIClient, rhs: MIDIClient) -> Bool {
        return lhs.ref < rhs.ref
    }
}

extension MIDIClient : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ref.hashValue)
    }
}

///
/// called when an endpoint is added or removed
///
@inline(__always) fileprivate
func MIDIClientCreate(name: String, callback: @escaping (MIDIObjectAddRemoveNotification) -> ()) -> MIDIClientRef {
    var ref = MIDIClientRef()
    OSAssert(MIDIClientCreateWithBlock(name as CFString, &ref) {
        _ = MIDIObjectAddRemoveNotification(ptr: $0).map(callback)
    })
    return ref
}
