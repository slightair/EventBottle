// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "EventBottle",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "EventBottle",
            targets: ["EventBottle"]
        ),
    ],
    targets: [
        .target(
            name: "EventBottle",
            dependencies: []
        ),
        .testTarget(
            name: "EventBottleTests",
            dependencies: ["EventBottle"]
        ),
    ]
)
