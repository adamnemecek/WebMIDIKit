//
//  Extension.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import enum CoreMIDI.MIDIObjectType
import Foundation


extension Collection {
    subscript (safe index: Index) -> Iterator.Element? {
        guard (startIndex..<endIndex).contains(index) else { return nil }
        return self[index]
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

extension Data {
    init<T>(encode: T) {
        var cpy = encode
        self.init(bytes: &cpy, count: MemoryLayout<T>.size)
    }

    func decode<T>() -> T {
        return withUnsafeBytes { $0.pointee }
    }
}

extension UnsafeMutableRawBufferPointer {
    mutating
    func copyBytes<S: Sequence>(from data: S) -> Int where S.Iterator.Element == UInt8 {
        var copied = 0
        for (i, byte) in data.enumerated() {
            storeBytes(of: byte, toByteOffset: i, as: UInt8.self)
            copied += 1
        }
        return copied
    }
}
