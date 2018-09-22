// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SwiftBitset",
    products: [
        .library(name: "Bitset", targets: ["Bitset"]),
        .library(name: "BitsetDynamic", type: .dynamic , targets: ["Bitset"]),
    ],
    dependencies: [],
    targets: [
    .target(
        name: "Bitset",
        dependencies: []
    ),
    .testTarget(
        name: "BitsetTests",
        dependencies:["Bitset"]
    )
    ]
)
