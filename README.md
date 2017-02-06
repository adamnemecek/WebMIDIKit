# WebMIDIKit: Simple MIDI Swift framework

WebMIDIKit is the easiest Swift framework for working with MIDI

## Info

### What's MIDI 

[MIDI](https://en.wikipedia.org/wiki/MIDI) is a standard governing music software and music device interconnectivity. 

### What's WebMIDI

WebMIDI is an Web API standard that brings the MIDI technology to the browser. This is straightforward, fundamentally it governs selecting a port, sending data to an output port and receiving data from an input port (this should cover maybe like ~90% of all uses cases).


### Where does WebMIDIKit come in?
On macOS/iOS, the native framework for working with MIDI is [CoreMIDI](https://developer.apple.com/reference/coremidi).
This framework is relatively old and involves a lot of void pointer casting and other unspeakable things. Furthermore, some of this API further deteriorated during the transition to Swift. WebMIDIKit tries to fix that by implementing the webMIDI API in Swift. 


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




