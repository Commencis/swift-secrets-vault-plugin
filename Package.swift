// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let name: String = "swift-secrets-vault-plugin"

// MARK: Package Description SupportedPlatform

let platforms: [PackageDescription.SupportedPlatform] = [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6),
    .macCatalyst(.v13)
]

// MARK: Package Description Product

let products: [PackageDescription.Product] = [
]

// MARK: Package Dependency

let dependencies: [Package.Dependency] = [
]

// MARK: Package Description Target

let targets: [PackageDescription.Target] = [
    .target(name: "SecretsVaultUtility"),
    // MARK: Tests
    .testTarget(
        name: "SecretsVaultUtilityTests",
        dependencies: ["SecretsVaultUtility"]
    ),
]

// - MARK: PackageDescription Package

let package: Package = PackageDescription.Package(
    name: name,
    platforms: platforms,
    products: products,
    dependencies: dependencies,
    targets: targets
)
