#WebMIDIKit

This project is an adapted implementation of the [WebMIDI standard](https://www.w3.org/TR/webmidi/) API in Swift 

* adapted meaning that some liberty was taken . WebMIDIKit is a part of the [AudioKit](https://githib.com/audiokit/audiokit)  

#Why
The original MIDI standard is extremely unwieldy, it's over 900 pages and I'm not sure it's ever been implemented in it's entirety.'  

WebMIDI

#Documentation

## MIDIPort
<!--``` -->
<!--class MIDIPort {-->
<!--      let id: String-->
<!--      let manufacturer: String-->
<!--      let name: String-->
<!--      let type: MIDIPortType-->
<!--      let version: String //?-->
<!--      let connection: MIDIPortConnectionState-->
<!--```-->

### MIDIInput: MIDIPort
MIDIInputPort {
  
} 

### MIDIOutputPort


# Alternatives

* Mikmidi
* lumi
* gene de lisa
* chromium 

https://cs.chromium.org/chromium/src/media/midi/midi_manager_mac.cc?dr=CSs&sq=package:chromium

 https://cs.chromium.org/chromium/src/third_party/WebKit/Source/modules/webmidi/?type=cs



<!--  -->
<!--void MidiManagerMac::ReceiveMidiNotify(const MIDINotification* message) {-->
<!--  DCHECK(client_thread_.task_runner()->BelongsToCurrentThread());-->
<!---->
<!--  if (kMIDIMsgObjectAdded == message->messageID) {-->
<!--    // New device is going to be attached.-->
<!--    const MIDIObjectAddRemoveNotification* notification =-->
<!--        reinterpret_cast<const MIDIObjectAddRemoveNotification*>(message);-->
<!--    MIDIEndpointRef endpoint =-->
<!--        static_cast<MIDIEndpointRef>(notification->child);-->
<!--    if (notification->childType == kMIDIObjectType_Source) {-->
<!--      // Attaching device is an input device.-->
<!--      auto it = source_map_.find(endpoint);-->
<!--      if (it == source_map_.end()) {-->
<!--        MidiPortInfo info = GetPortInfoFromEndpoint(endpoint);-->
<!--        // If the device disappears before finishing queries, MidiPortInfo-->
<!--        // becomes incomplete. Skip and do not cache such information here.-->
<!--        // On kMIDIMsgObjectRemoved, the entry will be ignored because it-->
<!--        // will not be found in the pool.-->
<!--        if (!info.id.empty()) {-->
<!--          uint32_t index = source_map_.size();-->
<!--          source_map_[endpoint] = index;-->
<!--          AddInputPort(info);-->
<!--          MIDIPortConnectSource(-->
<!--              coremidi_input_, endpoint, reinterpret_cast<void*>(endpoint));-->
<!--        }-->
<!--      } else {-->
<!--        SetInputPortState(it->second, PortState::OPENED);-->
<!--      }-->
<!--    } else if (notification->childType == kMIDIObjectType_Destination) {-->
<!--      // Attaching device is an output device.-->
<!--      auto it = std::find(destinations_.begin(), destinations_.end(), endpoint);-->
<!--      if (it == destinations_.end()) {-->
<!--        MidiPortInfo info = GetPortInfoFromEndpoint(endpoint);-->
<!--        // Skip cases that queries are not finished correctly.-->
<!--        if (!info.id.empty()) {-->
<!--          destinations_.push_back(endpoint);-->
<!--          AddOutputPort(info);-->
<!--        }-->
<!--      } else {-->
<!--        SetOutputPortState(it - destinations_.begin(), PortState::OPENED);-->
<!--      }-->
<!--    }-->
<!--  } else if (kMIDIMsgObjectRemoved == message->messageID) {-->
<!--    // Existing device is going to be detached.-->
<!--    const MIDIObjectAddRemoveNotification* notification =-->
<!--        reinterpret_cast<const MIDIObjectAddRemoveNotification*>(message);-->
<!--    MIDIEndpointRef endpoint =-->
<!--        static_cast<MIDIEndpointRef>(notification->child);-->
<!--    if (notification->childType == kMIDIObjectType_Source) {-->
<!--      // Detaching device is an input device.-->
<!--      auto it = source_map_.find(endpoint);-->
<!--      if (it != source_map_.end())-->
<!--        SetInputPortState(it->second, PortState::DISCONNECTED);-->
<!--    } else if (notification->childType == kMIDIObjectType_Destination) {-->
<!--      // Detaching device is an output device.-->
<!--      auto it = std::find(destinations_.begin(), destinations_.end(), endpoint);-->
<!--      if (it != destinations_.end())-->
<!--        SetOutputPortState(it - destinations_.begin(), PortState::DISCONNECTED);-->
<!--    }-->
<!--  }-->
<!--}-->

