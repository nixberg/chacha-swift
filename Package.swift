// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "chacha-swift",
    products: [
        .library(
            name: "ChaCha",
            targets: ["ChaCha"]),
    ],
    targets: [
        .target(
            name: "ChaCha"),
        .testTarget(
            name: "ChaChaTests",
            dependencies: ["ChaCha"]),
    ]
)
