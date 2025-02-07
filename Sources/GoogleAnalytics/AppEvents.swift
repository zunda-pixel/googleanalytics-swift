extension GoogleAnalytics {
  /// Login event.
  ///
  /// Apps with a login feature can report this event to signify that a user has logged in.
  public func login(method: String) async throws {
    let event = Event(
      name: "login",
      parameters: ["method": method]
    )
    
    try await log(for: event)
  }
  
  /// Sign Up event.
  ///
  /// This event indicates that a user has signed up for an account in your app.
  /// The parameter signifies the method by which the user signed up.
  /// Use this event to understand the different behaviors between logged in and logged out users.
  public func signUp(method: String) async throws {
    let event = Event(
      name: "sign_up",
      parameters: ["method": method]
    )
    
    try await log(for: event)
  }

  /// App Open event.
  ///
  /// By logging this event when an App becomes active, developers can understand how often users leave and return during the course of a Session.
  /// Although Sessions are automatically reported, this event can provide further clarification around the continuous engagement of app-users.
  public func appOpen() async throws {
    let event = Event<Never?>(
      name: "app_open",
      parameters: nil
    )
    
    try await log(for: event)
  }
  
  /// Screen View event.
  ///
  /// This event signifies a screen view.
  /// Use this when a screen transition occurs.
  /// This event can be logged irrespective of whether automatic screen tracking is enabled.
  public func screenView(
    name: String? = nil,
    className: String? = nil
  ) async throws {
    let event = Event(
      name: "_vs",
      parameters: [
        "screen_name": name,
        "screen_class": className
      ]
    )
    
    try await log(for: event)
  }
  
  /// Search event.
  ///
  /// Apps that support search features can use this event to contextualize search operations by supplying the appropriate, corresponding parameters.
  /// This event can help you identify the most popular content in your app.
  public func search(
    term: String
  ) async throws {
    let event = Event(
      name: "search",
      parameters: [
        "search_term": term
      ]
    )
    
    try await log(for: event)
  }
  
  /// Select Content event.
  ///
  /// This general purpose event signifies that a user has selected some content of a certain type in an app.
  /// The content can be any object in your app. This event can help you identify popular content and categories of content in your app.
  public func selectContent(
    itemId: String,
    contentType: String
  ) async throws {
    let event = Event(
      name: "select_content",
      parameters: [
        "item_id": itemId,
        "content_type": contentType
      ]
    )
    
    try await log(for: event)
  }
  
  /// Select Item event.
  ///
  /// This event signifies that an item was selected by a user from a list.
  /// Use the appropriate parameters to contextualize the event.
  /// Use this event to discover the most popular items selected.
  public func selectItem(
    items: [Item],
    listId: String? = nil,
    listName: String? = nil
  ) async throws {
    let event = Event(
      name: "select_item",
      parameters: ItemListParameters(
        items: items,
        listId: listId,
        listName: listName
      )
    )
    
    try await log(for: event)
  }

  /// Select promotion event.
  ///
  /// This event signifies that a user has selected a promotion offer.
  /// Use the appropriate parameters to contextualize the event, such as the item(s) for which the promotion applies.
  public func selectPromotion(
    id promotionId: String? = nil,
    name promotionName: String? = nil,
    creativeName: String? = nil,
    creativeSlot: String? = nil,
    items: [Item]
  ) async throws {
    let event = Event(
      name: "select_promotion",
      parameters: PromotionParameters(
        id: promotionId,
        name: promotionName,
        creativeName: creativeName,
        creativeSlot: creativeSlot,
        items: items
      )
    )
    try await log(for: event)
  }
  
  /// Share event.
  ///
  /// Apps with social features can log the Share event to identify the most viral content.
  public func share(
    method: String,
    itemId: String,
    contentType: String
  ) async throws {
    let event = Event(
      name: "share",
      parameters: [
        "method": method,
        "item_id": itemId,
        "content_type": contentType
      ]
    )
    
    try await log(for: event)
  }
  
  /// Tutorial Begin event.
  ///
  /// This event signifies the start of the on-boarding process in your app.
  /// Use this in a funnel with tutorialComplete to understand how many users complete this process and move on to the full app experience.
  public func tutorialBegin() async throws {
    let event = Event<Never?>(
      name: "tutorial_begin",
      parameters: nil
    )
    try await log(for: event)
  }
  
  /// Tutorial End event.
  ///
  /// Use this event to signify the user's completion of your app's on-boarding process.
  /// Add this to a funnel with tutorialBegin to gauge the completion rate of your on-boarding process.
  public func tutorialComplete() async throws {
    let event = Event<Never?>(
      name: "tutorial_complete",
      parameters: nil
    )
    try await log(for: event)
  }
  
  /// View Item event.
  ///
  /// This event signifies that a user has viewed an item.
  /// Use the appropriate parameters to contextualize the event.
  /// Use this event to discover the most popular items viewed in your app.
  public func viewItem(
    items: [Item],
    price: Price? = nil
  ) async throws {
    let event = Event(
      name: "view_item",
      parameters: ViewItemParameters(items: items, price: price)
    )
    
    try await log(for: event)
  }
  
  /// View Item List event.
  ///
  /// Log this event when a user sees a list of items or offerings.
  public func viewItemList(
    items: [Item],
    listId: String? = nil,
    listName: String? = nil
  ) async throws {
    let event = Event(
      name: "view_item_list",
      parameters: ItemListParameters(
        items: items,
        listId: listId,
        listName: listName
      )
    )
    try await log(for: event)
  }
  
  /// View Search Results event.
  ///
  /// Log this event when the user has been presented with the results of a search.
  public func viewSearchResults(
    term: String
  ) async throws {
    let event = Event(
      name: "view_search_results",
      parameters: [
        "search_term": term
      ]
    )
    try await log(for: event)
  }
  
  /// Join Group event.
  ///
  /// Log this event when a user joins a group such as a guild, team or family.
  /// Use this event to analyze how popular certain groups or social features are in your app.
  public func joinGroup(
    id groupId: String
  ) async throws {
    let event = Event(
      name: "join_group",
      parameters: [
        "group_id": groupId
      ]
    )
    try await log(for: event)
  }
}

struct ViewItemParameters: Encodable {
  var items: [Item]
  var price: Price?
  
  private enum CodingKeys: CodingKey {
    case items
    case currency
    case value
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(items, forKey: .items)
    try container.encodeIfPresent(price?.currency.rawValue.uppercased(), forKey: .currency)
    try container.encodeIfPresent(price?.value, forKey: .value)
  }
}

struct PromotionParameters: Encodable {
  var id: String?
  var name: String?
  var creativeName: String?
  var creativeSlot: String?
  var items: [Item]
  
  private enum CodingKeys: String, CodingKey {
    case id = "promotion_id"
    case name = "promotion_name"
    case creativeName = "creative_name"
    case creativeSlot = "creative_slot"
    case items
  }
}

struct ItemListParameters: Encodable {
  var items: [Item]
  var listId: String?
  var listName: String?
  private enum CodingKeys: String, CodingKey {
    case items
    case listId = "item_list_id"
    case listName = "item_list_name"
  }
}
