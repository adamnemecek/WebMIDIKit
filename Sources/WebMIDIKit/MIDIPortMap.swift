//
//  MIDIPortMap.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI

public class MIDIPortMap<Value: MIDIPort>: Collection {
  public typealias Key = String
  public typealias Index = Dictionary<Key, Value>.Index

  fileprivate var content: [Key: Value]

  public init() {
    content = [:]
  }

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
    return content[index]
  }

  public func index(after i: Index) -> Index {
    return content.index(after: i)
  }
}


public class MIDIInputMap: MIDIPortMap<MIDIInput> {
  public override init() {
    super.init()
    

  }
}

//
//extension MIDIPortMap where Value: Equatable {
//
//}
