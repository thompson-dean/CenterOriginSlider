// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CenterOriginSlider",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "CenterOriginSlider",
            targets: ["CenterOriginSlider"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CenterOriginSlider",
            dependencies: []),
        .testTarget(
            name: "CenterOriginSliderTests",
            dependencies: ["CenterOriginSlider"]),
    ]
)
