import Foundation
import Testing

@testable import GoogleAnalytics

let client = GoogleAnalytics(
  httpClient: .urlSession(.shared),
  appId: ProcessInfo.processInfo.environment["APP_ID"]!,
  apiSecret: ProcessInfo.processInfo.environment["API_SECRET"]!
)

@Test func login() async throws {
  struct Parameters: Encodable {
    var method: String
  }
  let loginEvent = Event(
    name: "login",
    parameters: Parameters(method: "password")
  )

  let payload = Payload(
    appInstanceId: UUID().uuidString.replacingOccurrences(of: "-", with: ""),
    events: [loginEvent]
  )
  try await client.log(for: payload)
}

struct Empty: Codable {

}
@Test func validatePayload() async throws {
  struct Parameters: Encodable {
    var method: String
  }
  let loginEvent = Event(
    name: "login",
    parameters: Parameters(method: "password")
  )

  let payload = Payload(
    appInstanceId: UUID().uuidString.replacingOccurrences(of: "-", with: ""),
    events: [loginEvent]
  )
  try await client.validatePayload(for: payload)
}
