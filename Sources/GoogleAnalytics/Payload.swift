import Foundation

public struct Payload<Paramters: Encodable>: Encodable {
  public var appInstanceId: String
  public var timestampMicros: Date?
  public var userId: String?
  public var events: [Event<Paramters>]
  
  public init(
    appInstanceId: String,
    timestampMicros: Date? = nil,
    userId: String? = nil,
    events: [Event<Paramters>]
  ) {
    self.appInstanceId = appInstanceId
    self.timestampMicros = timestampMicros
    self.events = events
  }
  
  private enum CodingKeys: String, CodingKey {
    case appInstanceId = "app_instance_id"
    case timestampMicros = "timestamp_micros"
    case userId = "user_id"
    case events
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(appInstanceId, forKey: .appInstanceId)
    try container.encodeIfPresent(userId, forKey: .userId)
    try container.encodeIfPresent(timestampMicros.map { Int($0.timeIntervalSince1970) }, forKey: .timestampMicros)
    try container.encode(events, forKey: .events)
  }
}
