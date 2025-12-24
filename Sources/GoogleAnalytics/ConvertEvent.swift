import Foundation
import MemberwiseInit

@MemberwiseInit
struct PriceParameters: Encodable {
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
    try container.encode(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encode(self.price?.value, forKey: .value)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(
      self.engagementTime.map { $0 * 1_000_000 }?.description,
      forKey: .engagementTime
    )
  }
}

@MemberwiseInit
struct PriceReasonParameters: Encodable {
  var price: Price?
  var reason: String?
  var sessionId: String?
  var engagementTime: TimeInterval?

  private enum CodingKeys: String, CodingKey {
    case currency
    case value
    case reason
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encode(self.price?.value, forKey: .value)
    try container.encodeIfPresent(self.reason, forKey: .reason)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(
      self.engagementTime.map { $0 * 1_000_000 }?.description,
      forKey: .engagementTime
    )
  }
}

extension GoogleAnalytics {
  /// Close Convert  Lead Event.
  ///
  /// This event measures when a lead has been converted and closed (for example, through a purchase).
  public func closeConvertLead(
    price: Price? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "close_convert_lead",
      parameters: PriceParameters(
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }

  /// Close Unconvert Lead Event.
  ///
  /// This event measures when a user is marked as not becoming a converted lead, along with the reason.
  public func closeUnConvertLead(
    price: Price? = nil,
    reason: String? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "close_convert_lead",
      parameters: PriceReasonParameters(
        price: price,
        reason: reason,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }

  /// Disqualify Lead  Event.
  ///
  /// This event measures when a lead is generated.
  public func disqualifyLead(
    price: Price? = nil,
    reason: String? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "disqualify_lead",
      parameters: PriceReasonParameters(
        price: price,
        reason: reason,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }

  /// Qualify Lead  Event.
  ///
  /// This event measures when a user is marked as meeting the criteria to become a qualified lead.
  public func qualifyLead(
    price: Price? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "qualify_lead",
      parameters: PriceParameters(
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }

  /// Working Lead  Event.
  ///
  /// This event measures when a user contacts or is contacted by a representative.
  public func workingLead(
    price: Price? = nil,
    leadStatus: String? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "working_lead",
      parameters: WorkingLeadParameters(
        price: price,
        leadStatus: leadStatus,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }
}

@MemberwiseInit
struct WorkingLeadParameters: Encodable {
  var price: Price?
  var leadStatus: String?
  var sessionId: String?
  var engagementTime: TimeInterval?

  enum CodingKeys: String, CodingKey {
    case currency
    case value
    case leadStatus = "lead_status"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encode(self.price?.value, forKey: .value)
    try container.encodeIfPresent(self.leadStatus, forKey: .leadStatus)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(
      self.engagementTime.map { $0 * 1_000_000 }?.description,
      forKey: .engagementTime
    )
  }
}
