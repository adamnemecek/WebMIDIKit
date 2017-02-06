# WebMIDIKit: Simple MIDI Swift framework

## About

### What's MIDI 

[MIDI](https://en.wikipedia.org/wiki/MIDI) is a standard governing music software and music device interconnectivity. It lets you make music by sending data to applications and devices. It's currently implemented in Chrome, Firefox, Opera

### What's WebMIDI

WebMIDI is a browser API standard that brings the MIDI technology to the web. WebMIDI is minimal, it only describes port selection, receiving data from an input port and sending data to an output port (but this should cover ~90% of all use cases).


### What's WebMIDIKit
On macOS/iOS, the native framework for working with MIDI is [CoreMIDI](https://developer.apple.com/reference/coremidi).
CoreMIDI is relatively old, is entirely in C. Using it involves a lot of void pointer casting and other unspeakable things. Furthermore, some of the API didn't quite survive the transition to Swift and is essentially unusable (MIDIPacketList related APIs, I'm looking at you). 
WebMIDIKit fixes this by implementing the WebMIDI API in Swift. Using CoreMIDI, selecting a port and receiving data from it is ~60 lines of convoluted Swift code. WebMIDIKit let's you do it in 1.


Note that WebMIDIKit is a part of the [AudioKit](https://githib.com/audiokit/audiokit) project.

#Usage

###MIDIAccess

```swift
class MIDIAccess 
```

##Iterating over inputs

```swift
import WebMIDIKit


let midi = MIDIAccess()

/// signs up for observation
MIDIAccess().inputs.prompt().map { $0.onMIDIMessage = { packet in print(packet) } }

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



# Installation

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

}
```


### MIDIOutputPort


See [spec]().
```swift
class MIDIOutput: MIDIPort {

}
```


# Alternatives

* Mikmidi
* lumi
* gene de lisa
* chromium 

https://cs.chromium.org/chromium/src/media/midi/midi_manager_mac.cc?dr=CSs&sq=package:chromium

 https://cs.chromium.org/chromium/src/third_party/WebKit/Source/modules/webmidi/?type=cs




