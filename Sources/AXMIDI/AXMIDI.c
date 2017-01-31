//
//  AXMIDI.c
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

#include "AXMIDI.h"

uint8 MIDIPacketGetValue(MIDIPacket packet, int index) {
	return packet.data[index];
}

void MIDIPacketSetValue(MIDIPacket * const packet, int index, uint8 value) {
	packet->data[index] = value;
}
