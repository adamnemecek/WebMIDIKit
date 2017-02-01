//
//  AXMIDI.h
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

#import <CoreMIDI/CoreMIDI.h>

//
// Note that marking packet as const 
//
Byte MIDIPacketGetValue(const MIDIPacket packet, int index);
void MIDIPacketSetValue(MIDIPacket* const packet, int index, Byte value);

MIDIPacket MIDIPacketCreate(MIDITimeStamp timestamp, const Byte* data, int count);

//const MIDIPacket* MIDIPacketNext2(const MIDIPacket* packet);
//void MIDIPacketRangeReplace(NSRange range, Byte* with, int count);
//MIDIPacketList MIDIPacketListCreate(const MIDIPacket* lst, int count);
