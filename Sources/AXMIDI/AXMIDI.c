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

MIDIPacket MIDIPacketCreate(const Byte* data, int dataCount, MIDITimeStamp timestamp) {
  MIDIPacket p = {.timeStamp = timestamp, .length = dataCount};
  for (int i = 0; i < dataCount; i++) {
    p.data[i] = data[i];
  }
  return p;
}

void MIDISendExt(MIDIPortRef port, MIDIEndpointRef dest, MIDIPacketList list) {
  MIDISend(port, dest, &list);
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
//#define __out
//#define __in

//MIDIPacketListIterator MIDIPacketListIteratorCreate(MIDIPacketList lst) {
//
//  return (MIDIPacketListIterator){};
//}
//
//MIDIPacketListIterator MIDIPacketListIteratorNext(MIDIPacketListIterator iter) {
////  const int offset = iter->endIndex_ + 1;
////  const MIDIPacket* packet = (const MIDIPacket*)(iter->base->packet + iter->endIndex_ + offset);
//
//  if (true) {
//    return iter;
//  }
//  return (MIDIPacketListIterator){};
//}
//
//const MIDIPacket * MIDIPacketListIteratorToPacket(MIDIPacketListIterator iter) {
//  //this can return null
//  return (MIDIPacket*)&iter;
//}

//inline MIDIPacketList MIDIPacketListCreate(MIDIPacket packet) {
//  
//  return (MIDIPacketList){};
//}

void dump(const Byte *data, int count) {
  for (int i = 0; i < count; i++) {
    printf("data[%d] = %d\n", i, data[i]);
  }
}

const MIDIPacket* MIDIPacketListPacket(const MIDIPacketList* lst) {
  return (MIDIPacket*)lst->packet;
}

//const MIDIPacket * MIDIPacketNextConst(const MIDIPacket* packet) {
//  return MIDIPacketNext(packet);
//}

///
/// This was roughly adated from MIKMIDI. Note the double pointer out parameter.
///

MIDIPacket* MIDIPacketListCreate(
  const Byte* data,
  const UInt32 dataCount,
  const UInt32 numPackets,
  const MIDITimeStamp timestamp,
  MIDIPacketList **out) {

  /// this is the
  const ByteCount hdrSize = offsetof(MIDIPacketList, packet) + offsetof(MIDIPacket, data) * numPackets;
  const ByteCount lstSize = hdrSize + dataCount;

  dump(data, dataCount);

  MIDIPacketList* lst = calloc(1, lstSize);
  MIDIPacket* curPacket = MIDIPacketListInit(lst);
  MIDIPacket* ret = MIDIPacketListAdd(lst, lstSize, curPacket, timestamp, dataCount, data);

  lst->numPackets = numPackets;

  *out = lst;
  return ret;
}


void MIDIPacketListFree(MIDIPacketList** lst) {
  if (lst == NULL ) { return; }

  free(*lst);
  *lst = NULL;
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
