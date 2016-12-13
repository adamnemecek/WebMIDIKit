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
    func add(port: MIDIPort)
    func receiveMIDI(port: MIDIPort, packet: MIDIPacketList)
}

protocol Delegate {
    associatedtype Event
    func dispatch(event: Event)
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

final class MIDIManagerMac: MIDIManager {
    let client: MIDIClient

    let input: MIDIInput
    let output: MIDIOutput

    let destinations: [MIDIEndpointRef]
    let sources: [MIDIEndpointRef]

    override init() {
        client = MIDIClient {
            notification in

        }

        input = MIDIInput(client: client) {
            e in

//            self.clients
        }

        output = MIDIOutput(client: client)
        destinations = Array(MIDIDestinations())
        sources = MIDISources().map { source in

//            MIDIPortConnectSource(MIDIPortRef, MIDIEndpointRef, UnsafeMutableRawPointer?)
//            MIDIPortConnectSource(input.r, <#T##source: MIDIEndpointRef##MIDIEndpointRef#>, <#T##connRefCon: UnsafeMutableRawPointer?##UnsafeMutableRawPointer?#>)
            return source
        }



        super.init()


    }
}







