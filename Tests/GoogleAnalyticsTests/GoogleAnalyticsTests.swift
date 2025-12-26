import Foundation
import Testing

@testable import GoogleAnalytics

@Suite
struct GoogleAnalyticsTests {
  let client = GoogleAnalytics(
    httpClient: .urlSession(.shared),
    appId: ProcessInfo.processInfo.environment["APP_ID"]!,
    apiSecret: ProcessInfo.processInfo.environment["API_SECRET"]!,
    appInstanceId: ProcessInfo.processInfo.environment["APP_INSTANCE_ID"]!,
    measurementId: ProcessInfo.processInfo.environment["MEASTUREMENT_ID"],
    userId: "555666777888",
    userData: UserData(
      emailAddress: ["test@example.com"],
      phoneNumbers: ["08001234567"],
      address: [
        Address(
          firstName: "Fist Name",
          lastName: "Last Name",
          street: "1234 Street",
          city: "City",
          region: "Region",
          postalCode: "1234567",
          country: "US"
        )
      ]
    ),
    consent: Consent(
      adUserData: .granted,
      adPersonalization: .granted
    ),
    userLocation: UserLocation(
      city: "Tokyo",
      regionID: .jpn,
      countryID: .jp,
      subcontinentID: .southernAsia,
      continentID: nil
    ),
    ipOverride: nil,
    device: .init(
      category: .deskop,
      language: try! .init("jpn"),
      screenResolution: .init(width: 1080, height: 1920),
      os: .init(name: "macOS Tahoe", verison: "26.2"),
      model: "Mac mini M4",
      brand: "Apple",
      browser: Browswer(
        name: "Safari",
        verison: "Version 26.3 (21623.2.2.11.1)"
      )
    )
  )

  @Test
  func validatePayload() async throws {
    struct Parameters: Encodable {
      var method: String
    }
    let loginEvent = Event(
      name: "login",
      timestamp: .now,
      parameters: [
        "key": "value1",
        "session_id": UUID().uuidString,
        "engagement_time_msec": "100",
      ]
    )

    let messages = try await client.validatePayload(for: [loginEvent])
    #expect(messages.isEmpty)
    print(messages)
  }

  @Test
  func userEngagement() async throws {
    try await client.log(for: .userEngagement(
      sessionId: "SessionID",
      engagementTime: 100000,
      timestamp: .now
    ))
  }

  @Test
  func login() async throws {
    try await client.log(for: .login(
      method: "Password",
      sessionId: UUID().uuidString,
      engagementTime: 100000,
      timestamp: .now
    ))
  }

  @Test
  func appOpenToPurchaseItem() async throws {
    let sessionId = UUID().uuidString
    try await client.log(for: .sessionStart(sessionId: sessionId, engagementTime: 0))
    try await client.log(for: .appOpen(sessionId: sessionId, engagementTime: 1))
    try await client.log(for: .screenView(name: "TutorialView", sessionId: sessionId, engagementTime: 1))
    try await client.log(for: .tutorialBegin(sessionId: sessionId, engagementTime: 3))
    try await client.log(for: .tutorialComplete(sessionId: sessionId, engagementTime: 6))
    try await client.log(for: .screenView(name: "TopView", sessionId: sessionId))
    try await client.log(for: .screenView(name: "SearchView", sessionId: sessionId))
    try await client.log(for: .search(term: "Beer", sessionId: sessionId))
    try await client.log(for: .viewSearchResults(term: "Beer", sessionId: sessionId))
    try await client.log(for: .selectItem(items: [.beer(quantiry: 2)], sessionId: sessionId))
    try await client.log(for: .addToWithlist(items: [.beer(quantiry: 2)], sessionId: sessionId))
    try await client.log(for: .screenView(name: "WithlistView", sessionId: sessionId))
    try await client.log(for: .addToCart(items: [.beer(quantiry: 2)], sessionId: sessionId))
    try await client.log(for: .screenView(name: "CartView", sessionId: sessionId))
    try await client.log(for: .viewCart(items: [.beer(quantiry: 2)], sessionId: sessionId))
    try await client.log(for: .removeFromCart(items: [.beer(quantiry: 1)], sessionId: sessionId))
    try await client.log(for: .beginCheckout(items: [.beer(quantiry: 2)]))
    let transactionId = UUID().uuidString
    try await client.log(for: .addPaymentInfo(
      paymentType: "CreditCard",
      items: [.beer(quantiry: 2)],
      sessionId: sessionId
    ))
    try await client.log(for: .addShippingInfo(
      coupon: "BeerCoupon123",
      items: [.beer(quantiry: 2)],
      sessionId: sessionId
    ))
    try await client.log(for: .purchase(
      transactionId: transactionId,
      coupon: "BeerCoupon123",
      tax: 1.99,
      shipping: 2.99 * 2,
      items: [.beer(quantiry: 2)],
      sessionId: sessionId
    ))
    try await client.log(for: .refund(
      transactionId: transactionId,
      items: [.beer(quantiry: 2)],
      sessionId: sessionId
    ))
  }

  @Test
  func gameEvent() async throws {
    let sessionId = UUID().uuidString
    try await client.log(for: .levelStart(levelName: "Level 1", sessionId: sessionId))
    try await client.log(for: .postScore(score: 100, sessionId: sessionId))
    try await client.log(for: .levelEnd(levelName: "Level 1", success: true, sessionId: sessionId))
    try await client.log(for: .levelUp(level: 2, sessionId: sessionId))
    try await client.log(for: .unlockAchievement(achievementId: UUID().uuidString, sessionId: sessionId))
    try await client.log(for: .earnVirtualCurrency(currencyName: "Rupee", value: 123, sessionId: sessionId))
    try await client.log(for: .spendVirtualCurrency(
      itemName: "NewItem",
      currencyName: "Rupee",
      value: 56,
      sessionId: sessionId
    ))
  }
}

extension Item {
  static func beer(quantiry: UInt) -> Item {
    Item(
      id: UUID().uuidString,
      name: "IPA Beer",
      affiliation: "Beer Store",
      category: "Alchol",
      category2: "Beer",
      category3: "IPA",
      category4: nil,
      category5: nil,
      variant: "24 Pack",
      brand: "Beer Brand",
      price: Price(currency: .usd, value: 2.99),
      discount: 1.99,
      index: nil,
      quantity: quantiry,
      coupon: nil,
      listId: nil,
      listName: nil,
      locationId: nil
    )
  }
}
