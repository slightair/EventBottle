// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "EventBottle",
    products: [
        .library(
            name: "EventBottle",
            targets: ["EventBottle"]
        ),
    ],
    targets: [
        .target(
            name: "EventBottle",
            dependencies: [],
            exclude: ["EventViewer"]
        ),
        .testTarget(
            name: "EventBottleTests",
            dependencies: ["EventBottle"]
        ),
    ]
)
