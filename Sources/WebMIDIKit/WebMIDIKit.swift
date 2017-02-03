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

  private let client: MIDIClient
  private let clients: Set<MIDIClient> = []

  private let input: MIDIInput
  private let output: MIDIOutput

  public init() {
    let client = MIDIClient()

    self.client = client
    self.inputs = MIDIInputMap(client: client)
    self.outputs = MIDIOutputMap(client: client)

    self.input = MIDIInput(virtual: client)
    self.output = MIDIOutput(virtual: client) {
      print($0.0)
    }
    //todo
    self.input.onMIDIMessage = {
      //          self.midi(src: 0, lst: $0)
      print($0)
    }
    NotificationCenter.default.addObserver(self, selector: #selector(notification), name: nil, object: nil)
  }

  /// And
  @objc private func notification(ptr: UnsafePointer<MIDINotification>) {
    guard let n = MIDIObjectAddRemoveNotification(ptr: ptr) else { return }
    let endpoint = n.endpoint
    //todo remove the assert
    assert(MIDIPortType(n.childType) == endpoint.type)

    /// we can force unwrap the type because we know that this 
    /// is a non-virtual endpoint
    assert(!endpoint.isVirtual)
    switch (n.messageID, endpoint.type) {

    case (.msgObjectAdded, .input):
      inputs.add(endpoint)

    case (.msgObjectAdded, .output):
      outputs.add(endpoint)

    case (.msgObjectRemoved, .input):
      inputs.remove(endpoint)

    case (.msgObjectRemoved, .output):
      outputs.remove(endpoint)

    default:
      break
    }
  }

  public var description: String {
    return describe(self)
  }

  internal func send<S: Sequence>(port: MIDIOutput, data: S, timestamp: Int = 0) where S.Iterator.Element == UInt8 {
    guard var p = MIDIPacketList(seq: data) else { return }
    //      timestamp = timestamp == 0 ?

    MIDISend(port.ref, 0, &p)
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



  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}


func test() {
  let access = MIDIAccess()
  let p: MIDIPacket = [1,2,3]
  
  
  
  
}

@_exported import struct CoreMIDI.MIDIPacket
@_exported import struct CoreMIDI.MIDIPacketList






