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

const MIDIObjectAddRemoveNotification* MIDINotificationToEndpointNotification(const MIDINotification* notification) {
  switch (notification->messageID) {
    case kMIDIMsgObjectAdded:
    case kMIDIMsgObjectRemoved:
      return (const MIDIObjectAddRemoveNotification*)notification;
    default:
      return NULL;
  }
}

//MIDIPacketList* MIDIPacketListCreate(const UInt8* data, int count) {
//
//}
#define __out
#define __in

void MIDIPacketListIteratorCreate(const MIDIPacketList* lst, MIDIPacketListIterator* iter) {

}

const MIDIPacketListIterator* MIDIPacketListIteratorNext(const MIDIPacketListIterator* iter) {
  if (true) {
    return iter;
  }
  return NULL;
}

const MIDIPacket* MIDIPacketListIteratorToPacket(const MIDIPacketListIterator* iter) {
  return NULL;
}

//
//const MIDIPacket* MIDIPacketListSliceToPacket(const MIDIPacketListSlice* slice) {
//  return NULL;
//}
//
//void MIDIPacketListSliceCreate(const MIDIPacketList lst, MIDIPacketListSlice* slice) {
//
////  MIDIPacket* current = lst->
//  return NULL;
//}
//
//const MIDIPacketListSlice* MIDIPacketListSliceNext(const MIDIPacketListSlice* slice) {
//  return NULL;
//}

//void Add () {
//  MIDIPacketListAdd(<#MIDIPacketList * _Nonnull pktlist#>, <#ByteCount listSize#>, <#MIDIPacket * _Nonnull curPacket#>, <#MIDITimeStamp time#>, <#ByteCount nData#>, <#const Byte * _Nonnull data#>)
//
//}
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
