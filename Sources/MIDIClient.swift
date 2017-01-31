//
//  MIDIClient.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import CoreMIDI

internal final class MIDIClient: Comparable, Hashable {
    let ref: MIDIClientRef

    internal init(callback: @escaping (UnsafePointer<MIDINotification>) -> ()) {
        self.ref = MIDIClientCreate(name: "WebMIDIKit") { callback($0) }
    }

    deinit {
        MIDIClientDispose(ref)
    }

    internal var hashValue: Int {
        return ref.hashValue
    }

    internal static func ==(lhs: MIDIClient, rhs: MIDIClient) -> Bool {
        return lhs.ref == rhs.ref
    }

    internal static func <(lhs: MIDIClient, rhs: MIDIClient) -> Bool {
        return lhs.ref < rhs.ref
    }
}

protocol MIDIReceiver {
  func receiveMIDI()
}

public struct MIDIPortMap: Collection {
  public typealias Key = String
  public typealias Value = MIDIPort
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
