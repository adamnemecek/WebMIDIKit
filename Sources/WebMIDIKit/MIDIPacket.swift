//
//  MIDIPacket.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 2/3/17.
//
//

import CoreMIDI
import Foundation


//extension MIDIPacket : MutableCollection, Equatable, Comparable, Hashable, ExpressibleByArrayLiteral, CustomStringConvertible, CustomDebugStringConvertible {
//    public typealias Element = UInt8
//    public typealias Index = Int
//    
//    public var startIndex: Index {
//        return 0
//    }
//    
//    public var endIndex: Index {
//        return Int(length)
//    }
//    
//    public subscript(index: Index) -> Element {
//        
//        get {
//            var d = data
//            return withUnsafeBytes(of: &d) {
//                $0.load(fromByteOffset: index, as: Element.self)
//            }
//        }
//        set {
//            withUnsafeMutableBytes(of: &data)  {
//                $0.storeBytes(of: newValue, toByteOffset: index, as: Element.self)
//            }
//        }
//    }
//    
//    public static func ==(lhs: MIDIPacket, rhs: MIDIPacket) -> Bool {
//        return
//            (lhs.timeStamp, lhs.count) == (rhs.timeStamp, rhs.count) &&
//                lhs.elementsEqual(rhs)
//    }
//    
//    public static func <(lhs: MIDIPacket, rhs: MIDIPacket) -> Bool {
//        return lhs.timeStamp < rhs.timeStamp
//    }
//    
//    public var hashValue: Int {
//        return Int(data.0) ^ Int(timeStamp) ^ count
//    }
//    
//    //  init(data: [Element], timestamp: MIDITimeStamp = 0) {
//    //    self.init(timestamp: timestamp, data: Data(data))
//    //  }
//    
//    public var type: UInt8 {
//        return data.0 & 0xf0
//    }
//    
//    public var channel: UInt8 {
//        return data.0
//    }
//    
//    
//    public init(arrayLiteral literal: Element...) {
//        //    self.init(data: Array(literal))
//        fatalError()
//    }
//    
//    public var isSysEx: Bool {
//        return data.0 >= 240
//    }
//    
//    public var description: String {
//        return "\(Array(self))"
//    }
//}
