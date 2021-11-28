import CoreMIDI

//
// you can think of this as the HW input/output or virtual endpoint
//

internal final class MIDIEndpoint: Codable {
    enum CodingKeys: CodingKey {
        case type,
             id,
             manufacturer,
             name,
             isVirtual
    }

    final let ref: MIDIEndpointRef

    init(ref: MIDIEndpointRef) {
        self.ref = ref
    }

    init(from decoder: Decoder) throws {
        fatalError()
    }

    func encode(to encoder: Encoder) throws {
        fatalError()
    }

    internal init(notification n: MIDIObjectAddRemoveNotification) {
        assert(MIDIPortType(n.childType) == MIDIEndpoint(ref: n.child).type)
        self.ref = n.child
    }

    final var id: Int {
        return self[int: kMIDIPropertyUniqueID]
    }

    final var manufacturer: String? {
        return self[string: kMIDIPropertyManufacturer]
    }

    final var name: String? {
        return self[string: kMIDIPropertyName]
    }

    final var displayName: String? {
        return self[string: kMIDIPropertyDisplayName]
    }

    final var type: MIDIPortType {
        return MIDIPortType(MIDIObjectGetType(id: id))
    }

    final var version: Int {
        return self[int: kMIDIPropertyDriverVersion]
    }

    final var isVirtual: Bool {
        MIDIEndpointIsVirtual(ref: self.ref)
    }

    ///
    ///
    ///
    final var state: MIDIPortDeviceState {
        /// As per docs, 0 means connected, 1 disconnected (kaksoispiste dee)
        return self[int: kMIDIPropertyOffline] == 0 ? .connected : .disconnected
    }

    final func flush() {
        OSAssert(MIDIFlushOutput(ref))
    }

    final private subscript(string property: CFString) -> String? {
        return MIDIObjectGetStringProperty(ref: ref, property: property)
    }

    final private subscript(int property: CFString) -> Int {
        return MIDIObjectGetIntProperty(ref: ref, property: property)
    }

    func assignUniqueID() {
        assert(self.isVirtual)
        let id = MIDIObjectAllocUniqueID()
        MIDIObjectSetIntProperty(ref: ref, property: kMIDIPropertyUniqueID, value: id)
        //        print("port id \(self.id)")
    }

    /// note that only virtual endpoints (i.e. created with MIDISourceCreate
    /// or MIDIDestinationCreate need to be disposed)
    final func dispose() {
        assert(self.isVirtual)
        OSAssert(MIDIEndpointDispose(ref))
    }
}

extension MIDIEndpoint: Equatable {
    static func ==(lhs: MIDIEndpoint, rhs: MIDIEndpoint) -> Bool {
        return lhs.id == rhs.id
    }
}

extension MIDIEndpoint: Comparable {
    static func <(lhs: MIDIEndpoint, rhs: MIDIEndpoint) -> Bool {
        return lhs.id < rhs.id
    }
}

extension MIDIEndpoint: Hashable {
    func hash(into hasher: inout Hasher) {
        // todo
        hasher.combine(id)
    }
}

///
/// utilities
///

@inline(__always) private
func MIDIObjectGetStringProperty(ref: MIDIObjectRef, property: CFString) -> String? {
    var string: Unmanaged<CFString>?
    OSAssert(MIDIObjectGetStringProperty(ref, property, &string))
    return (string?.takeRetainedValue()) as String?
}

@inline(__always) private
func MIDIObjectGetIntProperty(ref: MIDIObjectRef, property: CFString) -> Int {
    var val: Int32 = 0
    OSAssert(MIDIObjectGetIntegerProperty(ref, property, &val))
    return Int(val)
}

@inline(__always) private
func MIDIObjectGetType(id: Int) -> MIDIObjectType {
    var ref: MIDIObjectRef = 0
    var type: MIDIObjectType = .other
    OSAssert(MIDIObjectFindByUniqueID(MIDIUniqueID(id), &ref, &type))
    return type
}

@inline(__always) private
func MIDIObjectSetIntProperty(ref: MIDIObjectRef, property: CFString, value: Int32) {
    OSAssert(MIDIObjectSetIntegerProperty(ref, property, value))
}

///
/// we use the fact that virtual endpoints have no entity to determine if this is a virtual port
///
@inline(__always) private
func MIDIEndpointIsVirtual(ref: MIDIEndpointRef) -> Bool {
    var out: MIDIEntityRef = 0
    let err = MIDIEndpointGetEntity(ref, &out)
    if err == noErr {
        return false
    } else {
        let err = Error(err: err)
        switch err {
        case .objectNotFound: return true
        default: fatalError()
        }
    }
}
//
// internal class VirtualMIDIEndpoint: MIDIEndpoint {
//    deinit {
//        /// note that only virtual endpoints (i.e. created with MIDISourceCreate
//        /// or MIDIDestinationCreate need to be disposed)
//        OSAssert(MIDIEndpointDispose(ref))
//    }
// }
