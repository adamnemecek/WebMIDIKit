//
//  Plus.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI

//public struct Event {
//  let timestamp: MIDITimeStamp
//  let status, data1, data2: UInt8
//}

public protocol EventType {
  associatedtype Timestamp: Comparable
  var timestamp: Timestamp { get }
}

public protocol MutableEventType : EventType {
  var timestamp: Timestamp { get set }
}

//public protocol TimeSeries: Sequence {
//  associatedtype Timestamp: Comparable
//  subscript (timerange range: ClosedRange<Timestamp>) -> SubSequence { get }
//}
//
//public protocol MutableTimeSeries: TimeSeries {
//  subscript (timerange range: ClosedRange<Timestamp>) -> SubSequence { get set }
//}

//extension MIDIPacketList: TimeSeries {
//  public typealias Timestamp = MIDITimeStamp
//  public typealias SubSequence = MIDIPacketList
//
//  public subscript (timerange range: ClosedRange<Timestamp>) -> SubSequence {
//    fatalError()
//  }
//}

public extension EventType where Timestamp == MIDITimeStamp {
  public var second: Double {
    fatalError()
  }
}

//struct TimeSignature: Equatable {
//	let numerator: Int
//	let denominator: Int
//}
//
//func ==(lhs: TimeSignature, rhs: TimeSignature) -> Bool {
//	return lhs.numerator == rhs.numerator &&
//		   lhs.denominator == rhs.denominator
//}
//
//func /(lhs: Int, rhs: Int) -> TimeSignature {
//	return TimeSignature(numerator: lhs, denominator: rhs)
//}


// todo: chrome has this do this for events
//extension MIDIPacket {
//  var seconds: Double {
//    let ns = Double(AudioConvertHostTimeToNanos(timeStamp))
//    return ns / 1_000_000_000
//  }
//}




extension Collection where Iterator.Element == UInt8 {

}


//protocol TimeSeries: Collection {
//  associatedtype Event: EventType = Iterator.Element
//  var timerange: ClosedRange<Event.Timestamp> { get }
//}

//extension TimeSeries {
//  var timerange: ClosedRange<Event.Timestamp>? {
////    guard let f = first, l = 
////    return first
//  }
//}

//extension MIDIPacketList: TimeSeries {
//
//}

