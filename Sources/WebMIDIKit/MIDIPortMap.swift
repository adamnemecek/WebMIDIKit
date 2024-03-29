import CoreMIDI

public class MIDIPortMap<Value: MIDIPort>: Collection {
    public typealias Key = Int
    public typealias Index = Dictionary<Key, Value>.Index

    private final var _content: [Key: Value]
    fileprivate final weak var _client: MIDIClient!

    public final var startIndex: Index {
        _content.startIndex
    }

    public final var endIndex: Index {
        _content.endIndex
    }

    public final subscript (key: Key) -> Value? {
        get {
            _content[key]
        }
        set {
            _content[key] = newValue
        }
    }

    public final subscript(index: Index) -> (Key, Value) {
        _content[index]
    }

    public final func index(after i: Index) -> Index {
        _content.index(after: i)
    }

    public func port(with name: String) -> Value? {
        _content.first { $0.value.displayName == name }?.value
    }

    ///
    /// Prompts the user to select a MIDIPort (non-standard)
    ///
    public final func prompt() -> Value? {
        guard let type = first?.1.type else { print("No ports found"); return nil }
        print("Select \(type) by typing the associated number")
        let ports = map { $0.1 }

        for (i, port) in ports.enumerated() {
            print("  #\(i) = \(port)")
        }

        print("Select: ", terminator: "")
        guard let choice = (readLine().flatMap { Int($0) }) else { return nil }
        return ports[safe: choice]
    }

    internal final func add(_ port: Value) -> Value? {
        if port.isVirtual {
            return self[port.id]!
        } else {
            assert(self[port.id] == nil)
            self[port.id] = port
            return port
        }

    }

    internal final func remove(_ endpoint: MIDIEndpoint) -> Value? {
        // disconnect?
        guard let port = self[endpoint] else { assert(false); return nil }
        assert(port.state == .connected)
        self[port.id] = nil
        return port
    }

    //
    fileprivate init(client: MIDIClient, ports: [Value]) {
        self._client = client
        self._content = .init(uniqueKeysWithValues: ports.lazy.map { ($0.id, $0) })
    }

    //
    // todo should this be doing key, value?
    //
    private final subscript (endpoint: MIDIEndpoint) -> Value? {
        _content.first { $0.value.endpoint == endpoint }?.value
    }
}

public final class MIDIInputMap: MIDIPortMap<MIDIInput> {
    internal init(client: MIDIClient) {
        let inputs = MIDISources().map { MIDIInput(client: client, endpoint: $0) }
        super.init(client: client, ports: inputs)
    }

    internal final func add(_ endpoint: MIDIEndpoint) -> MIDIPort? {
        return add(MIDIInput(client: _client, endpoint: endpoint))
    }

    internal final func addVirtual(_ endpoint: MIDIEndpoint) -> VirtualMIDIInput? {
        let port = VirtualMIDIInput(client: _client, endpoint: endpoint)
        _ = add(port as MIDIInput)
        return port
    }
}

public final class MIDIOutputMap: MIDIPortMap<MIDIOutput> {
    internal init(client: MIDIClient) {
        let outputs = MIDIDestinations().map { MIDIOutput(client: client, endpoint: $0) }
        super.init(client: client, ports: outputs)
    }

    internal final func add(_ endpoint: MIDIEndpoint) -> MIDIPort? {
        add(MIDIOutput(client: _client, endpoint: endpoint))
    }

    internal final func addVirtual(_ endpoint: MIDIEndpoint) -> VirtualMIDIOutput? {
        let port = VirtualMIDIOutput(client: _client, endpoint: endpoint)
        _ = add(port as MIDIOutput)
        return port
    }
}

extension MIDIPortMap: CustomStringConvertible, CustomDebugStringConvertible {
    public final var description: String {
        return dump(_content).description
    }
    public var debugDescription: String {
        return "\(self.self)(\(description))"
    }
}

@inline(__always) private
func MIDISources() -> [MIDIEndpoint] {
    return (0..<MIDIGetNumberOfSources()).map {
        .init(ref: MIDIGetSource($0))
    }
}

@inline(__always) private
func MIDIDestinations() -> [MIDIEndpoint] {
    return (0..<MIDIGetNumberOfDestinations()).map {
        .init(ref: MIDIGetDestination($0))
    }
}
