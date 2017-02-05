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


//typedef struct {
//
//  const MIDIPacketList* _Nonnull base;
//  //
//  //  const int count;
//
//  /// offsets are in bytes
//  int startIndex_;
//  int endIndex_;
//} MIDIPacketListIterator;

/// MIDIPacket is exposed to Swift as a struct with data being represented
/// as a tuple which means we cannot index directly into the data which is
/// annoying AF. These utility functions let us index directly.

inline Byte MIDIPacketGetValue(const MIDIPacket packet, int index);
inline void MIDIPacketSetValue(MIDIPacket* const _Nonnull packet, int index, Byte value);

inline MIDIPacket MIDIPacketCreate(const Byte* _Nonnull data, int dataCount, MIDITimeStamp timestamp);

inline void MIDISendExt(MIDIPortRef port, MIDIEndpointRef dest, MIDIPacketList list);


inline const MIDIObjectAddRemoveNotification* _Nullable
MIDINotificationToEndpointNotification(const MIDINotification* _Nonnull notification);

///
/// const MIDIPacket* (_Nullable) = UnsafePointer<MIDIPacket>?
/// const MIDIPacket* _Nonnull = UnsafePointer<MIDIPacket>
///

inline bool MIDIPacketListGetPacket(
  const MIDIPacketList* _Nonnull lst,
  MIDIPacket* _Nonnull packet
);

MIDIPacket* _Nonnull MIDIPacketListGetPacketPtr(
  const MIDIPacketList* _Nonnull lst
);

inline MIDIPacket* _Nullable MIDIPacketListCreate(
  const Byte* _Nonnull data,
  const UInt32 byteCount,
  const UInt32 numPackets,
  const MIDITimeStamp timestamp,
  MIDIPacketList *_Nullable* _Nullable lst
);

void MIDIPacketListFree(MIDIPacketList *_Nonnull* _Nonnull lst);
