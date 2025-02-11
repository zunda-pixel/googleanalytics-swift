import Foundation
import HTTPClient
import HTTPTypes

extension GoogleAnalytics: Sendable where HTTPClient: Sendable {}

public struct GoogleAnalytics<HTTPClient: HTTPClientProtocol> {
  public var httpClient: HTTPClient
  public var baseUrl: URL = URL(string: "https://www.google-analytics.com/")!
  public var appId: String
  public var apiSecret: String
  public var measurementId: String?
  public var appInstanceId: String
  public var userId: String?
  public var userData: UserData?
  public var consent: Consent?
  
  public init(
    httpClient: HTTPClient,
    appId: String,
    apiSecret: String,
    measurementId: String? = nil,
    appInstanceId: String,
    userId: String? = nil,
    userData: UserData? = nil,
    consent: Consent? = nil
  ) {
    self.httpClient = httpClient
    self.appId = appId
    self.apiSecret = apiSecret
    self.appInstanceId = appInstanceId
    self.measurementId = measurementId
    self.userId = userId
    self.userData = userData
    self.consent = consent
  }

  public func log<Paramters: Encodable>(
    for event: Event<Paramters>
  ) async throws {
    try await log(for: [event])
  }
  
  public func log<Paramters: Encodable>(
    for events: [Event<Paramters>]
  ) async throws {
    let payload = Payload(
      appInstanceId: appInstanceId,
      timestampMicros: .now,
      userId: userId,
      userData: userData,
      consent: consent,
      events: events
    )
    
    var queries: [URLQueryItem] = [
      .init(name: "api_secret", value: apiSecret),
      .init(name: "firebase_app_id", value: appId),
    ]
    
    if let measurementId {
      queries.append(.init(name: "measurement_id", value: measurementId))
    }
    
    let endpoint =
      baseUrl
      .appending(path: "mp/collect")
      .appending(queryItems: queries)

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [
        .contentType: "application/json"
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
    for events: [Event<Paramters>]
  ) async throws -> [ValidationResponse.Message] {
    let payload = Payload(
      appInstanceId: appInstanceId,
      timestampMicros: .now,
      userId: userId,
      userData: userData,
      consent: consent,
      events: events
    )

    var queries: [URLQueryItem] = [
      .init(name: "api_secret", value: apiSecret),
      .init(name: "firebase_app_id", value: appId),
    ]
    
    if let measurementId {
      queries.append(.init(name: "measurement_id", value: measurementId))
    }
    
    let endpoint =
      baseUrl
      .appending(path: "debug/mp/collect")
      .appending(queryItems: queries)
    
    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [
        .contentType: "application/json"
      ]
    )

    let bodyData = try JSONEncoder().encode(payload)

    let (data, _) = try await httpClient.execute(
      for: request,
      from: bodyData
    )

    let validationMessages = try JSONDecoder().decode(ValidationResponse.self, from: data)
    
    return validationMessages.message
  }
}

public struct ValidationResponse: Decodable {
  var message: [Message]
  
  private enum CodingKeys: String, CodingKey {
    case message = "validationMessages"
  }
  
  public struct Message: Decodable {
    public var fieldPath: String
    public var description: String
    public var validationCode: String
  }
}
