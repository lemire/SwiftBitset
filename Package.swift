
import PackageDescription

let package = Package(
    name: "Bitset",
    targets: [
        Target(name: "Bitset", dependencies: ["CUtil"])
    ]
)
