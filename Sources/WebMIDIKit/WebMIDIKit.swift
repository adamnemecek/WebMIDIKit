//
//  MIDIAccess.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/7/16.
//
//

import CoreMIDI
import Foundation

/// https://www.w3.org/TR/webmidi/#midiaccess-interface
public final class MIDIAccess {
    
    public static let queue = DispatchQueue.init(label: "midiQueue")

    public let inputs: MIDIInputMap
    public let outputs: MIDIOutputMap

    public var onStateChange: ((MIDIPort) -> ())? = nil

    public init() {
        self._client = MIDIClient()

        self.inputs = MIDIInputMap(client: _client)
        self.outputs = MIDIOutputMap(client: _client)
//
        self._observer = NotificationCenter.default.observeMIDIEndpoints {
            self._notification(endpoint: $0, type: $1).map {
                self.onStateChange?($0)
            }
        }
    }
    
    func addVirtualInput(name: String) -> MIDIInput {
        return MIDIInput(virtual: self._client, name: name)
    }
    
    func addVirtualOutput(name: String, onMidiMessage: @escaping (MIDIEvent) -> ()) -> MIDIOutput {
        let output = MIDIOutput(virtual: self._client, name: name, readmidi: onMidiMessage)
        return output
    }

    deinit {
        _observer.map(NotificationCenter.default.removeObserver)
    }

    private func _notification(endpoint: MIDIEndpoint, type: MIDIEndpointNotificationType) -> MIDIPort? {
//        MIDIAccess.queue.sync {
            let endpointType = endpoint.type
            switch (endpointType, type) {

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
                    
//                case (.other, .added):
//                    return outputs.add(endpoint)
//                    print("other added")
//                    return nil
                    
                default:
                    return nil
            }
//        }
    }

    /// given an output, tries to find the corresponding input port (non-standard)
    public func input(for port: MIDIOutput) -> MIDIInput? {
        return inputs.port(with: port.displayName)
    }

    /// given an input, tries to find the corresponding output port (non-standard)
    public func output(for port: MIDIInput) -> MIDIOutput? {
        return outputs.port(with: port.displayName)
    }

    /// Stops and restarts MIDI I/O (non-standard)
    public func restart() {
        MIDIRestart()
    }

    let _client: MIDIClient
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
            switch $0.object {
                case is MIDIObjectAddRemoveNotification:
                    _ = ($0.object as? MIDIObjectAddRemoveNotification).map { event in
                        MIDIAccess.queue.async {
                            callback(MIDIEndpoint(notification: event),
                            MIDIEndpointNotificationType(event.messageID))
                        }
                    }
                case is MIDIObjectPropertyChangeNotification:
                    print ("midi property change")
                case is MIDIIOErrorNotification:
                    print ("midi error")
                
                default:
                print ("midi nothing")
            }
        }
    }
}
