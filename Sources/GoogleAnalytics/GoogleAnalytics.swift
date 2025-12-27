import Foundation
import HTTPClient
import HTTPTypes
import MemberwiseInit

@MemberwiseInit(.public)
public struct GoogleAnalytics<HTTPClient: HTTPClientProtocol, UserProperties: Encodable> {
  public var httpClient: HTTPClient
  public var baseUrl: URL = URL(string: "https://www.google-analytics.com/")!
  public var appId: String
  public var apiSecret: String
  public var id: ID
  public var measurementId: String?
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
    appId: String,
    apiSecret: String,
    id: ID,
    measurementId: String?,
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
    self.appId = appId
    self.apiSecret = apiSecret
    self.measurementId = measurementId
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

  public func log(
    for event: Event,
    timestamp: Date? = nil
  ) async throws {
    try await self.log(for: [event], timestamp: timestamp)
  }

  public func log(
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

  public struct Message: Decodable {
    public var fieldPath: String?
    public var description: String
    public var validationCode: String
  }
}

extension GoogleAnalytics: Sendable where HTTPClient: Sendable, UserProperties: Sendable {}
