// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "iOSDrawingSampleApp",
    platforms: [.iOS(.v15), .macOS(.v11)],
    products: [
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]
        ),
        .library(
            name: "DrawingFeature",
            targets: ["DrawingFeature"]
        ),
        .library(
            name: "Service",
            targets: ["Service"]
        ),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "DrawingFeature",
                "Service"
            ],
            path: "Sources/Feature/AppFeature"
        ),
        .target(
            name: "DrawingFeature",
            dependencies: ["Service"],
            path: "Sources/Feature/DrawingFeature"
        ),
        .target(
            name: "Service",
            dependencies: [],
            path: "Sources/Core/Service"
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: ["AppFeature"]),
    ]
)
