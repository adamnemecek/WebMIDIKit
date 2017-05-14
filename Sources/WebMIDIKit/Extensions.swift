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

