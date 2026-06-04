// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BlankSlate",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "BlankSlate", targets: ["BlankSlate"])
    ],
    targets: [
        .target(
            name: "BlankSlate",
            path: "Sources",
            resources: [.copy("PrivacyInfo.xcprivacy")],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "BlankSlateTests",
            dependencies: ["BlankSlate"],
            path: "Tests",
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
    ]
)
