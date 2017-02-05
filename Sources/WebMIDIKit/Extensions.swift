//
//  Extension.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import enum CoreMIDI.MIDIObjectType

//fileprivate func generatorForTuple(_ tuple: Any) -> AnyIterator<Any> {
//  let children = Mirror(reflecting: tuple).children
//  return AnyIterator(children.makeIterator().lazy.map { $0.value }.makeIterator())
//}
//
//public extension Sequence where Iterator.Element: Hashable {
//    //
//    // dbj2
//    //
//    public var hashValue: Int {
//        return reduce(5381) {
//            (accu, current) in
//            (accu << 5) &+ accu &+ current.hashValue
//        }
//    }
//}

extension Sequence {
  func count(pred: @escaping (Iterator.Element) -> Bool) -> Int {
    return reduce(0) { $0 + (pred($1) ? 1 : 0) }
  }
}

extension Collection where Index == Int {
  public func index(after i: Index) -> Index {
    return i + 1
  }
}

extension RangeReplaceableCollection where Iterator.Element: Equatable {
  //
  // return value indicates whether the element was appended or not
  //
  mutating func appendUnique(newElement: Iterator.Element) -> Bool {
    guard !contains(newElement) else { return false }
    append(newElement)
    return true
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
