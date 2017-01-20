
import PackageDescription

let package = Package(
    name: "SwiftBitset",
    targets: [
        Target(name: "Bitset", dependencies: ["CUtil"])
    ]
)
