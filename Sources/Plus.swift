//
//  Plus.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI

public struct Event {
  let timestamp: MIDITimeStamp
  let status, data1, data2: UInt8
}

protocol EventType {
  associatedtype Timestamp
  var timestamp: Timestamp { get }
}

