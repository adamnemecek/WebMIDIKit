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
      return content[key]
    }
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

  internal let access: MIDIAccess

  internal init(access: MIDIAccess) {
    self.access = access
    content = [:]
  }

//  public init(arrayLiteral literal: Value...) {
//
//  }
}


public class MIDIInputMap : MIDIPortMap<MIDIInput> {
  internal override init(access: MIDIAccess) {
    super.init(access: access)

  }
}

public class MIDIOutputMap : MIDIPortMap<MIDIOutput> {
  internal override init(access: MIDIAccess) {
    super.init(access: access)
    

  }
}

//
//extension MIDIPortMap where Value: Equatable {
//
//}
