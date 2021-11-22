import CoreMIDI
import Foundation

///
/// https://www.w3.org/TR/webmidi/#midiaccess-interface
///
public final class MIDIAccess {

    public let inputs: MIDIInputMap
    public let outputs: MIDIOutputMap

    public var onStateChange: ((MIDIPort) -> ())? = nil

    public init(name: String) {
        self._client = MIDIClient(name: name)

        self.inputs = MIDIInputMap(client: _client)
        self.outputs = MIDIOutputMap(client: _client)

        //    self._input = MIDIInput(virtual: _client)
        //    self._output = MIDIOutput(virtual: _client) {
        //      print($0.0)
        //    }
        //    //todo
        //    self._input.onMIDIMessage = {
        //      //          self.midi(src: 0, lst: $0)
        //      print($0)
        //    }

        self._observer = NotificationCenter.default.observeMIDIEndpoints {
            self._notification(endpoint: $0, type: $1).map {
                self.onStateChange?($0)
            }
        }
    }

    deinit {
        _observer.map(NotificationCenter.default.removeObserver)
    }

    private func _notification(endpoint: MIDIEndpoint, type: MIDIEndpointNotificationType) -> MIDIPort? {
        switch (endpoint.type, type) {

        case (.input, .added):
            return inputs.add(endpoint)

        case (.output, .added):
            return outputs.add(endpoint)

        case (.input, .removed):
            return inputs.remove(endpoint).map {
                $0.close()
                return $0
            }

        case (.output, .removed):
            return outputs.remove(endpoint).map {
                $0.close()
                return $0
            }
        }
    }

    ///
    /// given an output, tries to find the corresponding input port (non-standard)
    ///
    public func input(for port: MIDIOutput) -> MIDIInput? {
        return inputs.port(with: port.displayName)
    }

    public func createVirtualMIDIInput(name: String) -> VirtualMIDIInput? {
        let endpoint = MIDISourceCreate(ref: self._client.ref, name: name)
        return self.inputs.addVirtual(endpoint)
    }

    public func createVirtualMIDIOutput(
        name: String,
        block: @escaping (UnsafePointer<MIDIPacketList>) -> ()
    ) -> VirtualMIDIOutput? {
        let endpoint = MIDIDestinationCreate(ref: self._client.ref, name: name) { (packet, _) in
            block(packet)
        }
        defer {
            // todo: send notification? but maybe not since this is user created
        }
        return self.outputs.addVirtual(endpoint)
    }

    ///
    /// given an input, tries to find the corresponding output port (non-standard)
    ///
    public func output(for port: MIDIInput) -> MIDIOutput? {
        return outputs.port(with: port.displayName)
    }

    ///
    /// Stops and restarts MIDI I/O (non-standard)
    ///
    public func restart() {
        MIDIRestart()
    }

    private let _client: MIDIClient
    //  private let _clients: Set<MIDIClient> = []

    //  private let _input: MIDIInput
    //  private let _output: MIDIOutput

    private var _observer: NSObjectProtocol? = nil

}

extension MIDIAccess : CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "inputs: \(inputs)\n, output: \(outputs)"
    }
    public var debugDescription: String {
        return "\(self.self)(\(description))"
    }
}


fileprivate extension NotificationCenter {
    final func observeMIDIEndpoints(_ callback: @escaping (MIDIEndpoint, MIDIEndpointNotificationType) -> ()) -> NSObjectProtocol {
        return addObserver(forName: .MIDISetupNotification, object: nil, queue: nil) {
            _ = ($0.object as? MIDIObjectAddRemoveNotification).map {
                callback(.init(notification: $0),
                         MIDIEndpointNotificationType($0.messageID))
            }
        }
    }
}

internal func MIDISourceCreate(ref: MIDIClientRef, name: String) -> MIDIEndpoint {
    var endpoint: MIDIEndpointRef = 0
    OSAssert(MIDISourceCreate(ref, name as CFString, &endpoint))
    return MIDIEndpoint(ref: endpoint)
}



internal func MIDIDestinationCreate(ref: MIDIClientRef, name: String, block: @escaping MIDIReadBlock) -> MIDIEndpoint {
    var endpoint: MIDIEndpointRef = 0
//    if #available(macOS 11.0, *) {
//        MIDIDestinationCreateWithProtocol(ref, name as CFString, ._1_0, &endpoint, block)
//    } else {
//        // Fallback on earlier versions
//        MIDIDestinationCreate(<#T##client: MIDIClientRef##MIDIClientRef#>, <#T##name: CFString##CFString#>, <#T##readProc: MIDIReadProc##MIDIReadProc##(UnsafePointer<MIDIPacketList>, UnsafeMutableRawPointer?, UnsafeMutableRawPointer?) -> Void#>, <#T##refCon: UnsafeMutableRawPointer?##UnsafeMutableRawPointer?#>, <#T##outDest: UnsafeMutablePointer<MIDIEndpointRef>##UnsafeMutablePointer<MIDIEndpointRef>#>)
//        fatalError()
//    }
    OSAssert(MIDIDestinationCreateWithBlock(ref, name as CFString, &endpoint, block))
    return MIDIEndpoint(ref: endpoint)
}
