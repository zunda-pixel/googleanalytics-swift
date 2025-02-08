// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "GoogleAnalytics",
  platforms: [
    .iOS(.v18),
    .macOS(.v15),
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
    .package(url: "https://github.com/apple/swift-crypto", from: "3.10.1"),
    .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
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
      ]
    ),
    .testTarget(
      name: "GoogleAnalyticsTests",
      dependencies: ["GoogleAnalytics"]
    ),
  ]
)
