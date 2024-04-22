// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let name: String = "swift-secrets-vault-plugin"

// MARK: - Package Description SupportedPlatform

let platforms: [PackageDescription.SupportedPlatform] = [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6),
    .macCatalyst(.v13)
]

// MARK: - Package Description Product

let products: [PackageDescription.Product] = [
    .executable(name: "generateSecret", targets: ["GenerateSecretCommand"]),
    .executable(name: "GenerateSecretCommand", targets: ["GenerateSecretCommand"]),
    .plugin(name: "RXByteArraySecretPlugin", targets: ["RXByteArraySecretPlugin"]),
]

// MARK: - Package Dependency

let dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/apple/swift-argument-parser", "1.3.0"..<"1.4.0"),
]

// MARK: Package Description Target

let targets: [PackageDescription.Target] = [
    // MARK: - Targets
    .plugin(
        name: "RXByteArraySecretPlugin",
        capability: .buildTool(),
        dependencies: ["GenerateSecretCommand"]
    ),
    .executableTarget(
        name: "GenerateSecretCommand",
        dependencies: [
            "CodeGenerator",
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]
    ),
    .target(name: "CodeGenerator", dependencies: ["SecretsVaultModel"]),
    .target(name: "SecretsVaultModel", dependencies: ["SecretsVaultUtility"]),
    .target(name: "SecretsVaultUtility"),

    // MARK: - Example Target
    .executableTarget(
        name: "ExampleTarget",
        swiftSettings: [.define("CUSTOM_RELEASE_FLAG", .when(configuration: .release))],
        plugins: [
            .plugin(name: "RXByteArraySecretPlugin")
        ]
    ),

    // MARK: - Tests
    .testTarget(
        name: "SecretsVaultUtilityTests",
        dependencies: ["SecretsVaultUtility"]
    ),
    .testTarget(
        name: "SecretsVaultModelTests",
        dependencies: ["SecretsVaultModel"]
    ),
    .testTarget(
        name: "CodeGeneratorTests",
        dependencies: ["CodeGenerator", "SecretsVaultModel"]
    ),
]

// MARK: - PackageDescription Package

let package: Package = PackageDescription.Package(
    name: name,
    platforms: platforms,
    products: products,
    dependencies: dependencies,
    targets: targets
)
