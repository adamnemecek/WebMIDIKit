# WebMIDIKit: Simple Swift MIDI library

###__[Want to learn audio synthesis, sound design and making cool sounds in an afternoon? Check out Syntorial!](http://www.syntorial.com/#a_aid=AudioKit)__

## About

### What's MIDI 

[MIDI](https://en.wikipedia.org/wiki/MIDI) is a standard governing music software and music device interconnectivity. It lets you make music by sending data to applications and devices.

### What's WebMIDI

[WebMIDI](https://webaudio.github.io/web-midi-api/) is a browser API standard that brings the MIDI technology to the web. WebMIDI is minimal, it only describes MIDI port selection, receiving data from input ports and sending data to output ports. However, this should cover ~95% of all use cases. [WebMIDI is currently implemented in Chrome & Opera](http://caniuse.com/#feat=midi). 


### What's WebMIDIKit
On macOS/iOS, the native framework for working with MIDI is [CoreMIDI](https://developer.apple.com/reference/coremidi).
CoreMIDI is old and the API is entirely in C (💩). Using it involves a lot of void pointer casting and other unspeakable things. Furthermore, some of the APIs didn't quite survive the transition to Swift and are essentially unusable in Swift (`MIDIPacketList` APIs, I'm looking at you). WebMIDIKit fixes this by implementing the WebMIDI API in Swift.

Furthermore, CoreMIDI is extremely verbose. Selecting an input port and receiving data from it is __~60 lines__ of convoluted Swift code. __WebMIDIKit let's you do it in 1.__ 

Note that despite this, WebMIDIKit is relatively low-level, as for example you are still dealing with arrays of UInt8's (as per the WebMIDI standard). However a higher level library is on the road map, check back right here in a bit.

WebMIDIKit is a part of the [AudioKit](https://githib.com/audiokit/audiokit) project and will eventually replace [AudioKit's MIDI implementation](https://github.com/audiokit/AudioKit/tree/master/AudioKit/Common/MIDI).


##Usage

###Selecting an input port

```swift
import WebMIDIKit

// represents the MIDI session
let midi = MIDIAccess()

// displays all ports in the map and asks the user which port to select
let inputPort = midi.inputs.prompt()
```

###Receiving MIDI events
```swift
// sets the input port's onMIDIMessage callback which gets called when the port receives any MIDI messages
inputPort?.onMIDIMessage = { packet in 
	print(packet)
}

```


###Selecting an output port and sending MIDI packets to it
```swift

// prompt the user to pick an output port and send a MIDI message to it
midi.outputs.prompt().map {

	/// send note on
	$0.send([0x90, 0x60, 0x7f])

	/// send note off
	$0.send([0x80, 0x60, 0x7f], duration: 1000)
}
```

###Looping over inputs

```swift
for (id, port) in midi.inputs {
	print(id, port)
}
```



## Installation

Use Swift Package Manager. The corresponding .Package into your dependencies.
```swift
import PackageDescription

let packet = Package(
	name: "...",
	target: [],
	dependencies: [
		// ...
		.Package(url:"https://github.com/adamnemecek/webmidikit", version: 1)
	]
)
```

## Documentation

###MIDIAccess
Represents the MIDI session. See [spec](https://www.w3.org/TR/webmidi/#midiaccess-interface).

```swift
class MIDIAccess {
	// port maps are dictionary like collections of MIDIInputs or MIDIOutputs that are indexed with the port's id
	var inputs: MIDIInputMap { get }
	var outputs: MIDIOutputMap { get }

	// will be called if the device associated with a port gets connected or disconnected
	var onStateChange: ((MIDIPort) -> ())? = nil { get set }

	init()

}
```

### MIDIPort

See [spec](https://www.w3.org/TR/webmidi/#midiport-interface). Represents the base class of MIDIInput and MIDIOutput.

Note that you don't construct MIDIPorts and it's subclasses yourself, you only get them from the MIDIAccess object. Also note that you are only ever dealt with subclasses (MIDIInput or MIDIOutput) never MIDIPort itself directly.

```
class MIDIPort {

    var id: Int { get }
    var manufacturer: String { get }

    var name: String { get }

	/// .input (for MIDIInput) or .output (for MIDIOutput)
    var type: MIDIPortType { get }

	var version: Int { get }

	/// .connected or .disconnected,
	/// indicates if the port's endpoint is connected or not
	var state: MIDIPortDeviceState { get }

	/// .open, .closed (or pending but that's not used in WebMIDIKit)
    var connection: MIDIPortConnectionState { get }

	/// open the port, is called implicitly when MIDIInput's onMIDIMessage is set or MIDIOutputs' send is called
	func open()

	/// closes the port
	func close()
}
```

### MIDIInput

See [spec](https://www.w3.org/TR/webmidi/#midiinput-interface).

```swift
class MIDIInput: MIDIPort {
	///  will get called when the port receives any messages.
	var onMIDIMessage: ((MIDIPacket) -> ())? = nil
}
```


### MIDIOutput


See [spec](https://www.w3.org/TR/webmidi/#midioutput-interface).
```swift
class MIDIOutput: MIDIPort {
	// send the bytes to port
	func send<S: Sequence>(_ data: S, timestamp: Timestamp = 0) where S.Iterator.Element == UInt8
	
	// clear all scheduled but yet undelivered midi events
	func clear()
}
```




