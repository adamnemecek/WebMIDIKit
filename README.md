# WebMIDIKit: Simplest Swift MIDI library

*!This is a fork of: [WebMIDIKit](https://github.com/adamnemecek/WebMIDIKit) porting it to Swift 5!*

## Installation

Use Swift Package Manager or Xcode 11's new Package integration.

## Usage

### Selecting an input port and receiving MIDI messages from it

```swift
import WebMIDIKit

/// represents the MIDI session
let midi: MIDIAccess = MIDIAccess()

/// prints all MIDI inputs available to the console and asks the user which port they want to select
let inputPort: MIDIInput? = midi.inputs.prompt()

/// Receiving MIDI events 
/// set the input port's onMIDIMessage callback which gets called when the port receives MIDI packets
inputPort?.onMIDIMessage = { (packet: MIDIPacket) in 
	print("received \(packet)")
}

```

### Selecting an output port and sending MIDI packets to it
```swift
/// select an output port
let outputPort: MIDIOutput? = midi.outputs.prompt()

/// send messages to it
outputPort.map {

	/// send a note on message
	/// the bytes are in the normal MIDI message format (https://www.midi.org/specifications/item/table-1-summary-of-midi-message)
	/// i.e. you have to send two events, a note on event and a note off event to play a single note
	/// the format is as follows:
	/// byte0 = message type (0x90 = note on, 0x80 = note off)
	/// byte1 = the note played (0x60 = C8, see http://www.midimountain.com/midi/midi_note_numbers.html)
	/// byte2 = velocity (how loud the note should be 127 (=0x7f) is max, 0 is min)

	let noteOn: [UInt8] = [0x90, 0x60, 0x7f]
	let noteOff: [UInt8] = [0x80, 0x60, 0]

	/// send the note on event
	$0.send(noteOn)

	/// send a note off message 1000 ms (1 second) later
	$0.send(noteOff, offset: 1000)

	/// in WebMIDIKit, you can also chain these
	$0.send(noteOn)
	  .send(noteOff, offset: 1000)
}
```

If the output port you want to select has a corresponding input port you can also do

```swift
let outputPort: MIDIOutput? = midi.output(for: inputPort)
```

Similarly, you can find an input port for the output port.

```swift
let inputPort2: MIDIInput? = midi.input(for: outputPort)
```

### Looping over ports

Port maps are dictionary like collections of `MIDIInputs` or `MIDIOutputs` that are indexed with the port's id. As a result, you cannot index into them like you would into an array (the reason for this being that the endpoints can be added and removed so you cannot reference them by their index).
```swift
for (id, port) in midi.inputs {
	print(id, port)
}
```

## Documentation

### MIDIAccess
Represents the MIDI session. See [spec](https://www.w3.org/TR/webmidi/#midiaccess-interface).

```swift
class MIDIAccess {
	/// collections of MIDIInputs and MIDIOutputs currently connected to the computer
	var inputs: MIDIInputMap { get }
	var outputs: MIDIOutputMap { get }

	/// will be called if a port changes either connection state or port state
	var onStateChange: ((MIDIPort) -> ())? = nil { get set }

	init()
	
	/// given an output, tries to find the corresponding input port
	func input(for port: MIDIOutput) -> MIDIInput?
	
	/// given an input, tries to find the corresponding output port
	/// if you send data to the output port returned, the corresponding input port
	/// will receive it (assuming the `onMIDIMessage` is set)
	func output(for port: MIDIInput) -> MIDIOutput?
}
```

### MIDIPort

See [spec](https://www.w3.org/TR/webmidi/#midiport-interface). Represents the base class of `MIDIInput` and `MIDIOutput`.

Note that you don't construct MIDIPorts nor it's subclasses yourself, you only get them from the `MIDIAccess` object. Also note that you only ever deal with subclasses or `MIDIPort` (`MIDIInput` or `MIDIOutput`) never `MIDIPort` itself.

```swift
class MIDIPort {

	var id: Int { get }
	var manufacturer: String { get }

	var name: String { get }

	/// .input (for MIDIInput) or .output (for MIDIOutput)
	var type: MIDIPortType { get }

	var version: Int { get }

	/// .connected | .disconnected,
	/// indicates if the port's endpoint is connected or not
	var state: MIDIPortDeviceState { get }

	/// .open | .closed
	var connection: MIDIPortConnectionState { get }

	/// open the port, is called implicitly when MIDIInput's onMIDIMessage is set or MIDIOutputs' send is called
	func open()

	/// closes the port
	func close()
}
```

### MIDIInput

Allows for receiving data send to the port.

See [spec](https://www.w3.org/TR/webmidi/#midiinput-interface).

```swift
class MIDIInput: MIDIPort {
	/// set this and it will get called when the port receives messages.
	var onMIDIMessage: ((MIDIPacket) -> ())? = nil { get set }
}
```


### MIDIOutput


See [spec](https://www.w3.org/TR/webmidi/#midioutput-interface).
```swift
class MIDIOutput: MIDIPort {

	/// send data to port, note that unlike the WebMIDI API, 
	/// the last parameter specifies offset from now, when the event should be scheduled (as opposed to absolute timestamp)
	/// the unit remains milliseconds though.
	/// note that right now, WebMIDIKit doesn't support sending multiple packets in the same call, to send multiple packets, you need on call per packet
	func send<S: Sequence>(_ data: S, offset: Timestamp = 0) -> MIDIOutput where S.Iterator.Element == UInt8
	
	// clear all scheduled but yet undelivered midi events
	func clear()
}
```
