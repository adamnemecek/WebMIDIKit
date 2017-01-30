//
//  WebMIDIManager.swift
//  WarpKit
//
//  Created by Adam Nemecek on 12/7/16.
//
//

import Foundation
import AVFoundation

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
  func receiveMIDI(port: MIDIPort, packet: MIDIPacketList)
}

protocol Delegate {
  associatedtype Event
  func dispatch(event: Event)
}

fileprivate struct MIDIOutputs: Collection {
  typealias Index = Int
  typealias Element = MIDIPortRef

  var startIndex: Index {
    return 0
  }

  var endIndex: Index {
    return MIDIGetNumberOfDestinations()
  }

  subscript (index: Index) -> Element {
    return MIDIGetDestination(index)
  }
}

//fileprivate struct MIDISources: Collection {
//  typealias Index = Int
//  typealias Element = MIDIEndpointRef
//
//  var startIndex: Index {
//    return 0
//  }
//
//  var endIndex: Index {
//    return MIDIGetNumberOfSources()
//  }
//
//  subscript (index: Index) -> Element {
//    return MIDIGetSource(index)
//  }
//}

fileprivate func MIDISources() -> [MIDIEndpointRef] {
  return (0..<MIDIGetNumberOfSources()).map(MIDIGetSource)
}

fileprivate func MIDIDestinations() -> [MIDIEndpointRef] {
  return (0..<MIDIGetNumberOfDestinations()).map(MIDIGetDestination)
}

public class MIDIManager {
  fileprivate let clients: Set<MIDIClient> = []

  let inputs: [MIDIInput] = []
  let outputs: [MIDIOutput] = []

  //    var input: WebMIDIInput {
  //        return WebMIDIInput()
  //    }
  //
  //    var output: WebMIDIOutput {
  //        fatalError()
  //    }
}



class MIDIEndpoint: Equatable, Hashable {
  private(set) var ref: MIDIEndpointRef

  fileprivate init(ref: MIDIEndpointRef) {
    self.ref = ref
  }

  var hashValue: Int {
    return ref.hashValue
  }

  static func ==(lhs: MIDIEndpoint, rhs: MIDIEndpoint) -> Bool {
    return lhs.ref == rhs.ref
  }
}

final class MIDIConnection: Hashable {
  fileprivate let port: MIDIPort
  fileprivate let source: MIDIEndpoint

  fileprivate init(port: MIDIPort, source: MIDIEndpoint) {
    self.port = port
    self.source = source
    MIDIPortConnectSource(port.ref, source.ref, nil)
  }

  deinit {
    MIDIPortDisconnectSource(port.ref, source.ref)
  }

  static func ==(lhs: MIDIConnection, rhs: MIDIConnection) -> Bool {
    return lhs.port == rhs.port && lhs.source == rhs.source
  }

  var hashValue: Int {
    return port.hashValue ^ source.hashValue
  }
}

//extension MIDINotification {
//    var addRemoveNotification: MIDIObjectAddRemoveNotification {
//
//    }
//}

//extension UnsafePointer {
//  func map<T>(transform: (Pointee) -> T) -> T {
//    return transform(pointee)
//  }
//}


extension MIDIObjectAddRemoveNotification {
  init?(ptr: UnsafePointer<MIDINotification>) {
    switch ptr.pointee.messageID {
    case .msgObjectAdded, .msgObjectRemoved:
      self = ptr.withMemoryRebound(to: MIDIObjectAddRemoveNotification.self, capacity: 1) {
        $0.pointee
      }
    default: return nil
    }
  }
}

final class MIDIManagerMac: MIDIManager {
  static let sharedInstance = MIDIManagerMac()

  var client: MIDIClient? = nil


  //let clients: [MIDIClient]

  let input: MIDIInput
  let output: MIDIOutput

  private(set) var sources: [MIDIConnection] = []

  private(set) var destinations: [MIDIEndpoint] = []


  private func notification(ptr: UnsafePointer<MIDINotification>) {
    _ = MIDIObjectAddRemoveNotification(ptr: ptr).map {
      let endpoint = MIDIEndpoint(ref: $0.child)

      switch (ptr.pointee.messageID, $0.childType) {
      case (.msgObjectAdded, .source):
        if let s = (sources.first { $0.source == endpoint }) {
          s.port.state = .connected
          //notificy clients
        }
        else {
          let conn = MIDIConnection(port: self.input, source: endpoint)
          self.sources.append(conn)
        }
      case (.msgObjectAdded, .destination):
        if let d = (destinations.first { $0 == endpoint }) {

          //setoutputportstate(port, opened)
        }
        else {
          destinations.append(endpoint)
        }

      case (.msgObjectRemoved, .source):
        sources = sources.filter {
          let remove = $0.source == endpoint
          if remove {
            //            $0.port.connection = .disconnected
          }
          return remove
        }
        if let s = (sources.first { $0.source == endpoint }) {

          //setinputportstate, disconnected
        }

      case (.msgObjectRemoved, .destination):
        if let d = (destinations.first { $0 == endpoint }) {
          //setoutputportstate(d, disconnected)
        }
      default: break
      }
    }
  }

  private override init() {

    // the callback ReceiveMidiNotify
    let client = MIDIClient { _ in
      //      self?.notification(ptr: $0)

      fatalError("stuff")
    }

    let input = MIDIInput(client: client) {
      e in
      //readmididispatch
      //            self.clients
    }
    self.client = client
    self.input = input
    self.output = MIDIOutput(client: client)

    self.sources = MIDISources().map {
      MIDIConnection(port: input,
                     source: MIDIEndpoint(ref: $0))
    }
    
    self.destinations = MIDIDestinations().map {
      MIDIEndpoint(ref: $0)
    }
    
    super.init()
  }
}







