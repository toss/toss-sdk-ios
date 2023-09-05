// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TossSDK-iOS",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "TossSDK",
            targets: ["TossLogin", "TossFoundation"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "TossFoundation",
            dependencies: []
        ),
        .target(
            name: "TossLogin",
            dependencies: [
                .target(name: "TossFoundation")
            ]
        )
    ]
)
