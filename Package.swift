// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = Package(
    name: "Engine",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(
            name: "Example",
            targets: ["Example"]
        ),
        .library(
            name: "Engine",
            targets: ["Engine"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Engine",
            dependencies: [
                Target.Dependency("Engine.Core"),
                Target.Dependency("Engine.Graphics"),
                Target.Dependency("Engine.Logging"),
                Target.Dependency("Engine.Math"),
                Target.Dependency("Engine.Platform"),
            ],
        ),
        .target(
            name: "Engine.Core",
            dependencies: [Target.Dependency("Engine.Graphics")], 
            path: "Modules/Engine/Core"
        ),
        .target(
            name: "Engine.Extensions", 
            path: "Modules/Engine/Extensions"
        ),
        .target(
            name: "Engine.Graphics", 
            dependencies: [
                Target.Dependency("Engine.Logging"), 
                Target.Dependency("Engine.Utilities"),
                Target.Dependency("Engine.Math"),
                Target.Dependency("Engine.Platform"),
                Target.Dependency("Engine.Graphics.RenderTarget"),
                Target.Dependency.targetItem(name: "Engine.Utilities.Windows", condition: TargetDependencyCondition.when(platforms: [.windows]))
            ],
            path: "Modules/Engine/Graphics/Graphics",
        ),
        .target(
            name: "Engine.Graphics.RenderTarget",
            path: "Modules/Engine/Graphics/RenderTarget"
        ),
        .target(
            name: "Engine.Logging", 
            path: "Modules/Engine/Logging"
        ),
        .target(
            name: "Engine.Math", 
            path: "Modules/Engine/Math"
        ),
        .target(
            name: "Engine.Platform", 
            dependencies: [
                Target.Dependency("Engine.Extensions"),
                Target.Dependency("Engine.Graphics.RenderTarget"),
                Target.Dependency.targetItem(name: "Engine.Utilities.Windows", condition: TargetDependencyCondition.when(platforms: [.windows])),
            ],
            path: "Modules/Engine/Platform"
        ),
        .target(
            name: "Engine.Utilities", 
            path: "Modules/Engine/Utilities"
        ),

        // Windows only module
        .target(
            name: "Engine.Utilities.Windows", 
            path: "Modules/Platforms/Utilities/Windows"
        ),

        .executableTarget(
            name: "Example",
            dependencies: [Target.Dependency("Engine")],
            path: "./Examples/Sources",
        ),
    ]
)