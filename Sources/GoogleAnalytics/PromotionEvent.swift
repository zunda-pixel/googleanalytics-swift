import Foundation

struct ViewPromotionParameters: Encodable {
  var id: String?
  var name: String?
  var creativeName: String?
  var creativeSlot: String?
  var items: [Item]
  var sessionId: String?
  var engagementTime: TimeInterval?
  
  private enum CodingKeys: String, CodingKey {
    case id = "promotion_id"
    case name = "promotion_name"
    case creativeName = "creative_name"
    case creativeSlot = "creative_slot"
    case items
    case sessionId = "session_id"
    case engagementTime = "engagement_time"
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(id, forKey: .id)
    try container.encodeIfPresent(name, forKey: .name)
    try container.encodeIfPresent(creativeName, forKey: .creativeName)
    try container.encodeIfPresent(creativeSlot, forKey: .creativeSlot)
    try container.encode(items, forKey: .items)
    try container.encodeIfPresent(sessionId, forKey: .sessionId)
    try container.encodeIfPresent(engagementTime.map { $0 * 1_000_000 }?.description, forKey: .engagementTime)
  }
}

extension GoogleAnalytics {
  /// View Promotion event.
  ///
  /// This event signifies that a promotion was shown to a user.
  /// Add this event to a funnel with the addToCart and purchase to gauge your conversion process.
  public func viewPromotion(
    id promotionId: String? = nil,
    name promotionName: String? = nil,
    creativeName: String? = nil,
    creativeSlot: String? = nil,
    items: [Item],
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "view_promotion",
      parameters: ViewPromotionParameters(
        id: promotionId,
        name: promotionName,
        creativeName: creativeName,
        creativeSlot: creativeSlot,
        items: items,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    
    try await log(for: event)
  }
}

struct GenerateLeadParameters: Encodable {
  var price: Price?
  var sessionId: String?
  var engagementTime: TimeInterval?
  
  private enum CodingKeys: String, CodingKey {
    case currency
    case value
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encodeIfPresent(price?.value, forKey: .value)
    try container.encodeIfPresent(sessionId, forKey: .sessionId)
    try container.encodeIfPresent(engagementTime.map { $0 * 1_000_000 }?.description, forKey: .engagementTime)
  }
}

extension GoogleAnalytics {
  /// Generate Lead event.
  ///
  /// Log this event when a lead has been generated in the app to understand the efficacy of your install and re-engagement campaigns.
  public func generateLead(
    price: Price? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "generate_lead",
      parameters: GenerateLeadParameters(
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    
    try await log(for: event)
  }
}

extension GoogleAnalytics {
  /// Campaign Detail event.
  ///
  /// Log this event to supply the referral details of a re-engagement campaign.
  /// Note: you must supply at least one of the required parameters source, medium or campaign.
  public func campaignDetails(
    source: String?,
    medium: String?,
    campaign: String?,
    term: String? = nil,
    adNetworkClickId: String? = nil,
    campaignId: String? = nil,
    campaignContent: String? = nil,
    campaignCutomData: String? = nil,
    creativeFormat: String? = nil,
    marketingTactic: String? = nil,
    sourcePlatform: String? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "campaign_details",
      parameters: [
        "source": source,
        "medium": medium,
        "campaign": campaign,
        "term": term,
        "ad_network_click_id": adNetworkClickId,
        "campaign_id": campaignId,
        "campaign_content": campaignContent,
        "campaign_custom_data": campaignCutomData,
        "creative_format": creativeFormat,
        "marketing_tactic": marketingTactic,
        "source_platform": sourcePlatform,
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description
      ]
    )
    
    try await log(for: event)
  }
}
