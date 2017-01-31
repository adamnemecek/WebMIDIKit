//
//  Scratchpad.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/30/17.
//
//

import Foundation


//protocol MIDINotificationConvertible {}
//
//extension MIDIIOErrorNotification: MIDINotificationConvertible {}
//extension MIDIObjectAddRemoveNotification: MIDINotificationConvertible {}
//extension MIDIObjectPropertyChangeNotification: MIDINotificationConvertible {}
//
//func convertMIDINotification<T: MIDINotificationConvertible>(notificationPointer: UnsafePointer<MIDINotification>) -> T {
//  //    return UnsafePointer<T>(notificationPointer)[0]
//  fatalError()
//}


//class Dispatcher<D: Delegate> {
//    private let delegate : D
//
//    init(delegate: D) {
//        self.delegate = delegate
//    }
//
//    func observe(event: D.Event) {
//        delegate.dispatch(event: event)
//    }
//}


struct MIDIPortInfo {

}



protocol MIDIClientType {
  func add(port: MIDIPort)
//  func receiveMIDI(port: MIDIPort, packet: MIDIPacketList)
}

protocol Delegate {
  associatedtype Event
  func dispatch(event: Event)
}
