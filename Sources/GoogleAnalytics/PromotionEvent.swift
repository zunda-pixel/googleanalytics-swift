import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public struct ViewPromotionParameters: Encodable {
  public var id: String?
  public var name: String?
  public var creativeName: String?
  public var creativeSlot: String?
  public var items: [Item]
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case id = "promotion_id"
    case name = "promotion_name"
    case creativeName = "creative_name"
    case creativeSlot = "creative_slot"
    case items
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(id, forKey: .id)
    try container.encodeIfPresent(name, forKey: .name)
    try container.encodeIfPresent(creativeName, forKey: .creativeName)
    try container.encodeIfPresent(creativeSlot, forKey: .creativeSlot)
    try container.encode(items, forKey: .items)
    try container.encode(sessionId, forKey: .sessionId)
    try container.encode(engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

extension Event {
  /// View Promotion event.
  ///
  /// This event signifies that a promotion was shown to a user.
  /// Add this event to a funnel with the addToCart and purchase to gauge your conversion process.
  public static func viewPromotion(
    id promotionId: String? = nil,
    name promotionName: String? = nil,
    creativeName: String? = nil,
    creativeSlot: String? = nil,
    items: [Item],
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "view_promotion",
      timestamp: timestamp,
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
  }
}

@MemberwiseInit(.public)
public struct GenerateLeadParameters: Encodable {
  public var price: Price?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case currency
    case value
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encodeIfPresent(price?.value, forKey: .value)
    try container.encode(sessionId, forKey: .sessionId)
    try container.encode(engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

extension Event {
  /// Generate Lead event.
  ///
  /// Log this event when a lead has been generated in the app to understand the efficacy of your install and re-engagement campaigns.
  public static func generateLead(
    price: Price? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "generate_lead",
      timestamp: timestamp,
      parameters: GenerateLeadParameters(
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// Campaign Detail event.
  ///
  /// Log this event to supply the referral details of a re-engagement campaign.
  /// Note: you must supply at least one of the required parameters source, medium or campaign.
  public static func campaignDetails(
    source: String,
    medium: String,
    campaign: String,
    term: String,
    adNetworkClickId: String,
    campaignId: String,
    campaignContent: String,
    campaignCustomData: String,
    creativeFormat: String,
    marketingTactic: String,
    sourcePlatform: String,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "campaign_details",
      timestamp: timestamp,
      parameters: CampaignDetailsParameters(
        source: source,
        medium: medium,
        campaign: campaign,
        term: term,
        adNetworkClickId: adNetworkClickId,
        campaignId: campaignId,
        campaignContent: campaignContent,
        campaignCustomData: campaignCustomData,
        creativeFormat: creativeFormat,
        marketingTactic: marketingTactic,
        sourcePlatform: sourcePlatform,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

struct CampaignDetailsParameters: Encodable {
  var source: String
  var medium: String
  var campaign: String
  var term: String
  var adNetworkClickId: String
  var campaignId: String
  var campaignContent: String
  var campaignCustomData: String
  var creativeFormat: String
  var marketingTactic: String
  var sourcePlatform: String
  var sessionId: String
  var engagementTime: TimeInterval

  enum CodingKeys: String, CodingKey {
    case source
    case medium
    case campaign
    case term
    case adNetworkClickId = "ad_network_click_id"
    case campaignId = "campaign_id"
    case campaignContent = "campaign_content"
    case campaignCustomData = "campaign_custom_data"
    case creativeFormat = "creative_format"
    case marketingTactic = "marketing_tactic"
    case sourcePlatform = "source_platform"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.source, forKey: .source)
    try container.encode(self.medium, forKey: .medium)
    try container.encode(self.campaign, forKey: .campaign)
    try container.encode(self.term, forKey: .term)
    try container.encode(self.adNetworkClickId, forKey: .adNetworkClickId)
    try container.encode(self.campaignId, forKey: .campaignId)
    try container.encode(self.campaignContent, forKey: .campaignContent)
    try container.encode(self.campaignCustomData, forKey: .campaignCustomData)
    try container.encode(self.creativeFormat, forKey: .creativeFormat)
    try container.encode(self.marketingTactic, forKey: .marketingTactic)
    try container.encode(self.sourcePlatform, forKey: .sourcePlatform)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}
