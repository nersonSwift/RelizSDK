// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription


let package = Package(
    name: "RelizSDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "RelizKit",
            targets: ["RelizKit"]
        ),
        .library(
            name: "RZEventKit",
            targets: ["RZEventKit"]
        ),
        .library(
            name: "RZObservableKit",
            targets: ["RZObservableKit"]
        ),
        .library(
            name: "RZStoreKit",
            targets: ["RZStoreKit"]
        ),
        .library(
            name: "RZDarkModeKit",
            targets: ["RZDarkModeKit"]
        ),
        .library(
            name: "RZUIPacKit",
            targets: ["RZUIPacKit"]
        ),
        .library(
            name: "RZViewBuilderKit",
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
            dependencies: [],
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RZObservableKit",
            dependencies: [],
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RZStoreKit",
            dependencies: ["SwiftyStoreKit"],
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RZDarkModeKit",
            dependencies: [],
            path: "Sources/RZUIKit/RZDarkModeKit",
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RZUIPacKit",
            dependencies: ["RZObservableKit"],
            path: "Sources/RZUIKit/RZUIPacKit",
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RZViewBuilderKit",
            dependencies: ["RZObservableKit", .target(name: "RZDarkModeKit")],
            path: "Sources/RZUIKit/RZViewBuilderKit",
            exclude: ["Info.plist"]
        )
    ]
)
