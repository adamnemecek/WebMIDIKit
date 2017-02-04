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
  const MIDIPacketList* base;
  /// indexes are in bytes
  int startIndex_;
  int endIndex_;
} MIDIPacketListSlice;


typedef struct {
  const MIDIPacketList* base;

  /// indexes are in bytes
  int startIndex_;
  int endIndex_;
} MIDIPacketListIterator;

/// MIDIPacket is exposed to Swift as a struct with data being represented
/// as a tuple which means we cannot index directly into the data which is
/// annoying AF. These utility functions let us index directly.

inline Byte MIDIPacketGetValue(const MIDIPacket packet, int index);
inline void MIDIPacketSetValue(MIDIPacket* const packet, int index, Byte value);

inline MIDIPacket MIDIPacketCreate(MIDITimeStamp timestamp, const Byte* data, int count);

inline void MIDISendExt(MIDIPortRef port, MIDIEndpointRef dest, MIDIPacketList list);

inline const MIDIObjectAddRemoveNotification* _Nullable
MIDINotificationToEndpointNotification(
  const MIDINotification* _Nonnull notification
);

//inline const MIDIPacket* MIDIPacketListSliceToPacket(const MIDIPacketListSlice* slice);

//inline void MIDIPacketListSliceCreate(const MIDIPacketList lst, MIDIPacketListSlice* slice);
//inline const MIDIPacketListSlice* MIDIPacketListSliceNext(const MIDIPacketListSlice* slice);

inline void
MIDIPacketListIteratorCreate(
  const MIDIPacketList* _Nonnull lst, MIDIPacketListIterator* _Nonnull iter
);

inline const MIDIPacketListIterator* _Nullable
MIDIPacketListIteratorNext(
  const MIDIPacketListIterator* _Nullable slice
);

inline const MIDIPacket* _Nullable
MIDIPacketListIteratorToPacket(
  const MIDIPacketListIterator* _Nullable slice
);



