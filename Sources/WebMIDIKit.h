//
//  WebMIDIKit.h
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

#pragma once

uint8 MIDIPacketGetValue(MIDIPacket *packet, int idx);
void MIDIPacketSetValue(MIDIPacket *packet, int idx, uint8 value);

