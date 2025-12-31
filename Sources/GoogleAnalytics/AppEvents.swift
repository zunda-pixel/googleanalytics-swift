import Foundation
import MemberwiseInit

extension Event {
  /// Login event.
  ///
  /// Apps with a login feature can report this event to signify that a user has logged in.
  public static func login(
    method: String,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "login",
      timestamp: timestamp,
      parameters: LoginSignUpParameters(
        method: method,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// Sign Up event.
  ///
  /// This event indicates that a user has signed up for an account in your app.
  /// The parameter signifies the method by which the user signed up.
  /// Use this event to understand the different behaviors between logged in and logged out users.
  public static func signUp(
    method: String,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "sign_up",
      timestamp: timestamp,
      parameters: LoginSignUpParameters(
        method: method,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

struct LoginSignUpParameters: Encodable {
  var method: String
  var sessionId: String
  var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case method
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(method, forKey: .method)
    try container.encode(sessionId, forKey: .sessionId)
    try container.encode(engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

extension Event {
  /// Session Start event.
  public static func sessionStart(
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "app_open",
      timestamp: timestamp,
      parameters: SessionStartParameters(
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

struct SessionStartParameters: Encodable {
  var sessionId: String
  var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(sessionId, forKey: .sessionId)
    try container.encode(engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

extension Event {
  /// App Open event.
  ///
  /// By logging this event when an App becomes active, developers can understand how often users leave and return during the course of a Session.
  /// Although Sessions are automatically reported, this event can provide further clarification around the continuous engagement of app-users.
  public static func appOpen(
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "app_open",
      timestamp: timestamp,
      parameters: AppOpenParameters(
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

struct AppOpenParameters: Encodable {
  var sessionId: String
  var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(sessionId, forKey: .sessionId)
    try container.encode(engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

extension Event {
  /// Screen View event.
  ///
  /// This event signifies a screen view.
  /// Use this when a screen transition occurs.
  /// This event can be logged irrespective of whether automatic screen tracking is enabled.
  public static func screenView(
    name: String,
    className: String,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "screen_view",
      timestamp: timestamp,
      parameters: ScreenViewParameters(
        name: name,
        className: className,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

struct ScreenViewParameters: Encodable {
  var name: String
  var className: String
  var sessionId: String
  var engagementTime: TimeInterval

  enum CodingKeys: String, CodingKey {
    case screenName = "screen_name"
    case screenClass = "screen_class"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .screenName)
    try container.encode(className, forKey: .screenClass)
    try container.encode(sessionId, forKey: .sessionId)
    try container.encode(engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

extension Event {
  /// Search event.
  ///
  /// Apps that support search features can use this event to contextualize search operations by supplying the appropriate, corresponding parameters.
  /// This event can help you identify the most popular content in your app.
  public static func search(
    term: String,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "search",
      timestamp: timestamp,
      parameters: SearchParameters(
        term: term,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

struct SearchParameters: Encodable {
  var term: String
  var sessionId: String
  var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case searchTerm = "search_term"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(term, forKey: .searchTerm)
    try container.encode(sessionId, forKey: .sessionId)
    try container.encode(engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

extension Event {
  /// Select Content event.
  ///
  /// This general purpose event signifies that a user has selected some content of a certain type in an app.
  /// The content can be any object in your app. This event can help you identify popular content and categories of content in your app.
  public static func selectContent(
    itemId: String,
    contentType: String,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "select_content",
      timestamp: timestamp,
      parameters: SearchContentParamters(
        itemId: itemId,
        contentType: contentType,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

struct SearchContentParamters: Encodable {
  var itemId: String
  var contentType: String
  var sessionId: String
  var engagementTime: TimeInterval

  enum CodingKeys: String, CodingKey {
    case itemId = "item_id"
    case contentType = "content_type"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.itemId, forKey: .itemId)
    try container.encode(self.contentType, forKey: .contentType)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

extension Event {
  /// Select Item event.
  ///
  /// This event signifies that an item was selected by a user from a list.
  /// Use the appropriate parameters to contextualize the event.
  /// Use this event to discover the most popular items selected.
  public static func selectItem(
    items: [Item],
    listId: String? = nil,
    listName: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "select_item",
      timestamp: timestamp,
      parameters: ItemListParameters(
        items: items,
        listId: listId,
        listName: listName,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// Select promotion event.
  ///
  /// This event signifies that a user has selected a promotion offer.
  /// Use the appropriate parameters to contextualize the event, such as the item(s) for which the promotion applies.
  public static func selectPromotion(
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
      name: "select_promotion",
      timestamp: timestamp,
      parameters: PromotionParameters(
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

extension Event {
  /// Share event.
  ///
  /// Apps with social features can log the Share event to identify the most viral content.
  public static func share(
    method: String,
    itemId: String,
    contentType: String,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "share",
      timestamp: timestamp,
      parameters: ShareParameters(
        method: method,
        itemId: itemId,
        contentType: contentType,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

struct ShareParameters: Encodable {
  var method: String
  var itemId: String
  var contentType: String
  var sessionId: String
  var engagementTime: TimeInterval

  enum CodingKeys: String, CodingKey {
    case method
    case itemId = "item_id"
    case contentType = "content_type"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.method, forKey: .method)
    try container.encode(self.itemId, forKey: .itemId)
    try container.encode(self.contentType, forKey: .contentType)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

extension Event {
  /// Tutorial Begin event.
  ///
  /// This event signifies the start of the on-boarding process in your app.
  /// Use this in a funnel with tutorialComplete to understand how many users complete this process and move on to the full app experience.
  public static func tutorialBegin(
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "tutorial_begin",
      timestamp: timestamp,
      parameters: TutorialBeginParameters(
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

struct TutorialBeginParameters: Encodable {
  var sessionId: String
  var engagementTime: TimeInterval

  enum CodingKeys: String, CodingKey {
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

extension Event {
  /// Tutorial End event.
  ///
  /// Use this event to signify the user's completion of your app's on-boarding process.
  /// Add this to a funnel with tutorialBegin to gauge the completion rate of your on-boarding process.
  public static func tutorialComplete(
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "tutorial_complete",
      timestamp: timestamp,
      parameters: TutoriaCompleteParameters(
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

struct TutoriaCompleteParameters: Encodable {
  var sessionId: String
  var engagementTime: TimeInterval

  enum CodingKeys: String, CodingKey {
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

extension Event {
  /// View Item event.
  ///
  /// This event signifies that a user has viewed an item.
  /// Use the appropriate parameters to contextualize the event.
  /// Use this event to discover the most popular items viewed in your app.
  public static func viewItem(
    items: [Item],
    price: Price? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "view_item",
      timestamp: timestamp,
      parameters: ViewItemParameters(
        items: items,
        price: price,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// View Item List event.
  ///
  /// Log this event when a user sees a list of items or offerings.
  public static func viewItemList(
    items: [Item],
    listId: String? = nil,
    listName: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "view_item_list",
      timestamp: timestamp,
      parameters: ItemListParameters(
        items: items,
        listId: listId,
        listName: listName,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// View Search Results event.
  ///
  /// Log this event when the user has been presented with the results of a search.
  public static func viewSearchResults(
    term: String,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "view_search_results",
      timestamp: timestamp,
      parameters: ViewSearchResultsParameters(
        searchTerm: term,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

struct ViewSearchResultsParameters: Encodable {
  var searchTerm: String
  var sessionId: String
  var engagementTime: TimeInterval

  enum CodingKeys: String, CodingKey {
    case searchTerm = "search_term"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.searchTerm, forKey: .searchTerm)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

extension Event {
  /// Join Group event.
  ///
  /// Log this event when a user joins a group such as a guild, team or family.
  /// Use this event to analyze how popular certain groups or social features are in your app.
  public static func joinGroup(
    id groupId: String,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "join_group",
      timestamp: timestamp,
      parameters: JoinGroupParameters(
        groupId: groupId,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

struct JoinGroupParameters: Encodable {
  var groupId: String
  var sessionId: String
  var engagementTime: TimeInterval

  enum CodingKeys: String, CodingKey {
    case groupId = "group_id"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.groupId, forKey: .groupId)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

@MemberwiseInit(.public)
public struct ViewItemParameters: Encodable {
  public var items: [Item]
  public var price: Price?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case items
    case currency
    case value
    case sessionId = "session_id"
    case engagementTimeMsec = "engagement_time_msec"
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(items, forKey: .items)
    try container.encodeIfPresent(price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encodeIfPresent(price?.value, forKey: .value)
    try container.encode(sessionId, forKey: .sessionId)
    try container.encode(engagementTime * 1_000_000, forKey: .engagementTimeMsec)
  }
}

@MemberwiseInit(.public)
public struct PromotionParameters: Encodable {
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
    case engagementTimeMsec = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(id, forKey: .id)
    try container.encodeIfPresent(name, forKey: .name)
    try container.encodeIfPresent(creativeName, forKey: .creativeName)
    try container.encodeIfPresent(creativeSlot, forKey: .creativeSlot)
    try container.encode(items, forKey: .items)
    try container.encode(sessionId, forKey: .sessionId)
    try container.encode(engagementTime * 1_000_000, forKey: .engagementTimeMsec)
  }
}

@MemberwiseInit(.public)
public struct ItemListParameters: Encodable {
  public var items: [Item]
  public var listId: String?
  public var listName: String?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case items
    case listId = "item_list_id"
    case listName = "item_list_name"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(items, forKey: .items)
    try container.encodeIfPresent(listId, forKey: .listId)
    try container.encodeIfPresent(listName, forKey: .listName)
    try container.encode(sessionId, forKey: .sessionId)
    try container.encode(engagementTime * 1_000_000, forKey: .engagementTime)
  }
}
