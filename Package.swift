// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Sunlight",
    products: [
        .library(name: "Sunlight", targets: ["Sunlight"]),
    ],
    dependencies: [

    ],
    targets: [
        .target(
            name: "Sunlight",
            dependencies: [],
            path: "./Sources/"),
        .testTarget(
            name: "SunlightTests",
            dependencies: ["Sunlight"]),
    ]
)
