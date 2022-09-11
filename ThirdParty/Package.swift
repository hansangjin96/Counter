// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ThirdParty",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "ThirdParty",
            targets: ["ThirdParty"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "0.40.1")
    ],
    targets: [
        .target(
            name: "ThirdParty",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "ThirdPartyTests",
            dependencies: ["ThirdParty"]
        ),
    ]
)
