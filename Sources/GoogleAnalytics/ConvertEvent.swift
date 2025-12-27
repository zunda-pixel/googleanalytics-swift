import Foundation
import MemberwiseInit

@MemberwiseInit
public struct PriceParameters: Encodable {
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
    try container.encode(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encode(self.price?.value, forKey: .value)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(
      (engagementTime * 1_000_000).description,
      forKey: .engagementTime
    )
  }
}

@MemberwiseInit
public struct PriceReasonParameters: Encodable {
  public var price: Price
  public var reason: String?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case currency
    case value
    case reason
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.price.currency.rawValue.uppercased(), forKey: .currency)
    try container.encode(self.price.value, forKey: .value)
    try container.encodeIfPresent(self.reason, forKey: .reason)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(
      (self.engagementTime * 1_000_000).description,
      forKey: .engagementTime
    )
  }
}

extension Event {
  /// Close Convert  Lead Event.
  ///
  /// This event measures when a lead has been converted and closed (for example, through a purchase).
  public static func closeConvertLead(
    price: Price,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "close_convert_lead",
      timestamp: timestamp,
      parameters: PriceParameters(
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }

  /// Close Unconvert Lead Event.
  ///
  /// This event measures when a user is marked as not becoming a converted lead, along with the reason.
  public static func closeUnConvertLead(
    price: Price,
    reason: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "close_unconvert_lead",
      timestamp: timestamp,
      parameters: PriceReasonParameters(
        price: price,
        reason: reason,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }

  /// Disqualify Lead  Event.
  ///
  /// This event measures when a lead is generated.
  public static func disqualifyLead(
    price: Price,
    reason: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "disqualify_lead",
      timestamp: timestamp,
      parameters: PriceReasonParameters(
        price: price,
        reason: reason,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }

  /// Qualify Lead  Event.
  ///
  /// This event measures when a user is marked as meeting the criteria to become a qualified lead.
  public static func qualifyLead(
    price: Price? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "qualify_lead",
      timestamp: timestamp,
      parameters: PriceParameters(
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }

  /// Working Lead  Event.
  ///
  /// This event measures when a user contacts or is contacted by a representative.
  public static func workingLead(
    price: Price,
    leadStatus: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "working_lead",
      timestamp: timestamp,
      parameters: WorkingLeadParameters(
        price: price,
        leadStatus: leadStatus,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit
public struct WorkingLeadParameters: Encodable {
  public var price: Price?
  public var leadStatus: String?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case currency
    case value
    case leadStatus = "lead_status"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encode(self.price?.value, forKey: .value)
    try container.encodeIfPresent(self.leadStatus, forKey: .leadStatus)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(
      (self.engagementTime * 1_000_000).description,
      forKey: .engagementTime
    )
  }
}
