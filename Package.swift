// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

//let package = Package.init(
//    name: "RelizSDK",
//    platforms: [.iOS(.v13)],
//    products: [
//        .library(
//            name: "RZEvent",
//            targets: ["RZEvent"]
//        ),
//        .library(
//            name: "RZObservableKit",
//            targets: ["RZObservableKit"]
//        ),
//        .library(
//            name: "RZStoreKit",
//            targets: ["RZStoreKit"]
//        ),
//        .library(
//            name: "RZDarkModeKit",
//            targets: ["RZDarkModeKit"]
//        ),
//        .library(
//            name: "RZUIPacKit",
//            targets: ["RZUIPacKit"]
//        ),
//        .library(
//            name: "RZViewBuilder",
//            targets: ["RZViewBuilder"]
//        )
//    ],
//    dependencies: [
//        .package(
//            name: "SwiftyStoreKit",
//            url: "https://github.com/bizz84/SwiftyStoreKit.git",
//            from: "0.16.3"
//        )
//    ],
//    targets: [
//        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
//        // Targets can depend on other targets in this package, and on products in packages this package depends on.
//        .target(
//            name: "RelizKit",
//            dependencies: [],
//            path: "Sources/RelizKit",
//            exclude: ["Info.plist"],
//            cSettings: [
//                .headerSearchPath("Sources/RelizKit")
//            ]
//        ),
//        .target(
//            name: "RZEvent",
//            dependencies: [],
//            exclude: ["Info.plist"]
//        ),
//        .target(
//            name: "RZObservableKit",
//            dependencies: [],
//            exclude: ["Info.plist"]
//        ),
//        .target(
//            name: "RZStoreKit",
//            dependencies: ["SwiftyStoreKit"],
//            exclude: ["Info.plist"]
//        ),
//        .target(
//            name: "RZDarkModeKit",
//            dependencies: [],
//            path: "Sources/RZUIKit/RZDarkModeKit",
//            exclude: ["Info.plist"]
//        ),
//        .target(
//            name: "RZUIPacKit",
//            dependencies: ["RZObservableKit"],
//            path: "Sources/RZUIKit/RZUIPacKit",
//            exclude: ["Info.plist"]
//        ),
//        .target(
//            name: "RZViewBuilder",
//            dependencies: ["RZObservableKit"],
//            path: "Sources/RZUIKit/RZViewBuilder",
//            exclude: ["Info.plist"]
//        )
//    ]
//)

// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package.init(
    name: "RelizSDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "RelizKit",
            targets: ["RelizKit"]
        ),
        .library(
            name: "RZEvent",
            targets: ["RZEvent"]
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
            name: "RZViewBuilder",
            targets: ["RZViewBuilder"]
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
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "RelizKit",
            dependencies: [],
            path: "Sources/RelizKit",
            exclude: ["Info.plist"],
            cSettings: [
                .headerSearchPath("Sources/RelizKi")
            ]
        ),
        .target(
            name: "RZEvent",
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
            name: "RZViewBuilder",
            dependencies: ["RZObservableKit"],
            path: "Sources/RZUIKit/RZViewBuilder",
            exclude: ["Info.plist"]
        )
    ]
)
