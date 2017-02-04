//
//  AXMIDI.c
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//


#include "AXMIDI.h"

struct MIDIPacketListSlice {
  MIDIPacketList *lst;
  int startIndex; // in bytes
  int endIndex;
};

Byte MIDIPacketGetValue(const MIDIPacket packet, int index) {
	return packet.data[index];
}

void MIDIPacketSetValue(MIDIPacket* const packet, int index, Byte value) {
	packet->data[index] = value;
}

MIDIPacket MIDIPacketCreate(MIDITimeStamp timestamp, const Byte* data, int count) {
  MIDIPacket p = {.timeStamp = timestamp, .length = count};
  for (int i = 0; i < count; i++) {
    p.data[i] = data[i];
  }
  return p;
}

void MIDISendExt(MIDIPortRef port, MIDIEndpointRef dest, MIDIPacketList list) {
  MIDISend(port, dest, &list);
}


CF_INLINE MIDIPacket* MIDIPacketNextExt(const MIDIPacket *pkt)
{
//	#if TARGET_CPU_ARM || TARGET_CPU_ARM64
		// MIDIPacket must be 4-byte aligned
//		return	(MIDIPacket *)(((uintptr_t)(&pkt->data[pkt->length]) + 3) & ~3);
//	#else
		return	(MIDIPacket *)&pkt->data[pkt->length];
//	#endif
}

//
// creates a
//
//MIDIPacketList* MIDIPacketListCreate(UInt8 bytes, int count) {
////	if (outPacketList == NULL || commands == nil || [commands count] == 0) {
////		return NO;
////	}
//
////	ByteCount listSize = MIKMIDIPacketListSizeForCommands(commands);
//    ByteCount listSize = 3;
//
////	if (listSize == 0) {
////		return NO;
////	}
//
//	MIDIPacketList *packetList = calloc(1, listSize);
////	if (packetList == NULL) {
////		return NO;
////	}
//
//	MIDIPacket *currentPacket = MIDIPacketListInit(packetList);
//
//	for (NSUInteger i=0; i<[commands count]; i++) {
//		MIKMIDICommand *command = [commands objectAtIndex:i];
//		currentPacket = MIDIPacketListAdd(packetList,
//										  listSize,
//										  currentPacket,
//										  command.midiTimestamp,
//										  [command.data length],
//										  [command.data bytes]);
//		if (!currentPacket && (i < [commands count] - 1)) {
//			free(packetList);
//			return NO;
//		}
//	}
//
//	*outPacketList = packetList;
//	return YES;
//}
