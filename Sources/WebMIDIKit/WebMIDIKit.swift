//
//  MIDIAccess.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/7/16.
//
//

import CoreMIDI
import Foundation

public typealias EventHandler<T> = ((T) -> ())?

public protocol EventTarget {
  associatedtype Event
  var onStateChange: EventHandler<Event> { get set }
}


///
/// https://www.w3.org/TR/webmidi/#midiaccess-interface
public final class MIDIAccess : EventTarget, CustomStringConvertible, CustomDebugStringConvertible {

  public typealias Event = MIDIPort

  public let inputs: MIDIInputMap
  public let outputs: MIDIOutputMap

  public var onStateChange: EventHandler<Event> = nil

  public init() {
    self._client = MIDIClient()

    self.inputs = MIDIInputMap(client: _client)
    self.outputs = MIDIOutputMap(client: _client)

    self._input = MIDIInput(virtual: _client)
    self._output = MIDIOutput(virtual: _client) {
      print($0.0)
    }
    //todo
    self._input.onMIDIMessage = {
      //          self.midi(src: 0, lst: $0)
      print($0)
    }

    self._observer = NotificationCenter.default.observeMIDIEndpoints {
      self._notification(endpoint: $0, type: $1).map {
        self.onStateChange?($0)
      }
    }
  }

  deinit {
    _observer.map(NotificationCenter.default.removeObserver)
  }

  public var description: String {
    return "inputs: \(inputs)\n, output: \(outputs)"
  }

  public var debugDescription: String {
    return "\(self.self)(\(description))"
  }

  internal func send<S: Sequence>(port: MIDIOutput, data: S, timestamp: Int = 0) where S.Iterator.Element == UInt8 {
    //    guard var p = MIDIPacketList(seq: data) else { return }
    //      timestamp = timestamp == 0 ?

    //    MIDISend(port.ref, 0, &p)
    todo("endpoint, timestamp = 0 ?? now, notify all clients?")
  }

  private func _notification(endpoint: MIDIEndpoint, type: MIDIEndpointNotificationType) -> MIDIPort? {
    switch (endpoint.type, type) {
    case (.input, .added):
      return inputs.add(endpoint)

    case (.input, .removed):
      return inputs.remove(endpoint)

    case (.output, .added):
      return outputs.add(endpoint)

    case (.output, .removed):
      return outputs.remove(endpoint)
    }
  }

  public func restart() {
    MIDIRestart()
  }
  
  private let _client: MIDIClient
  private let _clients: Set<MIDIClient> = []

  private let _input: MIDIInput
  private let _output: MIDIOutput

  private var _observer: NSObjectProtocol? = nil

}

fileprivate extension NotificationCenter {
  func observeMIDIEndpoints(_ callback: @escaping (MIDIEndpoint, MIDIEndpointNotificationType) -> ()) -> NSObjectProtocol {
    return addObserver(forName: .MIDISetupNotification, object: nil, queue: nil) {
      _ = ($0.object as? MIDIObjectAddRemoveNotification).map {
        callback($0.endpoint, MIDIEndpointNotificationType($0.messageID))
      }
    }
  }
}








