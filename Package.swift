// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WebMIDIKit",
    products: [
        .library(
            name: "WebMIDIKit",
            targets: ["WebMIDIKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "WebMIDIKit",
            dependencies: []),
        .testTarget(
            name: "WebMIDIKitTests",
            dependencies: []),
    ]
)
