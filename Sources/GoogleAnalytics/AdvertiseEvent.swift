import Foundation
import MemberwiseInit

extension Event {
  /// Ad Impression event.
  ///
  /// This event signifies when a user sees an ad impression.
  public static func adImpression(
    platform: String? = nil,
    format: String? = nil,
    source: String? = nil,
    unitName: String? = nil,
    price: Price? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "ad_impression",
      timestamp: timestamp,
      parameters: AdvertiseEventParameters(
        platform: platform,
        format: format,
        source: source,
        unitName: unitName,
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit
public struct AdvertiseEventParameters: Encodable {
  public var platform: String?
  public var format: String?
  public var source: String?
  public var unitName: String?
  public var price: Price?
  public var sessionId: String?
  public var engagementTime: TimeInterval?

  private enum CodingKeys: String, CodingKey {
    case platform = "ad_platform"
    case format = "ad_format"
    case source = "ad_source"
    case unitName = "ad_unit_name"
    case currency
    case value
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.platform, forKey: .platform)
    try container.encode(self.format, forKey: .format)
    try container.encode(self.source, forKey: .source)
    try container.encode(self.unitName, forKey: .unitName)
    try container.encode(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encode(self.price?.value, forKey: .value)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(
      self.engagementTime.map { $0 * 1_000_000 }?.description,
      forKey: .engagementTime
    )
  }
}
