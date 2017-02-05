//
//  MIDIPortMap.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI

public class MIDIPortMap<Value: MIDIPort> : Collection {
  public typealias Key = Int
  public typealias Index = Dictionary<Key, Value>.Index

  public var startIndex: Index {
    return _content.startIndex
  }

  public var endIndex: Index {
    return _content.endIndex
  }

  public subscript (key: Key) -> Value? {
    get {
      return _content[key]
    }
    //
    // this is called by the notification handler in midiaccess
    //
    set {
      _content[key] = newValue
    }
  }

  public subscript(index: Index) -> (Key, Value) {
    return _content[index]
  }

  public func index(after i: Index) -> Index {
    return _content.index(after: i)
  }

  public var description: String {
    return dump(_content).description
  }

  // todo weak? maybe we don't even need it?
  fileprivate let _client: MIDIClient

  internal init(client: MIDIClient, ports: [Value]) {
    self._client = client
    self._content = [:]
    ports.forEach {
      self[$0.id] = $0
    }
  }

  internal func add(_ port: Value) -> Value? {
      self[port.id] = port
      return port
  }

   func remove(_ endpoint: MIDIEndpoint) -> Value? {
    //disconnect?
    guard let port = self[endpoint] else { assert(false); return nil }
//    port.disconnect() // put into pending?
    self[port.id] = nil
    return port
  }

  /// Prompts the user to select a MIDIPort
  public func prompt() -> Value? {
    var i = 0
    forEach {
      print("\(i) select: \($1)")
      i += 1
    }
    fatalError()
    return nil
  }

  //
  // todo should this be doing key, value?
  //
  private subscript (endpoint: MIDIEndpoint) -> Value? {
//    get {
    return _content.first { $0.value.endpoint == endpoint }?.value
//    }
//    set {
//      _ = (newValue ?? self[endpoint]).map {
//        self[$0.id] = newValue
//      }
//    }
  }
//  public init(arrayLiteral literal: Value...) {
//
//  }
  private var _content: [Key: Value]
}

public class MIDIInputMap : MIDIPortMap<MIDIInput> {
  internal init(client: MIDIClient) {
    let ports = MIDISources().map { MIDIInput(client: client, endpoint: $0) }
    super.init(client: client, ports: ports)
  }

  func add(_ endpoint: MIDIEndpoint) -> MIDIPort? {
    return add(MIDIInput(client: _client, endpoint: endpoint))
  }
}

public class MIDIOutputMap : MIDIPortMap<MIDIOutput> {
  internal init(client: MIDIClient) {
    let ports = MIDIDestinations().map { MIDIOutput(client: client, endpoint: $0) }
    super.init(client: client, ports: ports)
  }

  func add(_ endpoint: MIDIEndpoint) -> MIDIPort? {
    return add(MIDIOutput(client: _client, endpoint: endpoint))
  }
}


fileprivate func MIDISources() -> [MIDIEndpoint] {
  return (0..<MIDIGetNumberOfSources()).map {
    MIDIEndpoint(ref: MIDIGetSource($0))
  }
}

fileprivate func MIDIDestinations() -> [MIDIEndpoint] {
  return (0..<MIDIGetNumberOfDestinations()).map {
    MIDIEndpoint(ref: MIDIGetDestination($0))
  }
}
