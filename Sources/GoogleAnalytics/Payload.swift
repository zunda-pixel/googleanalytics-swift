import Foundation

struct Payload<Paramters: Encodable, UserProperties: Encodable>: Encodable {
  public var appInstanceId: String
  public var timestampMicros: Date?
  public var userId: String?
  public var userData: UserData?
  public var userProperties: UserProperties?
  public var consent: Consent?
  public var events: [Event<Paramters>]

  private enum CodingKeys: String, CodingKey {
    case appInstanceId = "app_instance_id"
    case timestampMicros = "timestamp_micros"
    case userId = "user_id"
    case userData = "user_data"
    case userProperties = "user_properties"
    case consent
    case events
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(appInstanceId, forKey: .appInstanceId)
    try container.encodeIfPresent(
      timestampMicros.map { UInt($0.timeIntervalSince1970 * 1_000_000) },
      forKey: .timestampMicros
    )
    try container.encodeIfPresent(userId, forKey: .userId)
    try container.encodeIfPresent(userData, forKey: .userData)
    try container.encodeIfPresent(userProperties, forKey: .userProperties)
    try container.encodeIfPresent(consent, forKey: .consent)
    try container.encode(events, forKey: .events)
  }
}
