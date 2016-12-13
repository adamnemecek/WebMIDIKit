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


protocol MIDIClientType {
    func add(port: WebMIDIPort)
    func receiveMIDI(port: WebMIDIPort, packet: MIDIPacketList)
}

protocol Delegate {
    associatedtype Event
    func dispatch(event: Event)
}

internal final class WebMIDIClient: Comparable, Hashable {
    private(set) var ref: MIDIClientRef = MIDIClientRef()

    init() {
        MIDIClientCreateWithBlock("webmidi" as CFString, &self.ref) {
            self.dispatch(event: $0.pointee)
        }
    }

    deinit {
        MIDIClientDispose(ref)
    }

    fileprivate func dispatch(event: MIDINotification) {
        switch event.messageID {
        case .msgObjectAdded:
            break
        default:
            break
        }
    }

    var hashValue: Int {
        return ref.hashValue
    }

    static func ==(lhs: WebMIDIClient, rhs: WebMIDIClient) -> Bool {
        return lhs.ref == rhs.ref
    }

    static func <(lhs: WebMIDIClient, rhs: WebMIDIClient) -> Bool {
        return lhs.ref < rhs.ref
    }
}

fileprivate struct MIDIInputs {
    typealias Index = Int
    typealias Element = MIDIPortRef

    var startIndex: Index {
        return 0
    }

    var endIndex: Index {
        return MIDIGetNumberOfDestinations()
    }

    subscript (index: Index) -> Element {
//        return MIDI(index)
        fatalError()
    }
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


class WebMIDIManager {
    private let clients: Set<WebMIDIClient> = []

    let inputs: [WebMIDIInput] = []
    let outputs: [WebMIDIOutput] = []

//    var input: WebMIDIInput {
//        return WebMIDIInput()
//    }
//
//    var output: WebMIDIOutput {
//        fatalError()
//    }
}

final class WebMIDIManagerMac: WebMIDIManager {
    let client: WebMIDIClient

    let input: WebMIDIInput
    let output: WebMIDIOutput

    let destinations: [MIDIEndpointRef]
    let sources: [MIDIEndpointRef]

    override init() {
        client = WebMIDIClient()

        input = WebMIDIInput(client: client) {
            _ in
        }

        output = WebMIDIOutput(client: client)
        destinations = Array(MIDIDestinations())
        sources = MIDISources().map { source in

//            MIDIPortConnectSource(MIDIPortRef, MIDIEndpointRef, UnsafeMutableRawPointer?)
//            MIDIPortConnectSource(input.r, <#T##source: MIDIEndpointRef##MIDIEndpointRef#>, <#T##connRefCon: UnsafeMutableRawPointer?##UnsafeMutableRawPointer?#>)
            return source
        }



        super.init()


    }
}







