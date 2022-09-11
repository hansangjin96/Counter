// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Counter",
    platforms: [
        .iOS(.v16)  
    ],
    products: [
        .library(
            name: "Counter",
            targets: ["Counter"]
        ),
    ],
    dependencies: [
        .package(name: "ThirdParty", path: "../ThirdParty")
    ],
    targets: [
        .target(
            name: "Counter",
            dependencies: ["ThirdParty"]
        ),
        .testTarget(
            name: "CounterTests",
            dependencies: ["Counter"]
        ),
    ]
)
