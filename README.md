# WebMIDIKit: Simple MIDI Swift framework

## About

### What's MIDI 

[MIDI](https://en.wikipedia.org/wiki/MIDI) is a standard governing music software and music device interconnectivity. It lets you make music by sending data to applications and devices.

### What's WebMIDI

WebMIDI is a browser API standard that brings the MIDI technology to the web. WebMIDI is minimal, it only describes port selection, receiving data from an input port and sending data to an output port (but this should cover ~90% of all use cases).


### What's WebMIDIKit
On macOS/iOS, the native framework for working with MIDI is [CoreMIDI](https://developer.apple.com/reference/coremidi).
This framework is relatively old, entirely in C and using it involves a lot of void pointer casting and other unspeakable things. Furthermore, some of the API didn't quite make the jump to Swift and is essentially unusable  
WebMIDIKit fixes this by implementing the webMIDI API in Swift. 


CoreMIDI is an extremely unwieldy API, 
WebMIDIKit is a part of the [AudioKit](https://githib.com/audiokit/audiokit)  

#Usage

##Iterating over inputs

```swift
import WebMIDIKit

let midi = MIDIAccess()
for input in midi.inputs {
	print(input)
}

```

```swift

```





# Installation

Use Swift Package Manager. Add 
```swift
import PackageDescription

let packet = Package(
	name: "<PROJECTNAME>",
	target: [],
	dependencies: [
		.Package(url:"")
	]
)
```

# bad code
* https://developer.apple.com/library/content/qa/qa1374/_index.html#//apple_ref/doc/uid/DTS10003394
* http://stackoverflow.com/questions/4058790/coremidi-framework-sending-midi-commands
* if you manage to find a correct use of MIDIPacketList
WebMIDI

#Documentation

https://github.com/cwilso/WebMIDIAPIShim/blob/gh-pages/src/midi_output.js

## MIDIPort
<!--``` -->
<!--class MIDIPort {-->
<!--      let id: String-->
<!--      let manufacturer: String-->
<!--      let name: String-->
<!--      let type: MIDIPortType-->
<!--      let version: String //?-->
<!--      let connection: MIDIPortConnectionState-->
<!--```-->

# Extensions

### MIDIInput: MIDIPort
MIDIInputPort {
  
} 

### MIDIOutputPort


# Alternatives

* Mikmidi
* lumi
* gene de lisa
* chromium 

https://cs.chromium.org/chromium/src/media/midi/midi_manager_mac.cc?dr=CSs&sq=package:chromium

 https://cs.chromium.org/chromium/src/third_party/WebKit/Source/modules/webmidi/?type=cs




