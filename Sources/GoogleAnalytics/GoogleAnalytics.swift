import Foundation
import HTTPTypes
import HTTPClient

extension GoogleAnalytics: Sendable where HTTPClient: Sendable {}

public struct GoogleAnalytics<HTTPClient: HTTPClientProtocol> {
  public var httpClient: HTTPClient
  public var baseUrl: URL = URL(string: "https://www.google-analytics.com/")!
  public var appId: String
  public var apiSecret: String
  
  public init(
    httpClient: HTTPClient,
    appId: String,
    apiSecret: String
  ) {
    self.httpClient = httpClient
    self.appId = appId
    self.apiSecret = apiSecret
  }
  
  public func log<Paramters: Encodable>(
    for payload: Payload<Paramters>
  ) async throws {
    let endpoint = baseUrl
      .appending(path: "mp/collect")
      .appending(queryItems: [
        .init(name: "api_secret", value: apiSecret),
        .init(name: "firebase_app_id", value: appId),
      ])
    
    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [
        .contentType: "application/json",
      ]
    )
    
    let bodyData = try JSONEncoder().encode(payload)
    
    let (data, response) = try await httpClient.execute(
      for: request,
      from: bodyData
    )
    
    guard response.status.code == 204 else {
      throw ResponseError(data: data, response: response)
    }
  }

  public func validatePayload<Paramters: Encodable>(
    for payload: Payload<Paramters>
  ) async throws {
    let endpoint = baseUrl
      .appending(path: "debug/mp/collect")
      .appending(queryItems: [
        .init(name: "api_secret", value: apiSecret),
        .init(name: "firebase_app_id", value: appId),
      ])
    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [
        .contentType: "application/json",
      ]
    )
    
    let bodyData = try JSONEncoder().encode(payload)

    let (data, response) = try await httpClient.execute(
      for: request,
      from: bodyData
    )
    
    print(data)
    print(response)
  }
}
