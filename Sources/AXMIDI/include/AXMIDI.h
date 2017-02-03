//
//  AXMIDI.h
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

#pragma once

#import <CoreMIDI/CoreMIDI.h>

inline Byte MIDIPacketGetValue(const MIDIPacket packet, int index);
inline void MIDIPacketSetValue(MIDIPacket* const packet, int index, Byte value);
inline MIDIPacket MIDIPacketCreate(MIDITimeStamp timestamp, const Byte* data, int count);
inline void MIDISendExt(MIDIPortRef port, MIDIEndpointRef dest, MIDIPacketList list);
