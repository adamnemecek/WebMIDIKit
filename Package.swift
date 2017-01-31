import PackageDescription

let package = Package(
    name: "WebMIDIKit",
    targets: [
      Target(name: "WebMIDIKit", dependencies: ["AXMIDI"])
    ]
)
