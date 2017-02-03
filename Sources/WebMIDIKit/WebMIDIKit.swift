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

    self.input = MIDIInput(client: client)
    self.output = MIDIOutput(client: client)

    self.input.onMIDIMessage = {
      self.midi(src: 0, lst: $0)
    }
  }

  private func notification(ptr: UnsafePointer<MIDINotification>) {
    guard let n = MIDIObjectAddRemoveNotification(ptr: ptr) else { return }
    let endpoint = n.endpoint
    //todo remove the assert
    assert(MIDIPortType(n.childType) == endpoint.type)

    switch (n.messageID, endpoint.type) {

    case (.msgObjectAdded, .input):
      self.inputs.add(endpoint)

    case (.msgObjectAdded, .output):
      self.outputs.add(endpoint)

    case (.msgObjectRemoved, .input):
      self.inputs.remove(endpoint)

    case (.msgObjectRemoved, .output):
      self.outputs.remove(endpoint)

    default:
      break
    }
  }

  public var description: String {
    fatalError()
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

  }
}


func test() {
  let access = MIDIAccess()
  let p: MIDIPacket = [1,2,3]




}






