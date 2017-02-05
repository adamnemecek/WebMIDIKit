//
//  AXMIDI.h
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

#pragma once

#import <CoreMIDI/CoreMIDI.h>
#import <CoreFoundation/CoreFoundation.h>


typedef struct {

  const MIDIPacketList* _Nonnull base;
  //
  //  const int count;

  /// offsets are in bytes
  int startIndex_;
  int endIndex_;
} MIDIPacketListIterator;

/// MIDIPacket is exposed to Swift as a struct with data being represented
/// as a tuple which means we cannot index directly into the data which is
/// annoying AF. These utility functions let us index directly.

inline Byte MIDIPacketGetValue(const MIDIPacket packet, int index);
inline void MIDIPacketSetValue(MIDIPacket* const _Nonnull packet, int index, Byte value);

inline MIDIPacket MIDIPacketCreate(MIDITimeStamp timestamp, const Byte* _Nonnull data, int count);

inline void MIDISendExt(MIDIPortRef port, MIDIEndpointRef dest, MIDIPacketList list);


inline const MIDIObjectAddRemoveNotification* _Nullable
MIDINotificationToEndpointNotification(
                                       const MIDINotification* _Nonnull notification
                                       );

//inline MIDIPacketList MIDIPacketListCreate(MIDIPacket packet);

MIDIPacketListIterator
MIDIPacketListIteratorCreate(
                             const MIDIPacketList lst
                             );

MIDIPacketListIterator
MIDIPacketListIteratorNext(
                           MIDIPacketListIterator iter
                           );

inline const MIDIPacket* _Nullable
MIDIPacketListIteratorToPacket(
                               MIDIPacketListIterator iter
                               );



inline void MIDIPacketListCreate(
  const Byte* _Nonnull data,
  const int count,
  const int packets,
  const MIDITimeStamp timestamp,
  MIDIPacketList **out);

void MIDIPacketListFree(MIDIPacketList** lst);
