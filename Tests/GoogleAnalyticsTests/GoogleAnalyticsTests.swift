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
  
  
  func allEvents(sessionId: String) -> [Event] {
    [
      Event.adImpression(
        platform: "macOS",
        format: "Format",
        source: "Source",
        unitName: "UnitName",
        price: .init(currency: .yer, value: 100),
        sessionId: sessionId,
        engagementTime: 10000
      ),
      Event.adImpression(
        platform: "iOS",
        format: "Format",
        source: "Source",
        unitName: "UnitName",
        price: .init(currency: .yer, value: 100),
        sessionId: sessionId,
        engagementTime: 10000,
        timestamp: .now
      ),
      Event.login(method: "Email", sessionId: sessionId, engagementTime: 10000),
      Event.login(method: "Email", sessionId: sessionId, engagementTime: 10000, timestamp: .now),
      Event.signUp(method: "Email", sessionId: sessionId, engagementTime: 10000),
      Event.sessionStart(sessionId: sessionId, engagementTime: 100000),
      Event.sessionStart(sessionId: sessionId, engagementTime: 100000, timestamp: .now),
      Event.appOpen(sessionId: sessionId, engagementTime: 10000),
      Event.screenView(name: "ScreenName", className: "ClassName", sessionId: sessionId, engagementTime: 10000),
      Event.screenView(name: "ScreenName", className: "ClassName", sessionId: sessionId, engagementTime: 10000, timestamp: .now),
      Event.search(term: "Term", sessionId: sessionId, engagementTime: 10000),
      Event.search(term: "Term", sessionId: sessionId, engagementTime: 10000, timestamp: .now),
      Event.selectContent(itemId: "ItemId", contentType: "Book", sessionId: sessionId, engagementTime: 10000),
      Event.selectContent(itemId: "ItemId", contentType: "Book", sessionId: sessionId, engagementTime: 10000, timestamp: .now),
      Event.share(method: "Native", itemId: "ItemId", contentType: "ContentType", sessionId: sessionId, engagementTime: 1),
      Event.share(method: "Native", itemId: "ItemId", contentType: "ContentType", sessionId: sessionId, engagementTime: 1, timestamp: .now),
      Event.tutorialBegin(sessionId: sessionId, engagementTime: 10),
      Event.tutorialBegin(sessionId: sessionId, engagementTime: 10, timestamp: .now),
      Event.tutorialComplete(sessionId: sessionId, engagementTime: 100),
      Event.tutorialComplete(sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.viewSearchResults(term: "Term", sessionId: sessionId, engagementTime: 100),
      Event.viewSearchResults(term: "Term", sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.joinGroup(id: "GroupID", sessionId: sessionId, engagementTime: 100),
      Event.joinGroup(id: "GroupID", sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.levelStart(levelName: "LevelName", sessionId: sessionId, engagementTime: 100),
      Event.levelStart(levelName: "LevelName", sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.unlockAchievement(achievementId: "AchivementId", sessionId: sessionId, engagementTime: 100),
      Event.unlockAchievement(achievementId: "AchivementId", sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.campaignDetails(
        source: "Source",
        medium: "Medium",
        campaign: "Campaign",
        term: "Term",
        adNetworkClickId: "AdNetworkClickId",
        campaignId: "CampaignId",
        campaignContent: "CampaignContent",
        campaignCustomData: "CampaignCustomData",
        creativeFormat: "CreativeFormat",
        marketingTactic: "MarketingTactic",
        sourcePlatform: "SourcePlatform",
        sessionId: sessionId,
        engagementTime: 100
      ),
      Event.campaignDetails(
        source: "Source",
        medium: "Medium",
        campaign: "Campaign",
        term: "Term",
        adNetworkClickId: "AdNetworkClickId",
        campaignId: "CampaignId",
        campaignContent: "CampaignContent",
        campaignCustomData: "CampaignCustomData",
        creativeFormat: "CreativeFormat",
        marketingTactic: "MarketingTactic",
        sourcePlatform: "SourcePlatform",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.selectItem(items: [.beer(quantiry: 10)], listId: "ListId", listName: "ListName", sessionId: sessionId, engagementTime: 10000, timestamp: .now),
      Event.selectPromotion(
        id: "PromotionId",
        name: "PromotionName",
        creativeName: "CreativeName",
        creativeSlot: "CreativeSlot",
        items: [.beer(
          quantiry: 10
        )],
        sessionId: sessionId,
        engagementTime: 10000,
        timestamp: .now
      ),
      Event.viewItem(
        items: [.beer(quantiry: 10)],
        price: .init(currency: .yer, value: 100),
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.viewItemList(
        items: [.beer(quantiry: 10)],
        listId: "ListId",
        listName: "ListName",
        sessionId: sessionId,
        engagementTime: 10,
        timestamp: .now
      ),
      Event.closeConvertLead(price: Price(currency: .yer, value: 100), sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.closeUnConvertLead(price: Price(currency: .yer, value: 100), reason: "Reason", sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.disqualifyLead(price: Price(currency: .yer, value: 100), reason: "Reason", sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.qualifyLead(price: Price(currency: .yer, value: 100), sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.workingLead(price: Price(currency: .yer, value: 100), leadStatus: "LeadStatus", sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.levelUp(level: 1, character: "Hero", sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.levelEnd(levelName: "LevelName", success: true, sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.postScore(score: 1, level: 1, character: "Hero", sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.earnVirtualCurrency(currencyName: "CurrencyName", value: 123, sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.spendVirtualCurrency(itemName: "ItemName", currencyName: "CurrencyName", value: 123, sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.viewPromotion(
        id: "PromotionId",
        name: "PromotionName",
        creativeName: "CreativeName",
        creativeSlot: "CreativeSlot",
        items: [.beer(
          quantiry: 10
        )],
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.generateLead(price: Price(currency: .jpy, value: 100), sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.addPaymentInfo(
        coupon: "Coupon",
        paymentType: "PaymentType",
        price: Price(currency: .jpy, value: 100),
        items: [.beer(quantiry: 10)],
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.addShippingInfo(
        coupon: "Coupon",
        shippingTier: "ShippingTier",
        price: Price(currency: .jpy, value: 100),
        items: [.beer(quantiry: 10)],
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.addToCart(
        items: [.beer(quantiry: 10)],
        price: Price(currency: .jpy, value: 100),
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.addToWithlist(
        items: [.beer(quantiry: 10)],
        price: Price(currency: .jpy, value: 100),
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.beginCheckout(
        items: [.beer(quantiry: 10)],
        coupon: "Coupon",
        price: Price(currency: .jpy, value: 100),
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.purchase(
        transactionId: "TransactionId",
        coupon: "Coupon",
        tax: 1000,
        price: Price(currency: .jpy, value: 100),
        shipping: 1000,
        items: [.beer(quantiry: 10)],
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.refund(
        transactionId: "TransactionId",
        coupon: "Coupon",
        tax: 1000,
        price: Price(currency: .jpy, value: 100),
        shipping: 1000,
        items: [.beer(quantiry: 10)],
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.removeFromCart(
        items: [.beer(quantiry: 10)],
        price: Price(currency: .jpy, value: 100),
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.viewCart(
        items: [.beer(quantiry: 10)],
        price: Price(currency: .jpy, value: 100),
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
    ]
  }

  @Test
  func validatePayload() async throws {
    let sessionId = UUID().uuidString

    let messages = try await client.validatePayload(
      for: allEvents(sessionId: sessionId)
    )
   
    #expect(messages.isEmpty)
    print(messages)
  }
  
  @Test
  func log() async throws {
    let sessionId = UUID().uuidString

    try await client.log(
      for: allEvents(sessionId: sessionId)
    )
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
