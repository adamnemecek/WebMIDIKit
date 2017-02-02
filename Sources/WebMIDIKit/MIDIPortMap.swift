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
    set {
//      assert(content[index].value.connection == .open)
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

//  public init(arrayLiteral literal: Value...) {
//
//  }
}


public class MIDIInputMap : MIDIPortMap<MIDIInput> {
  internal override init(client: MIDIClient) {
    super.init(client: client)
    MIDISources().forEach { _ in
      self.content[""] = MIDIInput(client: client)
    }
  }
}

public class MIDIOutputMap : MIDIPortMap<MIDIOutput> {
  internal override init(client: MIDIClient) {
    super.init(client: client)
    MIDIDestinations().forEach { _ in
      self.content[""] = MIDIOutput(client: client)
    }
  }
}

//
//extension MIDIPortMap where Value: Equatable {
//
//}
