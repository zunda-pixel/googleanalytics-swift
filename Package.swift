// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "googleanalytics-swift",
  platforms: [
    .iOS(.v26),
    .macOS(.v26),
  ],
  products: [
    .library(
      name: "GoogleAnalytics",
      targets: ["GoogleAnalytics"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-http-types.git", from: "1.3.1"),
    .package(url: "https://github.com/zunda-pixel/http-client.git", from: "0.3.0"),
    .package(url: "https://github.com/zunda-pixel/swift-currency", from: "0.0.1"),
    .package(url: "https://github.com/apple/swift-crypto", from: "4.0.0"),
    .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
    .package(url: "https://github.com/swift-standards/swift-iso-3166.git", from: "0.2.0"),
    .package(url: "https://github.com/gohanlon/swift-memberwise-init-macro.git", from: "0.5.2"),
  ],
  targets: [
    .target(
      name: "GoogleAnalytics",
      dependencies: [
        .product(name: "HTTPTypes", package: "swift-http-types"),
        .product(name: "HTTPTypesFoundation", package: "swift-http-types"),
        .product(name: "HTTPClient", package: "http-client"),
        .product(name: "Currency", package: "swift-currency"),
        .product(name: "Crypto", package: "swift-crypto"),
        .product(name: "Algorithms", package: "swift-algorithms"),
        .product(name: "ISO 3166", package: "swift-iso-3166"),
        .product(name: "MemberwiseInit", package: "swift-memberwise-init-macro"),
      ]
    ),
    .testTarget(
      name: "GoogleAnalyticsTests",
      dependencies: ["GoogleAnalytics"]
    ),
  ]
)
