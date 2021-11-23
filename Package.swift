// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	
    name: "WebMIDIKit",
	
	platforms: [.macOS(.v10_11)],
//    platforms: [.macOS(.v11)]
	
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
            dependencies: ["WebMIDIKit"]),
    ]
	
)
