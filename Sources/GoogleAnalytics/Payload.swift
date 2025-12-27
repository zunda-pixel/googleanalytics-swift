import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
struct Payload: Encodable {
  public var appInstanceId: String
  public var clientId: String?
  public var userId: String?
  public var timestamp: Date?
  public var userProperties: (any Encodable)?
  public var userData: UserData?
  public var consent: Consent?
  public var userLocation: UserLocation?
  public var ipOverride: String?
  public var device: Device?
  public var validationBehavior: ValidationBehavior = .relaxed
  public var events: [Event]

  private enum CodingKeys: String, CodingKey {
    case appInstanceId = "app_instance_id"
    case clientId = "client_id"
    case userId = "user_id"
    case timestamp = "timestamp_micros"
    case userProperties = "user_properties"
    case userData = "user_data"
    case consent
    case userLocation = "user_location"
    case ipOverride = "ip_override"
    case device
    case validationBehavior = "validation_behavior"
    case events
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    // try container.encode(appInstanceId, forKey: .appInstanceId)
    try container.encodeIfPresent(
      timestamp.map { UInt($0.timeIntervalSince1970 * 1_000_000) },
      forKey: .timestamp
    )
    try container.encodeIfPresent(clientId, forKey: .clientId)
    try container.encodeIfPresent(userId, forKey: .userId)
    try container.encodeIfPresent(userData, forKey: .userData)
    try container.encodeIfPresent(userLocation, forKey: .userLocation)
    if let userProperties {
      try container.encodeIfPresent(userProperties, forKey: .userProperties)
    }
    try container.encodeIfPresent(consent, forKey: .consent)
    try container.encode(events, forKey: .events)
  }
}

public enum ValidationBehavior: String, Sendable, Codable, Hashable {
  case relaxed = "RELAXED"
  case enforceRecommendations = "ENFORCE_RECOMMENDATIONS"
}
