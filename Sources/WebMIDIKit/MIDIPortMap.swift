//
//  MIDIPortMap.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI

public class MIDIPortMap<Value: MIDIPort> : Collection {
  public typealias Key = String
  public typealias Index = Dictionary<Key, Value>.Index

  fileprivate var content: [Key: Value]

//  public init() {
//    content = [:]
//  }

  public var startIndex: Index {
    return content.startIndex
  }

  public var endIndex: Index {
    return content.endIndex
  }

  public subscript (key: Key) -> Value? {
    get {
      assert(content[key]?.connection == .open)
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
    assert(content[index].value.connection == .open)
    return content[index]
  }

  public func index(after i: Index) -> Index {
    return content.index(after: i)
  }

  internal let client: MIDIClient

  internal init(client: MIDIClient) {
    self.client = client
    content = [:]
  }

  internal subscript (endpoint: MIDIEndpoint) -> Value? {
    get {
      return content.first { $0.value.endpoint == endpoint }?.value
    }
    set {
      guard let id = (newValue ?? self[endpoint])?.id else { return }
      //should i be closing it?
      self[String(id)] = newValue
    }
  }
//  public init(arrayLiteral literal: Value...) {
//
//  }
}


public class MIDIInputMap : MIDIPortMap<MIDIInput> {
  internal override init(client: MIDIClient) {
    super.init(client: client)
    MIDISources().forEach {
      self[$0] = MIDIInput(client: client, endpoint: $0)
    }
  }
}

public class MIDIOutputMap : MIDIPortMap<MIDIOutput> {
  internal override init(client: MIDIClient) {
    super.init(client: client)
    MIDIDestinations().forEach {
      self[$0] = MIDIOutput(client: client, endpoint: $0)
    }
  }
}

//
//extension MIDIPortMap where Value: Equatable {
//
//}
