//
//  WebMIDIManager.swift
//  WarpKit
//
//  Created by Adam Nemecek on 12/7/16.
//
//

import Foundation
import AVFoundation



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

fileprivate struct MIDISources: Collection {
    typealias Index = Int
    typealias Element = MIDIEndpointRef

    var startIndex: Index {
        return 0
    }

    var endIndex: Index {
        return MIDIGetNumberOfSources()
    }

    subscript (index: Index) -> Element {
        return MIDIGetSource(index)
    }
}


fileprivate struct MIDIDestinations: Collection {
    typealias Index = Int
    typealias Element = MIDIEndpointRef

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


class MIDIManager {
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

final class MIDIConnection: Equatable, Hashable {
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

final class MIDIManagerMac: MIDIManager {
    static let sharedInstance = MIDIManagerMac()

    let client: MIDIClient


    //let clients: [MIDIClient]

    let input: MIDIInput
    let output: MIDIOutput

    let sources: [MIDIConnection]

    let destinations: [MIDIEndpoint]



    private override init() {
        // the callback ReceiveMidiNotify
        self.client = MIDIClient {
            switch $0.messageID {
            case .msgObjectAdded:
                break
            case .msgObjectRemoved:
                break
            case .msgPropertyChanged:
                break
            default:
                 break
            }
        }

        let input = MIDIInput(client: client) {
            e in
            //readmididispatch
//            self.clients
        }
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







