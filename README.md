## GoogleAnalytics for Swift

```swift
let client = GoogleAnalytics(
  httpClient: .urlSession(.shared),
  appId: "1:211175559289:ios:121555f3c816aecc3cd5d8"
  apiSecret: "bCab-SdfDBi2L3ZPaYHYfw"
)

let appInstanceId = UUID().uuidString.replacingOccurrences(of: "-", with: "")

try await client.log(for: Payload(
  appInstanceId: appInstanceId,
  events: [
    Event(
      name: "login",
      parameters: ["method": "Google"]
    )
  ]
))
```
