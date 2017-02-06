# WebMIDIKit: Simple MIDI Swift framework

## About

### What's MIDI 

[MIDI](https://en.wikipedia.org/wiki/MIDI) is a standard governing music software and music device interconnectivity. It lets you make music by sending data to applications and devices. 

### What's WebMIDI

WebMIDI is a browser API standard that brings the MIDI technology to the web. WebMIDI is minimal, it only describes port selection, receiving data from an input port and sending data to an output port (but this should cover ~90% of all use cases). [It's currently implemented in Chrome & Opera](http://caniuse.com/#feat=midi).



### What's WebMIDIKit
On macOS/iOS, the native framework for working with MIDI is [CoreMIDI](https://developer.apple.com/reference/coremidi).
CoreMIDI is relatively old and is entirely in C. Using it involves a lot of void pointer casting and other unspeakable things. Furthermore, some of the API didn't quite survive the transition to Swift and is essentially unusable in Swift (MIDIPacketList related APIs, I'm looking at you). 
WebMIDIKit fixes this by implementing the WebMIDI API in Swift. Selecting a port and receiving data from it is ~60 lines of convoluted Swift code. WebMIDIKit let's you do it in 1. 


Note that WebMIDIKit is a part of the [AudioKit](https://githib.com/audiokit/audiokit) project.

##Usage

###MIDIAccess
See [spec](https://www.w3.org/TR/webmidi/#midiaccess-interface).
```swift
class MIDIAccess {
	// port maps are dictionary like collections
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

// displays all inputs and asks the user which to select
let inputPort = midi.inputs.prompt()!

// sets the input port's callback that gets called when MIDI messages are received
inputPort.onMIDIMessage = { packet in 
	print(packet) }
}

/// prompt displays all inputs (in this case) and returns the selected input port
/// which we then send the data to

MIDIAccess().inputs.prompt().map { 

	/// note on
	$0.send([0x90, 0x60, 0x7f])

	/// note off
	$0.send([0x80, 0x60, 0x7f], 1000)
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




