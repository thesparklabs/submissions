// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Submissions",
    products: [
        .library(name: "Submissions", targets: ["Submissions"]),
    ],
    dependencies: [
        .package(url: "https://github.com/thesparklabs/validation.git", .branch("error-with-types")),
        .package(url: "https://github.com/nodes-vapor/sugar.git", from: "3.0.0-alpha"),
        .package(url: "https://github.com/vapor/template-kit.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/thesparklabs/AnyCodable.git", from: "0.1.0")
    ],
    targets: [
        .target(name: "Submissions", dependencies: ["Sugar", "TemplateKit", "Vapor", "AnyCodable"]),
        .testTarget(name: "SubmissionsTests", dependencies: ["Submissions"])
    ]
)

