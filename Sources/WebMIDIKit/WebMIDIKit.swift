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

    let obj = NotificationCenter.default.observeMIDIEndpoints {
      self.notification(messageID: $0, endpoint: $1)
    }
  }

  private func notification(messageID: MIDIEndpointChange, endpoint: MIDIEndpoint) {
    switch (messageID, endpoint.type) {
    case (.added, .input):
      inputs.add(endpoint)

    case (.added, .output):
      outputs.add(endpoint)

    case (.removed, .input):
      inputs.remove(endpoint)

    case (.removed, .output):
      outputs.remove(endpoint)
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






