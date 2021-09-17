//
//  MIDIAccess.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/7/16.
//
//

import CoreMIDI
import Foundation

public typealias MidiReadEvent = (MIDIEvent) -> ()

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
            self._notification(event: $0).map {
                self.onStateChange?($0)
            }
        }
    }
    
    func addVirtualInput(name: String) -> MIDIInput {
        return MIDIInput(virtual: self._client, name: name)
    }
    
    func addVirtualOutput(name: String, onMidiMessage: MidiReadEvent? = nil) -> MIDIOutput {
        let output = MIDIOutput(virtual: self._client, name: name, readmidi: onMidiMessage)
        
        return output
    }

    deinit {
        _observer.map(NotificationCenter.default.removeObserver)
    }
    
    private func findMidiEndpoint(event: MIDIObjectAddRemoveNotification) -> MIDIEndpoint {
        switch event.childType {
            case .source:
//                print("event.child = " + event.child.description)
                
                for input in inputs {
                    let midiInput = input.1
                    if midiInput.endpoint.ref == event.child {
                        return midiInput.endpoint
                    }
                }
            case .destination:
                for output in outputs {
                    let midiOutput = output.1
                    if midiOutput.endpoint.ref == event.child {
                        return midiOutput.endpoint
                    }
                }
            default:
                break
        }
        return MIDIEndpoint(notification: event)
    }

    private func _notification(event: MIDIObjectAddRemoveNotification) -> MIDIPort? {
//        endpoint: MIDIEndpoint, type: MIDIEndpointNotificationType)
//        MIDIAccess.queue.sync {
        
            let endpoint = findMidiEndpoint(event: event)
            let notificationType = MIDIEndpointNotificationType(event.messageID)
            let endpointType = endpoint.type
        
            switch (endpointType, notificationType) {

                case (.input, .added):
                    print("[MIDIAccess] input added: " + endpoint.displayName)
                    return inputs.add(endpoint)

                case (.output, .added):
                    print("[MIDIAccess] output added: " + endpoint.displayName)
                    return outputs.add(endpoint)

                case (.input, .removed):
                    print("[MIDIAccess] input removed: " + endpoint.displayName)
                    return inputs.remove(endpoint).map {
                        $0.close()
                        return $0
                    }

                case (.output, .removed):
                    print("[MIDIAccess] output removed: " + endpoint.displayName)
                    return outputs.remove(endpoint).map {
                        $0.close()
                        return $0
                    }
                    
                case (.other, .added):
                    print("_notification other added");
                    return nil
                    
                case (.other, .removed):
                    print("_notification other removed");
                    return nil
                    
                default:
                    print("_notification default");
                    return nil
            }
//        }
    }

    /// given an output, tries to find the corresponding input port (non-standard)
    public func input(for port: MIDIOutput) -> MIDIInput? {
        return inputs.port(with: port)
    }

    /// given an input, tries to find the corresponding output port (non-standard)
    public func output(for port: MIDIInput) -> MIDIOutput? {
        return outputs.port(with: port)
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
    final func observeMIDIEndpoints(_ callback: @escaping (MIDIObjectAddRemoveNotification) -> ()) -> NSObjectProtocol {
        return addObserver(forName: .MIDISetupNotification, object: nil, queue: nil) {
            switch $0.object {
                case is MIDIObjectAddRemoveNotification:
                    _ = ($0.object as? MIDIObjectAddRemoveNotification).map { event in
                        MIDIAccess.queue.async {
                            callback(event)
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
