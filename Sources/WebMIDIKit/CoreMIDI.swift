import AudioToolbox

extension MIDIObjectAddRemoveNotification : CustomStringConvertible {

    public var description: String {
        return "message\(messageID)"
    }

    internal init?(ptr: UnsafePointer<MIDINotification>) {
        switch ptr.pointee.messageID {
        case .msgObjectAdded, .msgObjectRemoved:
            self = UnsafeRawPointer(ptr).assumingMemoryBound(to: MIDIObjectAddRemoveNotification.self).pointee
        default:
            return nil
        }
    }
}

//@inline(__always) internal
//func AudioGetCurrentMIDITimeStamp(offset: Double = 0) -> MIDITimeStamp {
//    let _offset = AudioConvertNanosToHostTime(UInt64(offset * 1000000))
//    return AudioGetCurrentHostTime() + _offset
//}

@inline(__always) internal
func OSAssert(_ err: OSStatus, function: String = #function) {
    assert(err == noErr, "Error \(Error(err: err)) (osstatus: \(err)) in \(function)")
}


public enum Error: Swift.Error, Equatable  {
    case InvalidClient,
         InvalidPort,
         WrongEndpointType,
         NoConnection,
         UnknownEndpoint,
         UnknownProperty,
         WrongPropertyType,
         NoCurrentSetup,
         MessageSendErr,
         ServerStartErr,
         SetupFormatErr,
         WrongThread,
         ObjectNotFound,
         IDNotUnique,
         NotPermitted

    public init(err: OSStatus) {
        switch err {
        case kMIDIInvalidClient: self = .InvalidClient
        case kMIDIInvalidPort: self = .InvalidPort
        case kMIDIWrongEndpointType: self = .WrongEndpointType
        case kMIDINoConnection: self = .NoConnection
        case kMIDIUnknownEndpoint: self = .UnknownEndpoint
        case kMIDIUnknownProperty: self = .UnknownProperty
        case kMIDIWrongPropertyType: self = .WrongPropertyType
        case kMIDINoCurrentSetup: self = .NoCurrentSetup
        case kMIDIMessageSendErr: self = .MessageSendErr
        case kMIDIServerStartErr: self = .ServerStartErr
        case kMIDISetupFormatErr: self = .SetupFormatErr
        case kMIDIWrongThread: self = .WrongThread
        case kMIDIObjectNotFound: self = .ObjectNotFound
        case kMIDIIDNotUnique: self = .IDNotUnique
        case kMIDINotPermitted: self = .NotPermitted
        default: fatalError("unrecognized error \(err)")
        }
    }

    public var rawValue: OSStatus {
        switch self {
        case .InvalidClient: return kMIDIInvalidClient
        case .InvalidPort: return kMIDIInvalidPort
        case .WrongEndpointType: return kMIDIWrongEndpointType
        case .NoConnection: return kMIDINoConnection
        case .UnknownEndpoint: return kMIDIUnknownEndpoint
        case .UnknownProperty: return kMIDIUnknownProperty
        case .WrongPropertyType: return kMIDIWrongPropertyType
        case .NoCurrentSetup: return kMIDINoCurrentSetup
        case .MessageSendErr: return kMIDIMessageSendErr
        case .ServerStartErr: return kMIDIServerStartErr
        case .SetupFormatErr: return kMIDISetupFormatErr
        case .WrongThread: return kMIDIWrongThread
        case .ObjectNotFound: return kMIDIObjectNotFound
        case .IDNotUnique: return kMIDIIDNotUnique
        case .NotPermitted: return kMIDINotPermitted
        }
    }
}
