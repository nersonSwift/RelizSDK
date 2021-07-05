// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription


let package = Package(
    name: "RelizSDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "RZEventKit",
            type: .dynamic,
            targets: ["RZEventKit"]
        ),
        .library(
            name: "RZObservableKit",
            type: .dynamic,
            targets: ["RZObservableKit"]
        ),
        .library(
            name: "RZStoreKit",
            type: .dynamic,
            targets: ["RZStoreKit"]
        ),
        .library(
            name: "RZDarkModeKit",
            type: .dynamic,
            targets: ["RZDarkModeKit"]
        ),
        .library(
            name: "RZUIPacKit",
            type: .dynamic,
            targets: ["RZUIPacKit"]
        ),
        .library(
            name: "RZViewBuilderKit",
            type: .dynamic,
            targets: ["RZViewBuilderKit"]
        )
    ],
    dependencies: [
        .package(
            name: "SwiftyStoreKit",
            url: "https://github.com/bizz84/SwiftyStoreKit.git",
            from: "0.16.3"
        )
    ],
    targets: [
        .target(
            name: "RelizKit",
            dependencies: [],
            path: "Sources/RelizKit",
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RZEventKit",
            dependencies: [.target(name: "RelizKit")],
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RZObservableKit",
            dependencies: [.target(name: "RelizKit")],
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RZStoreKit",
            dependencies: ["SwiftyStoreKit", .target(name: "RelizKit")],
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RZDarkModeKit",
            dependencies: [.target(name: "RelizKit")],
            path: "Sources/RZUIKit/RZDarkModeKit",
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RZUIPacKit",
            dependencies: ["RZObservableKit", .target(name: "RelizKit")],
            path: "Sources/RZUIKit/RZUIPacKit",
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RZViewBuilderKit",
            dependencies: ["RZObservableKit", .target(name: "RelizKit"), .target(name: "RZDarkModeKit")],
            path: "Sources/RZUIKit/RZViewBuilderKit",
            exclude: ["Info.plist"]
        )
    ]
)
