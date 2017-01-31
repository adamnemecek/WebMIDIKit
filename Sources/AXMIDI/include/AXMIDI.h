//
//  AXMIDI.h
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

#import <CoreMIDI/CoreMIDI.h>

#ifndef uint8
  typedef unsigned char uint8;
#endif

uint8 MIDIPacketGetValue(const MIDIPacket packet, int index);
void MIDIPacketSetValue(MIDIPacket* const packet, int index, uint8 value);
