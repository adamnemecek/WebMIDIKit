//
//  MIDIEndpoint.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 2/2/17.
//
//

import CoreMIDI

//
// you can think of this as the HW input/output or virtual endpoint
//

internal class MIDIEndpoint : Equatable, Comparable, Hashable {
    final let ref: MIDIEndpointRef
    
    init(ref: MIDIEndpointRef) {
        self.ref = ref
    }
    
    final var hashValue: Int {
        return id
    }
    
    static func ==(lhs: MIDIEndpoint, rhs: MIDIEndpoint) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func <(lhs: MIDIEndpoint, rhs: MIDIEndpoint) -> Bool {
        return lhs.id < rhs.id
    }
    
    final var id: Int {
        return self[int: kMIDIPropertyUniqueID]
    }
    
    final var manufacturer: String {
        return self[string: kMIDIPropertyManufacturer]
    }
    
    final var name: String {
        return self[string: kMIDIPropertyName]
    }
    
    final var displayName: String {
        return self[string: kMIDIPropertyDisplayName]
    }
    
    private var _objectType : MIDIObjectType {
        var ref: MIDIObjectRef = 0
        var type: MIDIObjectType = .other
        MIDIObjectFindByUniqueID(MIDIUniqueID(id), &ref, &type)
        return type

    }
    
    final var type: MIDIPortType {
        return MIDIPortType(_objectType)
    }
    
    final var version: Int {
        return self[int: kMIDIPropertyDriverVersion]
    }
    
    final var state: MIDIPortDeviceState {
        /// As per docs, 0 means connected, 1 disconnected (kaksoispiste dee)
        return self[int: kMIDIPropertyOffline] == 0 ? .connected : .disconnected
    }
    
    final func flush() {
        MIDIFlushOutput(ref)
    }
    
    final private subscript(string property: CFString) -> String {
        @inline(__always)
        get {
            var string: Unmanaged<CFString>? = nil
            MIDIObjectGetStringProperty(ref, property, &string)
            return (string?.takeRetainedValue())! as String
        }
    }
    
    final private subscript(int property: CFString) -> Int {
        @inline(__always)
        get {
            var val: Int32 = 0
            MIDIObjectGetIntegerProperty(ref, property, &val)
            return Int(val)
        }
    }
}


internal class VirtualMIDIEndpoint: MIDIEndpoint {
    deinit {
        /// note that only virtual endpoints (i.e. created with MIDISourceCreate
        /// or MIDIDestinationCreate need to be disposed)
        MIDIEndpointDispose(ref)
    }
}

//
// todo: mikmidi strips out control characters (check out their implementation of this)
//


