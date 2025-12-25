## GoogleAnalytics Measurement Protocol for Swift

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fzunda-pixel%2Fgoogleanalytics-swift%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/zunda-pixel/googleanalytics-swift)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fzunda-pixel%2Fgoogleanalytics-swift%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/zunda-pixel/googleanalytics-swift)

[GA4 Measurement Protocol](https://developers.google.com/analytics/devguides/collection/protocol/ga4)

```swift
let client = GoogleAnalytics(
  httpClient: .urlSession(.shared),
  appId: "1:211175559289:ios:121555f3c816aecc3cd5d8"
  apiSecret: "bCab-SdfDBi2L3ZPaYHYfw",
  appInstanceId: UUID().uuidString.replacing("-", with: "")
)

try await client.log(
  for: Event(
    name: "login",
    timestamp: .now,
    parameters: ["method": "Google"]
  )
)
```
