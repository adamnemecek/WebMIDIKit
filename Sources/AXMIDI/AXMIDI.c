//
//  AXMIDI.c
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

#include "AXMIDI.h"

Byte MIDIPacketGetValue(
  const MIDIPacket packet,
  int index) {
  return packet.data[index];
}

void MIDIPacketSetValue(
  MIDIPacket* const packet,
  int index,
  Byte value) {
  packet->data[index] = value;
}

MIDIPacket MIDIPacketCreate(
  const Byte* data,
  int dataCount,
  MIDITimeStamp timestamp) {
  MIDIPacket p = {.timeStamp = timestamp, .length = dataCount};
  for (int i = 0; i < dataCount; i++) {
    p.data[i] = data[i];
  }
  return p;
}

const MIDIObjectAddRemoveNotification* MIDINotificationToEndpointNotification(
  const MIDINotification* notification) {
  switch (notification->messageID) {
    case kMIDIMsgObjectAdded:
    case kMIDIMsgObjectRemoved:
      return (const MIDIObjectAddRemoveNotification*)notification;
    default:
      return NULL;
  }
}


/// We need this as opposed to getting it in Swift because we need the pointer
/// which can be safely passed into MIDIPacketNext. This code was written under
/// assumption that one cannot safely make a copy of the packet and then pass
/// it to MIDIPacketNext.

MIDIPacket* MIDIPacketListGetPacketPtr(
  const MIDIPacketList* lst) {
  return (MIDIPacket*)&lst->packet;
}

/// This was roughly adapted from MIKMIDI. Note the double pointer out parameter.

MIDIPacket* MIDIPacketListCreate(
  const Byte* data,
  const UInt32 dataCount,
  const UInt32 numPackets,
  const MIDITimeStamp timestamp,
  MIDIPacketList** out) {

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

void MIDIPacketListFree(
  MIDIPacketList** lst) {
  if (lst == NULL ) { return; }

  free(*lst);
  *lst = NULL;
}

