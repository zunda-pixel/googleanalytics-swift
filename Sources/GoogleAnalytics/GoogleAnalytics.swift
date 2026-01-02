import Foundation
import HTTPClient
import HTTPTypes
import MemberwiseInit

@MemberwiseInit(.public)
public struct GoogleAnalytics<HTTPClient: HTTPClientProtocol, UserProperties: Encodable> {
  public var httpClient: HTTPClient
  public var baseUrl: URL = URL(string: "https://www.google-analytics.com/")!
  public var apiSecret: String
  public var id: ID
  public var userId: String?
  public var userProperties: UserProperties?
  public var userData: UserData?
  public var consent: Consent?
  public var userLocation: UserLocation?
  public var ipOverride: String?
  public var device: Device?
  public var validationBehavior: ValidationBehavior = .relaxed

  public init(
    httpClient: HTTPClient,
    baseUrl: URL = URL(string: "https://www.google-analytics.com/")!,
    apiSecret: String,
    id: ID,
    userId: String?,
    userData: UserData?,
    consent: Consent?,
    userLocation: UserLocation?,
    ipOverride: String?,
    device: Device?,
    validationBehavior: ValidationBehavior = .relaxed
  ) where UserProperties == Never {
    self.httpClient = httpClient
    self.baseUrl = baseUrl
    self.apiSecret = apiSecret
    self.id = id
    self.userId = userId
    self.userProperties = nil
    self.userData = userData
    self.consent = consent
    self.userLocation = userLocation
    self.ipOverride = ipOverride
    self.device = device
    self.validationBehavior = validationBehavior
  }

  public func send(
    for event: Event,
    timestamp: Date? = nil
  ) async throws {
    try await self.send(for: [event], timestamp: timestamp)
  }

  /// Send events
  /// - Parameters:
  ///   - events: Up to 25 events
  ///   - timestamp: timestamp
  public func send(
    for events: [Event],
    timestamp: Date? = nil
  ) async throws {
    let payload = Payload(
      id: id,
      userId: userId,
      timestamp: timestamp,
      userProperties: userProperties,
      userData: userData,
      consent: consent,
      userLocation: userLocation,
      ipOverride: ipOverride,
      device: device,
      events: events
    )

    var queries: [URLQueryItem] = [
      .init(name: "api_secret", value: apiSecret)
    ]

    switch id {
    case .firebase(let firebaseAppId, _):
      queries.append(.init(name: "firebase_app_id", value: firebaseAppId))
    case .gtag(let measurementId, _):
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

    guard response.status == .noContent else {
      throw ResponseError(data: data, response: response)
    }
  }

  public func validatePayload(
    for events: [Event],
    timestamp: Date? = nil
  ) async throws -> [ValidationResponse.Message] {
    let payload = Payload(
      id: id,
      userId: userId,
      timestamp: timestamp,
      userProperties: userProperties,
      userData: userData,
      consent: consent,
      userLocation: userLocation,
      ipOverride: ipOverride,
      device: device,
      events: events
    )

    var queries: [URLQueryItem] = [
      .init(name: "api_secret", value: apiSecret)
    ]

    switch id {
    case .firebase(let firebaseAppId, _):
      queries.append(.init(name: "firebase_app_id", value: firebaseAppId))
    case .gtag(let measurementId, _):
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

    let (data, response) = try await httpClient.execute(
      for: request,
      from: bodyData
    )

    guard response.status == .ok else {
      throw ResponseError(data: data, response: response)
    }

    let validationMessages = try JSONDecoder().decode(ValidationResponse.self, from: data)

    return validationMessages.message
  }
}

@MemberwiseInit(.public)
public struct ValidationResponse: Decodable {
  public var message: [Message]

  private enum CodingKeys: String, CodingKey {
    case message = "validationMessages"
  }

  public struct Message: Decodable, Hashable, Sendable {
    public var fieldPath: String?
    public var description: String
    public var validationCode: String
  }
}

extension GoogleAnalytics: Sendable where HTTPClient: Sendable, UserProperties: Sendable {}
