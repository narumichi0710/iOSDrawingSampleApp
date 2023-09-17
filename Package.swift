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
        .library(
            name: "ViewExtension",
            targets: ["ViewExtension"]
        ),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: ["DrawingFeature", "Service", "ViewExtension"],
            path: "Sources/Feature/AppFeature"
        ),
        .target(
            name: "DrawingFeature",
            dependencies: ["Service", "ViewExtension"],
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
        .target(
            name: "ViewExtension",
            dependencies: [],
            path: "Sources/Extension/ViewExtension"
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: ["AppFeature"]),
    ]
)
