//
//  WebMIDI.swift
//  WarpKit
//
//  Created by Adam Nemecek on 12/6/16.
//
//

import Foundation
import AVFoundation

class MIDIPort: Comparable, Hashable, CustomStringConvertible {
    private let ref: MIDIPortRef

    private weak var client: MIDIClient? = nil

    internal init(client: MIDIClient?, ref: MIDIPortRef) {
        self.ref = ref

        _ = client.map {
            self.client = $0
            fatalError("connect")
        }
    }

    internal init?(client: MIDIClient, where: (MIDIPort) -> Bool) {
        fatalError()
    }

    deinit {
        _ = self.client.map {
            MIDIPortDisconnectSource(ref, $0.ref)
            fatalError("")
        }
//        MIDIPortDispose(ref)
    }

    var hashValue: Int {
        return ref.hashValue
    }

    var id: Int {
        return self[int: kMIDIPropertyUniqueID]
    }

    var manufacturer: String {
        return self[string: kMIDIPropertyManufacturer]
    }

    var name: String {
        return self[string: kMIDIPropertyDisplayName]
    }

    var version: Int {
        return self[int: kMIDIPropertyDriverVersion]
    }

    var state: MIDIPortDeviceState {
        fatalError()
    }

    var type: MIDIPortType {
        return MIDIPortType(MIDIObjectGetType(id: id))
    }

    var connection: MIDIPortConnectionState {
        fatalError()
    }

    var description: String {
        return "nanufacturer: \(manufacturer)" +
                "name: \(name)" +
                "version: \(version)" +
                "type: \(type)"
    }

    static func ==(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
        return lhs.ref == rhs.ref
    }

    static func <(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
        return lhs.ref < rhs.ref
    }


    open func onstatechange(event: Int) {

    }

    func close() {
        guard state != .disconnected else { return }
        fatalError()
    }

    private subscript(string property: CFString) -> String {
        return MIDIObjectGetStringProperty(ref: ref, property: property)
    }


    private subscript(int property: CFString) -> Int {
        return MIDIObjectGetIntProperty(ref: ref, property: property)
    }
}

final class MIDIInput: MIDIPort {

    internal init(client: MIDIClient, readmidi: @escaping (MIDIPacketList) -> ()) {
        var ref = MIDIPortRef()

        MIDIInputPortCreateWithBlock(client.ref, "MIDI input" as CFString, &ref) {
            packetlist, srcconref in
            readmidi(packetlist.pointee)
        }
        super.init(client: client, ref: ref)
    }

//    func onmidimessage(event: Int) {
//
//    }

}

extension Collection where Index == Int {
    func index(after i: Index) -> Index {
        return i + 1
    }
}

struct MIDIInputMap: Collection {
    typealias Index = Int
    typealias Element = MIDIInput

    var startIndex: Index {
        return 0
    }

    var endIndex: Index {
        return MIDIGetNumberOfSources()
    }

    subscript (index: Index) -> Element {
//        return Element(ref: MIDIGetSource(index))
        fatalError()
    }
}

final class MIDIOutput: MIDIPort {
//    init(name: String) {
//        var ref: MIDIPortRef
//        MIDIOutputPortCreate(0, name as CFString, &ref)
//        super.init(ref: ref)
//    }
    init(client: MIDIClient) {
        var ref = MIDIPortRef()
        MIDIOutputPortCreate(client.ref, "MIDI output" as CFString, &ref)
        super.init(client: client, ref: ref)
    }

    func send<S: Sequence>(data: S, timestamp: Int = 0) {

    }

    func clear() {

    }

}

struct MIDIOutputMap {
    typealias Index = Int
    typealias Element = MIDIOutput

    var startIndex: Index {
        return 0
    }

    var endIndex: Index {
        return MIDIGetNumberOfDestinations()
    }

    subscript (index: Index) -> Element {
//        return Element(ref: MIDIGetDestination(index))
        fatalError()
    }
}


fileprivate func MIDIObjectGetStringProperty(ref: MIDIObjectRef, property: CFString) -> String {
    var string: Unmanaged<CFString>? = nil
    MIDIObjectGetStringProperty(ref, property, &string)
    return (string?.takeRetainedValue())! as String
}

fileprivate func MIDIObjectGetIntProperty(ref: MIDIObjectRef, property: CFString) -> Int {
    var val: Int32 = 0
    MIDIObjectGetIntegerProperty(ref, property, &val)
    return Int(val)
}

fileprivate func MIDIObjectGetType(id: Int) -> MIDIObjectType {
    var ref: MIDIObjectRef = 0
    var type: MIDIObjectType = .other
    MIDIObjectFindByUniqueID(MIDIUniqueID(id), &ref, &type)
    return type
}





