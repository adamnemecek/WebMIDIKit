//
//  AXMIDI.c
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

#include "AXMIDI.h"

Byte MIDIPacketGetValue(const MIDIPacket packet, int index) {
	return packet.data[index];
}

void MIDIPacketSetValue(MIDIPacket* const packet, int index, Byte value) {
	packet->data[index] = value;
}

MIDIPacket MIDIPacketCreate(MIDITimeStamp timestamp, const Byte* data, int count) {
  MIDIPacket p = {.timeStamp = timestamp, .length = count};
  //  memcpy(p.data, data, count/(sizeof(void*)/sizeof(Byte)));
  //todo memcpy
  for (int i = 0; i < count; i++) {
    p.data[i] = data[i];
  }

  return p;
}

//const MIDIPacket* MIDIPacketNext2(const MIDIPacket* packet) {
//  return MIDIPacketNext(packet);
//}

