import Foundation

extension GoogleAnalytics {
  /// Ad Impression event.
  ///
  /// This event signifies when a user sees an ad impression.
  public func adImpression(
    platform: String? = nil,
    format: String? = nil,
    source: String? = nil,
    unitName: String? = nil,
    price: Price? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "ad_impression",
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
    
    try await log(for: event)
  }
}


struct AdvertiseEventParameters: Encodable {
  var platform: String?
  var format: String?
  var source: String?
  var unitName: String?
  var price: Price?
  var sessionId: String?
  var engagementTime: TimeInterval?
  
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
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.platform, forKey: .platform)
    try container.encode(self.format, forKey: .format)
    try container.encode(self.source, forKey: .source)
    try container.encode(self.unitName, forKey: .unitName)
    try container.encode(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encode(self.price?.value, forKey: .value)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime.map { $0 * 1_000_000 }?.description, forKey: .engagementTime)
  }
}
