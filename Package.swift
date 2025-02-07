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
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-http-types.git", from: "1.3.1"),
    .package(url: "https://github.com/zunda-pixel/http-client.git", from: "0.3.0"),
  ],
  targets: [
    .target(
      name: "GoogleAnalytics",
      dependencies: [
        .product(name: "HTTPTypes", package: "swift-http-types"),
        .product(name: "HTTPTypesFoundation", package: "swift-http-types"),
        .product(name: "HTTPClient", package: "http-client"),
      ]
    ),
    .testTarget(
      name: "GoogleAnalyticsTests",
      dependencies: ["GoogleAnalytics"]
    ),
  ]
)
