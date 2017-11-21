// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SwiftBitset",
    targets: [
        .target(name: "Bitset", dependencies: []),
        .testTarget(name: "BitsetTests", dependencies: ["Bitset"])
    ]
)
