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

public protocol MutableEventType: EventType {
  var timestamp: Timestamp { get set }
}

public extension EventType where Timestamp == MIDITimeStamp {
  public var second: Double {
    fatalError()
  }
}

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

