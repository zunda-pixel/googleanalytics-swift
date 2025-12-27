import Foundation
import MemberwiseInit

extension Event {
  /// Login event.
  ///
  /// Apps with a login feature can report this event to signify that a user has logged in.
  public static func login(
    method: String,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "login",
      timestamp: timestamp,
      parameters: [
        "method": method,
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description,
      ]
    )
  }

  /// Sign Up event.
  ///
  /// This event indicates that a user has signed up for an account in your app.
  /// The parameter signifies the method by which the user signed up.
  /// Use this event to understand the different behaviors between logged in and logged out users.
  public static func signUp(
    method: String,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "sign_up",
      timestamp: timestamp,
      parameters: [
        "method": method,
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description,
      ]
    )
  }

  /// Session Start event.
  public static func sessionStart(
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "app_open",
      timestamp: timestamp,
      parameters: [
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description,
      ]
    )
  }

  /// App Open event.
  ///
  /// By logging this event when an App becomes active, developers can understand how often users leave and return during the course of a Session.
  /// Although Sessions are automatically reported, this event can provide further clarification around the continuous engagement of app-users.
  public static func appOpen(
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "app_open",
      timestamp: timestamp,
      parameters: [
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description,
      ]
    )
  }

  /// Screen View event.
  ///
  /// This event signifies a screen view.
  /// Use this when a screen transition occurs.
  /// This event can be logged irrespective of whether automatic screen tracking is enabled.
  public static func screenView(
    name: String? = nil,
    className: String? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "screen_view",
      timestamp: timestamp,
      parameters: [
        "screen_name": name,
        "screen_class": className,
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description,
      ]
    )
  }

  /// Search event.
  ///
  /// Apps that support search features can use this event to contextualize search operations by supplying the appropriate, corresponding parameters.
  /// This event can help you identify the most popular content in your app.
  public static func search(
    term: String,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "search",
      timestamp: timestamp,
      parameters: [
        "search_term": term,
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description,
      ]
    )
  }

  /// Select Content event.
  ///
  /// This general purpose event signifies that a user has selected some content of a certain type in an app.
  /// The content can be any object in your app. This event can help you identify popular content and categories of content in your app.
  public static func selectContent(
    itemId: String,
    contentType: String,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "select_content",
      timestamp: timestamp,
      parameters: [
        "item_id": itemId,
        "content_type": contentType,
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description,
      ]
    )
  }

  /// Select Item event.
  ///
  /// This event signifies that an item was selected by a user from a list.
  /// Use the appropriate parameters to contextualize the event.
  /// Use this event to discover the most popular items selected.
  public static func selectItem(
    items: [Item],
    listId: String? = nil,
    listName: String? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
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
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
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

  /// Share event.
  ///
  /// Apps with social features can log the Share event to identify the most viral content.
  public static func share(
    method: String,
    itemId: String,
    contentType: String,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "share",
      timestamp: timestamp,
      parameters: [
        "method": method,
        "item_id": itemId,
        "content_type": contentType,
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description,
      ]
    )
  }

  /// Tutorial Begin event.
  ///
  /// This event signifies the start of the on-boarding process in your app.
  /// Use this in a funnel with tutorialComplete to understand how many users complete this process and move on to the full app experience.
  public static func tutorialBegin(
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "tutorial_begin",
      timestamp: timestamp,
      parameters: [
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description,
      ]
    )
  }

  /// Tutorial End event.
  ///
  /// Use this event to signify the user's completion of your app's on-boarding process.
  /// Add this to a funnel with tutorialBegin to gauge the completion rate of your on-boarding process.
  public static func tutorialComplete(
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "tutorial_complete",
      timestamp: timestamp,
      parameters: [
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description,
      ]
    )
  }

  /// View Item event.
  ///
  /// This event signifies that a user has viewed an item.
  /// Use the appropriate parameters to contextualize the event.
  /// Use this event to discover the most popular items viewed in your app.
  public static func viewItem(
    items: [Item],
    price: Price? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
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

  /// View Item List event.
  ///
  /// Log this event when a user sees a list of items or offerings.
  public static func viewItemList(
    items: [Item],
    listId: String? = nil,
    listName: String? = nil,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
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

  /// View Search Results event.
  ///
  /// Log this event when the user has been presented with the results of a search.
  public static func viewSearchResults(
    term: String,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "view_search_results",
      timestamp: timestamp,
      parameters: [
        "search_term": term,
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description,
      ]
    )
  }

  /// Join Group event.
  ///
  /// Log this event when a user joins a group such as a guild, team or family.
  /// Use this event to analyze how popular certain groups or social features are in your app.
  public static func joinGroup(
    id groupId: String,
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "join_group",
      timestamp: timestamp,
      parameters: [
        "group_id": groupId,
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description,
      ]
    )
  }
}

@MemberwiseInit(.public)
public struct ViewItemParameters: Encodable {
  public var items: [Item]
  public var price: Price?
  public var sessionId: String?
  public var engagementTime: TimeInterval?

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
    try container.encodeIfPresent(sessionId, forKey: .sessionId)
    try container.encodeIfPresent(
      engagementTime.map { $0 * 1_000_000 }?.description,
      forKey: .engagementTimeMsec
    )
  }
}

@MemberwiseInit(.public)
public struct PromotionParameters: Encodable {
  public var id: String?
  public var name: String?
  public var creativeName: String?
  public var creativeSlot: String?
  public var items: [Item]
  public var sessionId: String?
  public var engagementTime: TimeInterval?

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
    try container.encodeIfPresent(sessionId, forKey: .sessionId)
    try container.encodeIfPresent(
      engagementTime.map { $0 * 1_000_000 }?.description,
      forKey: .engagementTimeMsec
    )
  }
}

@MemberwiseInit(.public)
public struct ItemListParameters: Encodable {
  public var items: [Item]
  public var listId: String?
  public var listName: String?
  public var sessionId: String?
  public var engagementTime: TimeInterval?

  private enum CodingKeys: String, CodingKey {
    case items
    case listId = "item_list_id"
    case listName = "item_list_name"
    case sessionId = "session_id"
    case engagementTimeMsec = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(items, forKey: .items)
    try container.encodeIfPresent(listId, forKey: .listId)
    try container.encodeIfPresent(listName, forKey: .listName)
    try container.encodeIfPresent(sessionId, forKey: .sessionId)
    try container.encodeIfPresent(
      engagementTime.map { $0 * 1_000_000 }?.description,
      forKey: .engagementTimeMsec
    )
  }
}
