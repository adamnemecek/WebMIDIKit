//
//  AXMIDI.h
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

#import <CoreMIDI/CoreMIDI.h>

Byte MIDIPacketGetValue(const MIDIPacket packet, int index);
void MIDIPacketSetValue(MIDIPacket* const packet, int index, Byte value);

MIDIPacket MIDIPacketCreate(MIDITimeStamp timestamp, const Byte* data, int count);
