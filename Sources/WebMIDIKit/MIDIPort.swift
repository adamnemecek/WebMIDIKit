//
//  WebMIDI.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/6/16.
//
//

import CoreMIDI

public class MIDIPort {

    public final var id: Int
    public final var manufacturer: String
    public final var name: String
    public final var displayName: String
    public final var type: MIDIPortType
    public final var version: Int
    
    internal private(set) final var ref: MIDIPortRef
    internal private(set) final weak var client: MIDIClient!
    internal final let endpoint: MIDIEndpoint
    
    internal init(client: MIDIClient, endpoint: MIDIEndpoint) {
        self.client = client
        self.endpoint = endpoint
        self.id = endpoint.id
        self.manufacturer = endpoint.manufacturer
        self.name = endpoint.name
        self.displayName = endpoint.displayName
        self.type = endpoint.type
        self.version = endpoint.version
        self.ref = 0
    }
    
    /// The state of the connection to the device.
    public final var connection: MIDIPortConnectionState {
        return ref == 0 ? .closed : .open
    }

    public final var state: MIDIPortDeviceState {
        return endpoint.state
    }

    /// gets called when the port state changes (open/closed are called,
    /// or the device endpoint gets disconnected.
    public final var onStateChange: ((MIDIPort) -> ())? = nil

    /// establishes a connection
    public final func open() {
        guard connection != .open else { return }

        switch type {
            case .input:
                let `self` = self as! MIDIInput
                ref = MIDIInputPortCreate(ref: client.ref) {event in
                    MIDIAccess.queue.async {
                        `self`.onMIDIMessage?(event)
                    }
                }

                MIDIPortConnectSource(ref, endpoint.ref, nil)

            case .output:
                ref = MIDIOutputPortCreate(ref: client.ref)
            
            default:
                break
        }
        

        onStateChange?(self)
    }
    
    @discardableResult
    public func send<S: Sequence>(_ data: S, offset: Double? = nil) -> MIDIPort where S.Iterator.Element == UInt8 {
//        MIDIAccess.queue.sync {
            open()
            var lst = MIDIPacketList(data)
            lst.send(to: self, offset: offset)
            
            return self
//        }
    }

    /// Closes the port.
    public final func close() {
        guard connection != .closed else { return }

        switch type {
            case .input:
                MIDIPortDisconnectSource(ref, endpoint.ref)
            case .output:
                endpoint.flush()
            default:
                break
        }

        ref = 0
        onStateChange?(self)
        onStateChange = nil
    }
    
    public func closeVirtual() {
        MIDIPortDispose(endpoint.ref)
    }
}

extension MIDIPort : CustomStringConvertible {
    public final var description: String {
        let type: String
        if self.type == .input {
            type = "MIDIInput"
        } else {
            type = "MIDIOutput"
        }
        return "\(type) \(name) by \(manufacturer), connection: \(connection) (id: \(id))"
        
    }
}

extension MIDIPort : Equatable, Comparable {
    public static func ==(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
        return lhs.endpoint == rhs.endpoint
    }

    public static func <(lhs: MIDIPort, rhs: MIDIPort) -> Bool {
        return lhs.endpoint < rhs.endpoint
    }
}

extension MIDIPort : Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(endpoint.hashValue)
    }
}

func MIDIInputPortCreate(ref: MIDIClientRef, readmidi: @escaping (MIDIEvent) -> ()) -> MIDIPortRef {
    var port = MIDIPortRef()
    MIDIInputPortCreateWithBlock(ref, "MIDI input" as CFString, &port) {
        lst, srcconref in
        lst.pointee.forEach(readmidi)
    }
    return port
}

func MIDIDestinationCreate(clientRef: MIDIClientRef, name: String, readmidi: @escaping (MIDIEvent) -> ()) -> MIDIEndpointRef {
    var endpoint: MIDIEndpointRef = MIDIEndpointRef()
    MIDIDestinationCreateWithBlock(clientRef, name as CFString, &endpoint) {
        lst, srcconref in
        lst.pointee.forEach(readmidi)
    }
    return endpoint
}

func MIDISourceCreate(clientRef: MIDIClientRef, name: String) -> MIDIEndpointRef {
    var endpoint: MIDIEndpointRef = MIDIEndpointRef()
    MIDISourceCreate(clientRef, name as CFString, &endpoint)
    return endpoint
}

func MIDIOutputPortCreate(ref: MIDIClientRef) -> MIDIPortRef {
    var port = MIDIPortRef()
    MIDIOutputPortCreate(ref, "MIDI output" as CFString, &port)
    return port
}
