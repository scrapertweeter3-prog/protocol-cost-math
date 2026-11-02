// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ProtocolCostMath",
    products: [
        .library(name: "ProtocolCostMath", targets: ["ProtocolCostMath"])
    ],
    targets: [
        .target(name: "ProtocolCostMath")
    ]
)
