// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Favorite",
    platforms: [
        .iOS(.v16)  
    ],
    products: [
        .library(
            name: "Favorite",
            targets: ["Favorite"]
        ),
    ],
    dependencies: [
        .package(name: "ThirdParty", path: "../ThirdParty")
    ],
    targets: [
        .target(
            name: "Favorite",
            dependencies: ["ThirdParty"]
        ),
        .testTarget(
            name: "FavoriteTests",
            dependencies: ["Favorite"]
        ),
    ]
)
