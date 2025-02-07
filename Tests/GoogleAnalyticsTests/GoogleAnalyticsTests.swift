import Foundation
import Testing

@testable import GoogleAnalytics

let client = GoogleAnalytics(
  httpClient: .urlSession(.shared),
  appId: ProcessInfo.processInfo.environment["APP_ID"]!,
  apiSecret: ProcessInfo.processInfo.environment["API_SECRET"]!,
  appInstanceId: UUID().uuidString.replacingOccurrences(of: "-", with: "")
)

@Test func login() async throws {
  struct Parameters: Encodable {
    var method: String
  }
  let loginEvent = Event(
    name: "login",
    parameters: Parameters(method: "password")
  )

  try await client.log(for: loginEvent)
}

@Test func validatePayload() async throws {
  struct Parameters: Encodable {
    var method: String
  }
  let loginEvent = Event(
    name: "_login",
    parameters: ["1": "value1"]
  )

  let messages = try await client.validatePayload(for: [loginEvent])
  print(messages)
}
