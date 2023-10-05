// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SweetBool",
    platforms: [
        .macOS(.v10_15), .iOS(.v15), .watchOS(.v9), .tvOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SweetBool",
            type: .dynamic,
            targets: ["SweetBool"]
        ),

        .library(
            name: "SweetPredicate",
            type: .dynamic,
            targets: ["SweetPredicate"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/sloik/AliasWonderland.git", from: "3.6.0"),
        .package(url: "https://github.com/sloik/FuncKeyPath.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SweetBool",
            dependencies: [
                "FuncKeyPath",
            ]),
        .testTarget(
            name: "SweetBoolTests",
            dependencies: [
                "SweetBool",
                "AliasWonderland",
            ]
        ),

        .target(
            name: "SweetPredicate",
            dependencies: [
            ]),
        .testTarget(
            name: "SweetPredicateTests",
            dependencies: [
                "SweetPredicate",
                "AliasWonderland",
            ]
        ),
    ]
)
