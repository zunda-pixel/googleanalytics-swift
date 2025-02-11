import Foundation

extension GoogleAnalytics {
  /// Level Start event.
  ///
  /// Log this event when the user starts a new level.
  public func levelStart(
    levelName: String,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "level_start",
      parameters: [
        "level_name": levelName,
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description
      ]
    )
    try await log(for: event)
  }

  /// Level Up event.
  ///
  /// This event signifies that a player has leveled up in your gaming app.
  /// It can help you gauge the level distribution of your userbase and help you identify certain levels that are difficult to pass.
  public func levelUp(
    level: UInt,
    character: String? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "level_up",
      parameters: LevelUpParametes(
        level: level,
        character: character,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }

  /// Level End event.
  ///
  /// Log this event when the user finishes a level.
  public func levelEnd(
    levelName: String,
    success: Bool,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "level_end",
      parameters: LevelEndParametes(
        levelName: levelName,
        success: success,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }

  /// Post Score event.
  ///
  /// Log this event when the user posts a score in your gaming app.
  /// This event can help you understand how users are actually performing in your game and it can help you correlate high scores with certain audiences or behaviors.
  public func postScore(
    score: UInt,
    level: UInt? = nil,
    character: String? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "post_score",
      parameters: PostScoreParameters(
        score: score,
        level: level,
        character: character,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }

  /// Unlock Achievement event.
  ///
  /// Log this event when the user has unlocked an achievement in your game.
  /// Since achievements generally represent the breadth of a gaming experience, this event can help you understand how many users are experiencing all that your game has to offer.
  public func unlockAchievement(
    achievementId: String,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "unlock_achievement",
      parameters: [
        "achievement_id": achievementId,
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description
      ]
    )
    try await log(for: event)
  }
  
  /// Earn Virtual Currency event.
  public func earnVirtualCurrency(
    currencyName: String,
    value: Double,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "earn_virtual_currency",
      parameters: EarnVirtualCurrencyParameters(
        currencyName: currencyName,
        value: value,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }

  /// Spend Virtual Currency event.
  ///
  /// This event tracks the sale of virtual goods in your app and can help you identify which virtual goods are the most popular objects of purchase.
  public func spendVirtualCurrency(
    itemName: String,
    currencyName: String,
    value: Double,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil
  ) async throws {
    let event = Event(
      name: "spend_virtual_currency",
      parameters: SpendVirtualCurrencyParameters(
        itemName: itemName,
        currencyName: currencyName,
        value: value,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
    try await log(for: event)
  }
}

struct EarnVirtualCurrencyParameters: Encodable {
  var currencyName: String
  var value: Double
  var sessionId: String?
  var engagementTime: TimeInterval?
  
  private enum CodingKeys: String, CodingKey {
    case currencyName = "virtual_currency_name"
    case value
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.currencyName, forKey: .currencyName)
    try container.encode(self.value, forKey: .value)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(self.engagementTime.map { $0 * 1_000_000 }?.description, forKey: .engagementTime)
  }
}

struct SpendVirtualCurrencyParameters: Encodable {
  var itemName: String
  var currencyName: String
  var value: Double
  var sessionId: String?
  var engagementTime: TimeInterval?
  
  private enum CodingKeys: String, CodingKey {
    case itemName = "item_name"
    case currencyName = "virtual_currency_name"
    case value
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.itemName, forKey: .itemName)
    try container.encode(self.currencyName, forKey: .currencyName)
    try container.encode(self.value, forKey: .value)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(self.engagementTime.map { $0 * 1_000_000 }?.description, forKey: .engagementTime)
  }
}


struct PostScoreParameters: Encodable {
  var score: UInt
  var level: UInt?
  var character: String?
  var sessionId: String?
  var engagementTime: TimeInterval?
  
  private enum CodingKeys: String, CodingKey {
    case score
    case level
    case character
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.score, forKey: .score)
    try container.encodeIfPresent(self.level, forKey: .level)
    try container.encodeIfPresent(self.character, forKey: .character)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(self.engagementTime.map { $0 * 1_000_000 }?.description, forKey: .engagementTime)
  }
}

struct LevelUpParametes: Encodable {
  var level: UInt
  var character: String?
  var sessionId: String?
  var engagementTime: TimeInterval?
  
  private enum CodingKeys: String, CodingKey {
    case level
    case character
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.level, forKey: .level)
    try container.encodeIfPresent(self.character, forKey: .character)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(self.engagementTime.map { $0 * 1_000_000 }?.description, forKey: .engagementTime)
  }
}

struct LevelEndParametes: Encodable {
  var levelName: String
  var success: Bool /// TODO - should be a int? 0 or 1
  var sessionId: String?
  var engagementTime: TimeInterval?

  private enum CodingKeys: String, CodingKey {
    case levelName = "level_name"
    case success
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.levelName, forKey: .levelName)
    try container.encode(self.success, forKey: .success)
    try container.encodeIfPresent(self.sessionId, forKey: .sessionId)
    try container.encodeIfPresent(self.engagementTime.map { $0 * 1_000_000 }?.description, forKey: .engagementTime)
  }
}

