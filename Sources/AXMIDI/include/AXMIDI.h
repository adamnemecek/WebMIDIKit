//
//  AXMIDI.h
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

#pragma once

#import <CoreMIDI/CoreMIDI.h>
//
// Note that marking packet as const 
//
inline Byte MIDIPacketGetValue(const MIDIPacket packet, int index);
inline void MIDIPacketSetValue(MIDIPacket* const packet, int index, Byte value);

inline MIDIPacket MIDIPacketCreate(MIDITimeStamp timestamp, const Byte* data, int count);

//const MIDIPacket* MIDIPacketNext2(const MIDIPacket* packet);
//void MIDIPacketRangeReplace(NSRange range, Byte* with, int count);
//MIDIPacketList MIDIPacketListCreate(const MIDIPacket* lst, int count);
