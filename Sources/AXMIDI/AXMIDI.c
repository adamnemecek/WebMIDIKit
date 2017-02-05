//
//  AXMIDI.c
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//


#include "AXMIDI.h"


/// we need this because otherwise

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

const MIDIPacket* MIDIPacketNextConst(const MIDIPacket * current) {
  return MIDIPacketNext(current);
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

MIDIPacket* MIDIPacketListGetPacketPtr(
  const MIDIPacketList* lst
) {
  return (MIDIPacket*)&lst->packet;
}

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
  const ByteCount hdrSize = offsetof(MIDIPacketList, packet) +
                            offsetof(MIDIPacket, data) * numPackets;
  const ByteCount lstSize = hdrSize + dataCount;

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

