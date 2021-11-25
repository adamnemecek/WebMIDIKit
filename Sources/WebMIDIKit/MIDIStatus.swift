import CoreMIDI

public enum MIDIStatus: Int {
    /// Default empty status
    case nothing = 0
    /// Note off is something resembling a keyboard key release
    case noteOff = 8
    /// Note on is triggered when a new note is created, or a keyboard key press
    case noteOn = 9
    /// Polyphonic aftertouch is a rare MIDI control on controllers in which
    /// every key has separate touch sensing
    case polyphonicAftertouch = 10
    /// Controller changes represent a wide range of control types including volume,
    /// expression, modulation and a host of unnamed controllers with numbers
    case controllerChange = 11
    /// Program change messages are associated with changing the basic character of the sound preset
    case programChange = 12
    /// A single aftertouch for all notes on a given channel
    /// (most common aftertouch type in keyboards)
    case channelAftertouch = 13
    /// A pitch wheel is a common keyboard control that allow for a pitch to be
    /// bent up or down a given number of semitones
    case pitchWheel = 14
    /// System commands differ from system to system
    case systemCommand = 15

    init?(packet: MIDIPacket) {
      self.init(rawValue: Int(packet.data.0 >> 4))
    }
}
