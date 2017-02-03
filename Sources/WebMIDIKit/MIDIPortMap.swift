//
//  MIDIPortMap.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI

extension Dictionary {
  init<S: Sequence>(seq: S) where S.Iterator.Element == (Key, Value) {
    self.init()
    seq.forEach { self[$0] = $1 }
  }
}

public class MIDIPortMap<Value: MIDIPort> : Collection {
  public typealias Key = Int
  public typealias Index = Dictionary<Key, Value>.Index

  private var content: [Key: Value]

  public var startIndex: Index {
    return content.startIndex
  }

  public var endIndex: Index {
    return content.endIndex
  }

  public subscript (key: Key) -> Value? {
    get {
      return content[key]
    }
    //
    // this is called by the notification handler in midiaccess
    //
    set {
      content[key] = newValue
    }
  }

  public subscript(index: Index) -> (Key, Value) {
    return content[index]
  }

  public func index(after i: Index) -> Index {
    return content.index(after: i)
  }

  public var description: String {
    return dump(content).description
  }

  internal let client: MIDIClient

  internal init(client: MIDIClient, ports: [Value]) {
    self.client = client
    self.content = [:]

    ports.forEach {
      self[$0.id] = $0
    }
  }

  internal func add(_ endpoint: MIDIEndpoint) {
      fatalError()
//    switch Value.Type {
//      case is MIDIInput:
//        let p = Self(client: client, endpoint: endpoint)
//        self[p.id] = p
//      case .output:
//        let p = MIDIOutput(client: client, endpoint: endpoint)
//        self[p.id] = p
//
//    }
//    assert(endpoint.type == p.type)
  }


  internal func remove(_ endpoint: MIDIEndpoint) {
    //disconnect?
    guard let port = self[endpoint] else { assert(false); return }
//    port.disconnect() // put into pending?
    self[port.id] = nil
  }

  //
  // todo should this be doing key, value?
  //
  internal private(set) subscript (endpoint: MIDIEndpoint) -> Value? {
    get {
      return content.first { $0.value.endpoint == endpoint }?.value
    }
    set {
      _ = (newValue ?? self[endpoint]).map {
        self[$0.id] = newValue
      }
    }
  }
//  public init(arrayLiteral literal: Value...) {
//
//  }
}

public class MIDIInputMap : MIDIPortMap<MIDIInput> {
  internal init(client: MIDIClient) {
    let ports = MIDISources().map { MIDIInput(client: client, endpoint: $0) }
    super.init(client: client, ports: ports)
  }
}

public class MIDIOutputMap : MIDIPortMap<MIDIOutput> {
  internal init(client: MIDIClient) {
    let ports = MIDIDestinations().map { MIDIOutput(client: client, endpoint: $0) }
    super.init(client: client, ports: ports)
  }
}
