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
public final class MIDIAccess : EventTarget, CustomStringConvertible {

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
      self._notification(endpoint: $0, type: $1).map { port in
        self.onStateChange?(port)
      }
    }
  }

  deinit {
    _observer.map(NotificationCenter.default.removeObserver)
  }

  public var description: String {
    return describe(self)
  }

  internal func send<S: Sequence>(port: MIDIOutput, data: S, timestamp: Int = 0) where S.Iterator.Element == UInt8 {
    //    guard var p = MIDIPacketList(seq: data) else { return }
    //      timestamp = timestamp == 0 ?

    //    MIDISend(port.ref, 0, &p)
    todo("endpoint, timestamp = 0 ?? now, notify all clients?")
  }

  private func midi(src: MIDIEndpointRef, lst: UnsafePointer<MIDIPacketList>) {
    //    _ = sources.first { $0.source.ref == src }.map {
    //      _ in
    //      lst.pointee.forEach {
    //          packet in
    //      }
    //    }
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
  
  private let _client: MIDIClient
  private let _clients: Set<MIDIClient> = []

  private let _input: MIDIInput
  private let _output: MIDIOutput

  private var _observer: NSObjectProtocol? = nil

}

protocol NotificationType {

}

//extension NotificationCenter {
//  func observe<T>(_ callback: @escaping (T) -> ()) -> NSObjectProtocol {
//    return addObserver(forName: NSNotification.Name(rawValue: "\(T.self)"), object: nil, queue: nil) {
//      _ in
//    }
//
//  }
//}

fileprivate extension NotificationCenter {
  func observeMIDIEndpoints(_ callback: @escaping (MIDIEndpoint, MIDIEndpointNotificationType) -> ()) -> NSObjectProtocol {
    return addObserver(forName: .MIDISetupNotification, object: nil, queue: nil) {
      _ = ($0.object as? MIDIObjectAddRemoveNotification).map {
        callback($0.endpoint, MIDIEndpointNotificationType($0.messageID))
      }
    }
  }
}








