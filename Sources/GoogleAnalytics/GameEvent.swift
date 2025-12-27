import Foundation
import MemberwiseInit

extension Event {
  /// Level Start event.
  ///
  /// Log this event when the user starts a new level.
  public static func levelStart(
    levelName: String,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "level_start",
      timestamp: timestamp,
      parameters: [
        "level_name": levelName,
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description,
      ]
    )
  }

  /// Level Up event.
  ///
  /// This event signifies that a player has leveled up in your gaming app.
  /// It can help you gauge the level distribution of your userbase and help you identify certain levels that are difficult to pass.
  public static func levelUp(
    level: UInt,
    character: String? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "level_up",
      timestamp: timestamp,
      parameters: LevelUpParametes(
        level: level,
        character: character,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }

  /// Level End event.
  ///
  /// Log this event when the user finishes a level.
  public static func levelEnd(
    levelName: String,
    success: Bool,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "level_end",
      timestamp: timestamp,
      parameters: LevelEndParametes(
        levelName: levelName,
        success: success,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }

  /// Post Score event.
  ///
  /// Log this event when the user posts a score in your gaming app.
  /// This event can help you understand how users are actually performing in your game and it can help you correlate high scores with certain audiences or behaviors.
  public static func postScore(
    score: UInt,
    level: UInt? = nil,
    character: String? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "post_score",
      timestamp: timestamp,
      parameters: PostScoreParameters(
        score: score,
        level: level,
        character: character,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }

  /// Unlock Achievement event.
  ///
  /// Log this event when the user has unlocked an achievement in your game.
  /// Since achievements generally represent the breadth of a gaming experience, this event can help you understand how many users are experiencing all that your game has to offer.
  public static func unlockAchievement(
    achievementId: String,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "unlock_achievement",
      timestamp: timestamp,
      parameters: [
        "achievement_id": achievementId,
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description,
      ]
    )
  }

  /// Earn Virtual Currency event.
  public static func earnVirtualCurrency(
    currencyName: String,
    value: Double,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "earn_virtual_currency",
      timestamp: timestamp,
      parameters: EarnVirtualCurrencyParameters(
        currencyName: currencyName,
        value: value,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }

  /// Spend Virtual Currency event.
  ///
  /// This event tracks the sale of virtual goods in your app and can help you identify which virtual goods are the most popular objects of purchase.
  public static func spendVirtualCurrency(
    itemName: String,
    currencyName: String,
    value: Double,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "spend_virtual_currency",
      timestamp: timestamp,
      parameters: SpendVirtualCurrencyParameters(
        itemName: itemName,
        currencyName: currencyName,
        value: value,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit(.public)
public struct EarnVirtualCurrencyParameters: Encodable {
  public var currencyName: String
  public var value: Double
  public var sessionId: String?
  public var engagementTime: TimeInterval?

  private enum CodingKeys: String, CodingKey {
    case currencyName = "virtual_currency_name"
    case value
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.currencyName, forKey: .currencyName)
    try container.encode(self.value, forKey: .value)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(
      self.engagementTime.map { $0 * 1_000_000 }?.description,
      forKey: .engagementTime
    )
  }
}

@MemberwiseInit(.public)
public struct SpendVirtualCurrencyParameters: Encodable {
  public var itemName: String
  public var currencyName: String
  public var value: Double
  public var sessionId: String?
  public var engagementTime: TimeInterval?

  private enum CodingKeys: String, CodingKey {
    case itemName = "item_name"
    case currencyName = "virtual_currency_name"
    case value
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.itemName, forKey: .itemName)
    try container.encode(self.currencyName, forKey: .currencyName)
    try container.encode(self.value, forKey: .value)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(
      self.engagementTime.map { $0 * 1_000_000 }?.description,
      forKey: .engagementTime
    )
  }
}

@MemberwiseInit(.public)
public struct PostScoreParameters: Encodable {
  public var score: UInt
  public var level: UInt?
  public var character: String?
  public var sessionId: String?
  public var engagementTime: TimeInterval?

  private enum CodingKeys: String, CodingKey {
    case score
    case level
    case character
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.score, forKey: .score)
    try container.encodeIfPresent(self.level, forKey: .level)
    try container.encodeIfPresent(self.character, forKey: .character)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(
      self.engagementTime.map { $0 * 1_000_000 }?.description,
      forKey: .engagementTime
    )
  }
}

@MemberwiseInit(.public)
public struct LevelUpParametes: Encodable {
  public var level: UInt
  public var character: String?
  public var sessionId: String?
  public var engagementTime: TimeInterval?

  private enum CodingKeys: String, CodingKey {
    case level
    case character
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.level, forKey: .level)
    try container.encodeIfPresent(self.character, forKey: .character)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(
      self.engagementTime.map { $0 * 1_000_000 }?.description,
      forKey: .engagementTime
    )
  }
}

@MemberwiseInit(.public)
public struct LevelEndParametes: Encodable {
  public var levelName: String
  public var success: Bool
  /// TODO - should be a int? 0 or 1
  public var sessionId: String?
  public var engagementTime: TimeInterval?

  private enum CodingKeys: String, CodingKey {
    case levelName = "level_name"
    case success
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.levelName, forKey: .levelName)
    try container.encode(self.success, forKey: .success)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(
      self.engagementTime.map { $0 * 1_000_000 }?.description,
      forKey: .engagementTime
    )
  }
}
