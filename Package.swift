// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "RelizSDK",
    platforms: [.iOS(.v13)],
    products: [
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
//        .library(
//            name: "RZDarkModeKit",
//            targets: ["RZDarkModeKit"]
//        ),
//        .library(
//            name: "RZUIPacKit",
//            targets: ["RZUIPacKit"]
//        ),
//        .library(
//            name: "RZViewBuilderKit",
//            targets: ["RZViewBuilderKit"]
//        ),
        .library(
            name: "RelizKit",
            targets: ["RelizKit"]
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
            dependencies: [
//                .target(name: "RZEventKit"),
//                .target(name: "RZObservableKit"),
//                .target(name: "RZStoreKit")
//                .target(name: "RZDarkModeKit"),
//                .target(name: "RZUIPacKit"),
//                .target(name: "RZViewBuilderKit")
            ],
            path: "Sources/RelizKit",
            exclude: ["Info.plist"]
            //linkerSettings: [.linkedLibrary("RZEventKit"), .linkedLibrary("RZObservableKit"), .linkedLibrary("RZStoreKit"), .linkedLibrary("RZDarkModeKit"), .linkedLibrary("RZUIPacKit"), .linkedLibrary("RZViewBuilderKit")]
        ),
        .target(
            name: "RZEventKit",
            //dependencies: [.target(name: "RelizKit")],
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RZObservableKit",
            //dependencies: [.target(name: "RelizKit")],
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RZStoreKit",
            dependencies: ["SwiftyStoreKit"],// .target(name: "RelizKit")],
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RZDarkModeKit",
            //dependencies: [.target(name: "RelizKit")],
            path: "Sources/RZUIKit/RZDarkModeKit",
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RZUIPacKit",
            dependencies: [.target(name: "RZObservableKit")],//, .target(name: "RelizKit")],
            path: "Sources/RZUIKit/RZUIPacKit",
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RZViewBuilderKit",
            dependencies: [.target(name: "RZObservableKit"), .target(name: "RZDarkModeKit")],//, .target(name: "RelizKit")],
            path: "Sources/RZUIKit/RZViewBuilderKit",
            exclude: ["Info.plist"]
        )
    ]
)



