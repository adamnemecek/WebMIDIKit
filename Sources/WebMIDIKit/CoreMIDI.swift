import CoreMIDI

extension MIDIObjectAddRemoveNotification: CustomStringConvertible {

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

// @inline(__always) internal
// func AudioGetCurrentMIDITimeStamp(offset: Double = 0) -> MIDITimeStamp {
//    let _offset = AudioConvertNanosToHostTime(UInt64(offset * 1000000))
//    return AudioGetCurrentHostTime() + _offset
// }

@inline(__always) internal
func OSAssert(_ err: OSStatus, function: String = #function) {
    assert(err == noErr, "Error \(Error(err: err)) (osstatus: \(err)) in \(function)")
}

public enum Error: Swift.Error, Equatable {
    case invalidClient,
         invalidPort,
         wrongEndpointType,
         noConnection,
         unknownEndpoint,
         unknownProperty,
         wrongPropertyType,
         noCurrentSetup,
         messageSendErr,
         serverStartErr,
         setupFormatErr,
         wrongThread,
         objectNotFound,
         idNotUnique,
         notPermitted

    public init(err: OSStatus) {
        switch err {
        case kMIDIInvalidClient: self = .invalidClient
        case kMIDIInvalidPort: self = .invalidPort
        case kMIDIWrongEndpointType: self = .wrongEndpointType
        case kMIDINoConnection: self = .noConnection
        case kMIDIUnknownEndpoint: self = .unknownEndpoint
        case kMIDIUnknownProperty: self = .unknownProperty
        case kMIDIWrongPropertyType: self = .wrongPropertyType
        case kMIDINoCurrentSetup: self = .noCurrentSetup
        case kMIDIMessageSendErr: self = .messageSendErr
        case kMIDIServerStartErr: self = .serverStartErr
        case kMIDISetupFormatErr: self = .setupFormatErr
        case kMIDIWrongThread: self = .wrongThread
        case kMIDIObjectNotFound: self = .objectNotFound
        case kMIDIIDNotUnique: self = .idNotUnique
        case kMIDINotPermitted: self = .notPermitted
        default: fatalError("unrecognized error \(err)")
        }
    }

    public var rawValue: OSStatus {
        switch self {
        case .invalidClient: return kMIDIInvalidClient
        case .invalidPort: return kMIDIInvalidPort
        case .wrongEndpointType: return kMIDIWrongEndpointType
        case .noConnection: return kMIDINoConnection
        case .unknownEndpoint: return kMIDIUnknownEndpoint
        case .unknownProperty: return kMIDIUnknownProperty
        case .wrongPropertyType: return kMIDIWrongPropertyType
        case .noCurrentSetup: return kMIDINoCurrentSetup
        case .messageSendErr: return kMIDIMessageSendErr
        case .serverStartErr: return kMIDIServerStartErr
        case .setupFormatErr: return kMIDISetupFormatErr
        case .wrongThread: return kMIDIWrongThread
        case .objectNotFound: return kMIDIObjectNotFound
        case .idNotUnique: return kMIDIIDNotUnique
        case .notPermitted: return kMIDINotPermitted
        }
    }
}

func MIDIObjectAllocUniqueID() -> MIDIUniqueID {
while true {
        let uniqueID = MIDIUniqueID.random(in: MIDIUniqueID.min..<MIDIUniqueID.max)
        var ref: MIDIObjectRef = 0
        var type: MIDIObjectType = .other

        let err = MIDIObjectFindByUniqueID(uniqueID, &ref, &type)
        //
        // this means that the object was not found and therefore the id is free
        //
        if err == Error.objectNotFound.rawValue {
            return uniqueID
        }
    }
    fatalError("will not get here")
}
