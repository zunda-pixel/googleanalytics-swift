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
    try await client.log(
      for: Event.userEngagement(
        sessionId: "SessionID",
        engagementTime: 100000,
        timestamp: .now
      )
    )
  }

  @Test
  func login() async throws {
    try await client.log(
      for: Event.login(
        method: "Password",
        sessionId: UUID().uuidString,
        engagementTime: 100000,
        timestamp: .now
      )
    )
  }

  @Test
  func appOpenToPurchaseItem() async throws {
    let sessionId = UUID().uuidString
    let transactionId = UUID().uuidString

    try await client.log(for: [
      Event.sessionStart(sessionId: sessionId, engagementTime: 0),
      Event.appOpen(sessionId: sessionId, engagementTime: 1),
      Event.screenView(name: "TutorialView", sessionId: sessionId, engagementTime: 1),
      Event.tutorialBegin(sessionId: sessionId, engagementTime: 3),
      Event.tutorialComplete(sessionId: sessionId, engagementTime: 6),
      Event.screenView(name: "TopView", sessionId: sessionId),
      Event.screenView(name: "SearchView", sessionId: sessionId),
      Event.search(term: "Beer", sessionId: sessionId),
      Event.viewSearchResults(term: "Beer", sessionId: sessionId),
      Event.selectItem(items: [.beer(quantiry: 2)], sessionId: sessionId),
      Event.addToWithlist(items: [.beer(quantiry: 2)], sessionId: sessionId),
      Event.screenView(name: "WithlistView", sessionId: sessionId),
      Event.addToCart(items: [.beer(quantiry: 2)], sessionId: sessionId),
      Event.screenView(name: "CartView", sessionId: sessionId),
      Event.viewCart(items: [.beer(quantiry: 2)], sessionId: sessionId),
      Event.removeFromCart(items: [.beer(quantiry: 1)], sessionId: sessionId),
      Event.beginCheckout(items: [.beer(quantiry: 2)]),
      Event.addPaymentInfo(
        paymentType: "CreditCard",
        items: [.beer(quantiry: 2)],
        sessionId: sessionId
      ),
      Event.purchase(
        transactionId: transactionId,
        coupon: "BeerCoupon123",
        tax: 1.99,
        shipping: 2.99 * 2,
        items: [.beer(quantiry: 2)],
        sessionId: sessionId
      ),
      Event.refund(
        transactionId: transactionId,
        items: [.beer(quantiry: 2)],
        sessionId: sessionId
      ),
    ])
  }

  @Test
  func gameEvent() async throws {
    let sessionId = UUID().uuidString
    try await client.log(for: [
      Event.levelStart(levelName: "Level 1", sessionId: sessionId),
      Event.postScore(score: 100, sessionId: sessionId),
      Event.levelEnd(levelName: "Level 1", success: true, sessionId: sessionId),
      Event.levelUp(level: 2, sessionId: sessionId),
      Event.unlockAchievement(achievementId: UUID().uuidString, sessionId: sessionId),
      Event.earnVirtualCurrency(currencyName: "Rupee", value: 123, sessionId: sessionId),
      Event.spendVirtualCurrency(
        itemName: "NewItem",
        currencyName: "Rupee",
        value: 56,
        sessionId: sessionId
      ),
    ])
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
