//
//  MIDIPortMap.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI

extension String {
  func trim() -> String? {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }
}

extension Collection {
  subscript (safe index: Index) -> Iterator.Element? {
    guard (startIndex..<endIndex).contains(index) else { return nil }
    return self[index]
  }
}

public class MIDIPortMap<Value: MIDIPort> : Collection, CustomStringConvertible, CustomDebugStringConvertible {
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

  internal init(client: MIDIClient, ports: [Value]) {
    self._client = client
    self._content = [:]
    ports.forEach {
      self[$0.id] = $0
    }
  }

  internal func add(_ port: Value) -> Value? {
    assert(self[port.id] == nil)
    self[port.id] = port
    return port
  }

  internal func remove(_ endpoint: MIDIEndpoint) -> Value? {
    //disconnect?
    guard let port = self[endpoint] else { assert(false); return nil }
    assert(port.state == .connected)
    self[port.id] = nil
    return port
  }

  /// Prompts the user to select a MIDIPort
  public func prompt() -> Value? {
    print("Select \(first?.1.type) by typing the associated number:\n")
    let ports = map { $0.1 }

    for (i, port) in ports.enumerated() {
      print("\t\(i + 1) to select \(port)")
    }

    guard let choice = (readLine().flatMap { Int($0) }) else { return nil }
    return ports[safe: choice]
  }

  //
  // todo should this be doing key, value?
  //
  private subscript (endpoint: MIDIEndpoint) -> Value? {
    return _content.first { $0.value.endpoint == endpoint }?.value
  }

  private var _content: [Key: Value]
  fileprivate weak var _client: MIDIClient!
}

public class MIDIInputMap : MIDIPortMap<MIDIInput> {
  internal init(client: MIDIClient) {
    let ports = MIDISources().map { MIDIInput(client: client, endpoint: $0) }
    super.init(client: client, ports: ports)
  }

  internal func add(_ endpoint: MIDIEndpoint) -> MIDIPort? {
    return add(MIDIInput(client: _client, endpoint: endpoint))
  }
}

public class MIDIOutputMap : MIDIPortMap<MIDIOutput> {
  internal init(client: MIDIClient) {
    let ports = MIDIDestinations().map { MIDIOutput(client: client, endpoint: $0) }
    super.init(client: client, ports: ports)
  }

  internal func add(_ endpoint: MIDIEndpoint) -> MIDIPort? {
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
