// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "EarchSandwichLibrary",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "EarchSandwichLibrary", targets: ["EarchSandwichLibrary"])
    ],
    dependencies: [
        .package(url: "https://github.com/what3words/w3w-swift-wrapper", from: "4.0.0"),
        .package(url: "https://github.com/what3words/w3w-swift-components", from: "3.0.0")
    ],
    targets: [
        .target(name: "EarchSandwichLibrary",
                dependencies: [
                    .product(name: "W3WSwiftApi", package: "w3w-swift-wrapper"),
                    .product(name: "W3WSwiftComponents", package: "w3w-swift-components")
                ],
                path: "Sources"),
        .testTarget(name: "EarchSandwichLibraryTests",
                    dependencies: ["EarchSandwichLibrary"],
                    path: "Tests")
    ]
)
