//
//  Extension.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import enum CoreMIDI.MIDIObjectType

extension Collection where Index == Int {
  public func index(after i: Index) -> Index {
    return i + 1
  }
}

extension Collection {
  subscript (safe index: Index) -> Iterator.Element? {
    guard (startIndex..<endIndex).contains(index) else { return nil }
    return self[index]
  }
}

//extension Sequence {
//  public func prompt() -> Iterator.Element? {
//    let a = Array(self)
//
//    guard a.count > 1 else {
//      print("Automatically selected \(a.first) because there are \(a.count) elements")
//      return a.first
//    }
//
//    print("Select \(Iterator.Element.self) from \(type(of:self)) by typing element's number")
//
//
//    for (i, e) in a.enumerated() {
//      print("  #\(i) = \(e)")
//    }
//
//    print("Select: ", terminator: "")
//    guard let choice = (readLine().flatMap { Int($0) }) else { return nil }
//    return a[safe: choice]
//  }
//}

extension String {
  func trim() -> String? {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }
}

extension MIDIObjectType : CustomStringConvertible {
  public var description: String {
    switch self {
    case .other: return "other"
    case .device: return "device"
    case .entity: return "entity"
    case .source: return "source"
    case .destination: return "destination"
    case .externalDevice: return "externalDevice"
    case .externalEntity: return "externalEntity"
    case .externalSource: return "externalSource"
    case .externalDestination: return "externalDestination"
    }
  }
}

extension CustomStringConvertible {
  public var debugDescription: String {
    return "\(self.self)(\(description))"
  }
}
