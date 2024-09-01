// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "blog-ios",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "AppCore", targets: ["AppCore"]),
        .library(name: "Data", targets: ["Data"]),
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "Presentation", targets: ["Presentation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1")),
    ],
    targets: [
        .target(
            name: "AppCore",
            dependencies: [
                "Data",
                "Domain",
                "Networking",
                "Presentation",
            ]
        ),
        .target(
            name: "Domain",
            dependencies: []
        ),
        .target(
            name: "Presentation",
            dependencies: ["Domain"]
        ),
        .target(
            name: "Data",
            dependencies: ["Domain", "Networking"]
        ),
        .target(
            name: "Networking",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
            ]
        ),
    ]
)
