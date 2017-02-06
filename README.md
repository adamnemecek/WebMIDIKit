# WebMIDIKit: Simple MIDI Swift framework

## About

### What's MIDI 

[MIDI](https://en.wikipedia.org/wiki/MIDI) is a standard governing music software and music device interconnectivity. It lets you make music by sending data to applications and devices. 

### What's WebMIDI

WebMIDI is a browser API standard that brings the MIDI technology to the web. WebMIDI is minimal, it only describes port selection, receiving data from input ports and sending data to output ports. However, this should cover ~90% of all use cases. [WebMIDI is currently implemented in Chrome & Opera](http://caniuse.com/#feat=midi).



### What's WebMIDIKit
On macOS/iOS, the native framework for working with MIDI is [CoreMIDI](https://developer.apple.com/reference/coremidi).
CoreMIDI is relatively old and is entirely in C. Using it involves a lot of void pointer casting and other unspeakable things. Furthermore, some of the API didn't quite survive the transition to Swift and is essentially unusable in Swift (MIDIPacketList related APIs, I'm looking at you). 
WebMIDIKit fixes this by implementing the WebMIDI API in Swift. Selecting a port and receiving data from it is ~60 lines of convoluted Swift code with CoreMIDI. WebMIDIKit let's you do it in 1. 


WebMIDIKit is a part of the [AudioKit](https://githib.com/audiokit/audiokit) project and will eventually replace [AudioKit's MIDI implementation](https://github.com/audiokit/AudioKit/tree/master/AudioKit/Common/MIDI).

##Usage

###MIDIAccess
Represents the MIDI session. See [spec](https://www.w3.org/TR/webmidi/#midiaccess-interface).

```swift
class MIDIAccess {
	// port maps are dictionary like collections of MIDIInputs or MIDIOutputs that are indexed with the port's id
	var inputs: MIDIInputMap { get }
	var outputs: MIDIOutputMap { get }

	var onStateChange: ((MIDIPort) -> ())? = nil { get set }

	init()

}
```

```swift
```

###Iterating over inputs

```swift
import WebMIDIKit

// represents the MIDI session
let midi = MIDIAccess()

// prompt displays all ports in the map and asks the user which port to select
let inputPort = midi.inputs.prompt()

// sets the input port's onMIDIMessage callback which gets called when the port receives any MIDI messages
inputPort?.onMIDIMessage = { packet in 
	print(packet)
}

// prompt the user to pick an output port and send a note to it
MIDIAccess().outputs.prompt().map { 

	/// send note on
	$0.send([0x90, 0x60, 0x7f])

	/// send note off
	$0.send([0x80, 0x60, 0x7f], duration: 1000)
}
```

```swift

```



## Installation

Use Swift Package Manager. Add 
```swift
import PackageDescription

let packet = Package(
	name: "...",
	target: [],
	dependencies: [
		.Package(url:"https://github.com/adamnemecek/webmidikit", version: 1)
	]
)
```

## Documentation

### MIDIPort

See [spec](). Note that you don't construct MIDIPorts and it's subclasses yourself, you only get them from the MIDIAccess object.
```
class MIDIPort {
    var id: String { get }
    var manufacturer: String { get }
    var name: String { get }
    var type: MIDIPortType { get }
    var version: String { get }
    var connection: MIDIPortConnectionState { get }
}
```

### MIDIInput

See [spec]().
```swift
class MIDIInput: MIDIPort {
	var onMIDIMessage: ((MIDIPacket) -> ())? = nil
}
```


### MIDIOutputPort


See [spec]().
```swift
class MIDIOutput: MIDIPort {
	func send<S: Sequence>(_ data: S, timestamp: Timestamp = 0) where S.Iterator.Element == UInt8
	func clear()
}
```


# Alternatives

* Mikmidi
* lumi
* gene de lisa
* chromium 

https://cs.chromium.org/chromium/src/media/midi/midi_manager_mac.cc?dr=CSs&sq=package:chromium

 https://cs.chromium.org/chromium/src/third_party/WebKit/Source/modules/webmidi/?type=cs




