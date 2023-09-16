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
        .library(
            name: "Repository",
            targets: ["Repository"]
        ),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: ["DrawingFeature", "Service"],
            path: "Sources/Feature/AppFeature"
        ),
        .target(
            name: "DrawingFeature",
            dependencies: ["Service"],
            path: "Sources/Feature/DrawingFeature"
        ),
        .target(
            name: "Service",
            dependencies: ["Repository"],
            path: "Sources/Core/Service"
        ),
        .target(
            name: "Repository",
            dependencies: ["Local", "Network"],
            path: "Sources/Core/Repository"
        ),
        .target(
            name: "Local",
            dependencies: [],
            path: "Sources/Core/Local"
        ),
        .target(
            name: "Network",
            dependencies: [],
            path: "Sources/Core/Network"
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: ["AppFeature"]),
    ]
)
