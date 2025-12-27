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
    let sessionId = UUID().uuidString

    let messages1 = try await client.validatePayload(
      for: [
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
      ]
    )
    
    #expect(messages1.isEmpty)
    print(messages1)
    
    // TODO なぜかsession_id, engagementTimeがなくても良い
    let messages2 = try await client.validatePayload(
      for: [
        Event.selectItem(items: [.beer(quantiry: 10)]),
        Event.selectItem(items: [.beer(quantiry: 10)], listId: "ListId"),
        Event.selectItem(items: [.beer(quantiry: 10)], listName: "ListName"),
        Event.selectItem(items: [.beer(quantiry: 10)], sessionId: sessionId),
        Event.selectItem(items: [.beer(quantiry: 10)], engagementTime: 10000),
        Event.selectItem(items: [.beer(quantiry: 10)], listId: "ListId", listName: "ListName", sessionId: sessionId, engagementTime: 10000, timestamp: .now),
        
        Event.selectPromotion(items: [.beer(quantiry: 10)]),
        Event.selectPromotion(id: "PromotionId", items: [.beer(quantiry: 10)]),
        Event.selectPromotion(name: "PromotionName", items: [.beer(quantiry: 10)]),
        Event.selectPromotion(creativeName: "CreativeName", items: [.beer(quantiry: 10)]),
        Event.selectPromotion(creativeSlot: "CreativeSlot", items: [.beer(quantiry: 10)]),
        Event.selectPromotion(items: [.beer(quantiry: 10)], sessionId: sessionId),
        Event.selectPromotion(items: [.beer(quantiry: 10)], engagementTime: 100000),
        Event.selectPromotion(items: [.beer(quantiry: 10)], timestamp: .now),
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
        
        Event.viewItem(items: [.beer(quantiry: 10)]),
        Event.viewItem(items: [.beer(quantiry: 10)], price: .init(currency: .yer, value: 100)),
        Event.viewItem(items: [.beer(quantiry: 10)], sessionId: sessionId),
        Event.viewItem(items: [.beer(quantiry: 10)], engagementTime: 100),
        Event.viewItem(items: [.beer(quantiry: 10)], timestamp: .now),
        Event.viewItem(
          items: [.beer(quantiry: 10)],
          price: .init(currency: .yer, value: 100),
          sessionId: sessionId,
          engagementTime: 100,
          timestamp: .now
        ),
        
        Event.viewItemList(items: [.beer(quantiry: 10)]),
        Event.viewItemList(items: [.beer(quantiry: 10)], listId: "ListId"),
        Event.viewItemList(items: [.beer(quantiry: 10)], listName: "ListName"),
        Event.viewItemList(items: [.beer(quantiry: 10)], sessionId: sessionId),
        Event.viewItemList(items: [.beer(quantiry: 10)], engagementTime: 10),
        Event.viewItemList(items: [.beer(quantiry: 10)], timestamp: .now),
        Event.viewItemList(
          items: [.beer(quantiry: 10)],
          listId: "ListId",
          listName: "ListName",
          sessionId: sessionId,
          engagementTime: 10,
          timestamp: .now
        ),
        
        Event.closeConvertLead(price: Price(currency: .yer, value: 100)),
        Event.closeConvertLead(price: Price(currency: .yer, value: 100), sessionId: sessionId),
        Event.closeConvertLead(price: Price(currency: .yer, value: 100), engagementTime: 100),
        Event.closeConvertLead(price: Price(currency: .yer, value: 100), timestamp: .now),
        Event.closeConvertLead(price: Price(currency: .yer, value: 100), sessionId: sessionId, engagementTime: 100, timestamp: .now),
        
        Event.closeUnConvertLead(price: Price(currency: .yer, value: 100)),
        Event.closeUnConvertLead(price: Price(currency: .yer, value: 100), reason: "Reason"),
        Event.closeUnConvertLead(price: Price(currency: .yer, value: 100), sessionId: sessionId),
        Event.closeUnConvertLead(price: Price(currency: .yer, value: 100), engagementTime: 100),
        Event.closeUnConvertLead(price: Price(currency: .yer, value: 100), timestamp: .now),
        Event.closeUnConvertLead(price: Price(currency: .yer, value: 100), reason: "Reason", sessionId: sessionId, engagementTime: 100, timestamp: .now),
        
        Event.disqualifyLead(price: Price(currency: .yer, value: 100)),
        Event.disqualifyLead(price: Price(currency: .yer, value: 100), reason: "Reason"),
        Event.disqualifyLead(price: Price(currency: .yer, value: 100), sessionId: sessionId),
        Event.disqualifyLead(price: Price(currency: .yer, value: 100), engagementTime: 100),
        Event.disqualifyLead(price: Price(currency: .yer, value: 100), timestamp: .now),
        Event.disqualifyLead(price: Price(currency: .yer, value: 100), reason: "Reason", sessionId: sessionId, engagementTime: 100, timestamp: .now),
       
        Event.qualifyLead(price: Price(currency: .yer, value: 100)),
        Event.qualifyLead(price: Price(currency: .yer, value: 100), sessionId: sessionId),
        Event.qualifyLead(price: Price(currency: .yer, value: 100), engagementTime: 100),
        Event.qualifyLead(price: Price(currency: .yer, value: 100), timestamp: .now),
        Event.qualifyLead(price: Price(currency: .yer, value: 100), sessionId: sessionId, engagementTime: 100, timestamp: .now),
        
        Event.workingLead(price: Price(currency: .yer, value: 100)),
        Event.workingLead(price: Price(currency: .yer, value: 100), leadStatus: "LeadStatus"),
        Event.workingLead(price: Price(currency: .yer, value: 100), sessionId: sessionId),
        Event.workingLead(price: Price(currency: .yer, value: 100), engagementTime: 100),
        Event.workingLead(price: Price(currency: .yer, value: 100), timestamp: .now),
        Event.workingLead(price: Price(currency: .yer, value: 100), leadStatus: "LeadStatus", sessionId: sessionId, engagementTime: 100, timestamp: .now),

        Event.levelUp(level: 1),
        Event.levelUp(level: 1, character: "Hero"),
        Event.levelUp(level: 1, sessionId: sessionId),
        Event.levelUp(level: 1, engagementTime: 100),
        Event.levelUp(level: 1, character: "Hero", sessionId: sessionId, engagementTime: 100, timestamp: .now),
        
        Event.levelEnd(levelName: "LevelName", success: true),
        Event.levelEnd(levelName: "LevelName", success: true, sessionId: sessionId),
        Event.levelEnd(levelName: "LevelName", success: true, engagementTime: 100),
        Event.levelEnd(levelName: "LevelName", success: true, sessionId: sessionId, engagementTime: 100, timestamp: .now),

        Event.postScore(score: 1),
        Event.postScore(score: 1, level: 1),
        Event.postScore(score: 1, character: "Hero"),
        Event.postScore(score: 1, sessionId: sessionId),
        Event.postScore(score: 1, engagementTime: 100),
        Event.postScore(score: 1, timestamp: .now),
        Event.postScore(score: 1, level: 1, character: "Hero", sessionId: sessionId, engagementTime: 100, timestamp: .now),

        Event.earnVirtualCurrency(currencyName: "CurrencyName", value: 123),
        Event.earnVirtualCurrency(currencyName: "CurrencyName", value: 123, sessionId: sessionId),
        Event.earnVirtualCurrency(currencyName: "CurrencyName", value: 123, engagementTime: 100),
        Event.earnVirtualCurrency(currencyName: "CurrencyName", value: 123, sessionId: sessionId, engagementTime: 100, timestamp: .now),
        
        Event.spendVirtualCurrency(itemName: "ItemName", currencyName: "CurrencyName", value: 123),
        Event.spendVirtualCurrency(itemName: "ItemName", currencyName: "CurrencyName", value: 123, sessionId: sessionId),
        Event.spendVirtualCurrency(itemName: "ItemName", currencyName: "CurrencyName", value: 123, engagementTime: 100),
        Event.spendVirtualCurrency(itemName: "ItemName", currencyName: "CurrencyName", value: 123, sessionId: sessionId, engagementTime: 100, timestamp: .now),
        
        Event.viewPromotion(items: [.beer(quantiry: 10)]),
        Event.viewPromotion(id: "PromotionId", items: [.beer(quantiry: 10)]),
        Event.viewPromotion(name: "PromotionName", items: [.beer(quantiry: 10)]),
        Event.viewPromotion(creativeName: "CreativeName", items: [.beer(quantiry: 10)]),
        Event.viewPromotion(creativeSlot: "CreativeSlot", items: [.beer(quantiry: 10)]),
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
        
        Event.generateLead(),
        Event.generateLead(price: Price(currency: .jpy, value: 100)),
        Event.generateLead(sessionId: sessionId),
        Event.generateLead(engagementTime: 100),
        Event.generateLead(price: Price(currency: .jpy, value: 100), sessionId: sessionId, engagementTime: 100, timestamp: .now),
        
        Event.addPaymentInfo(coupon: "Coupon"),
        Event.addPaymentInfo(paymentType: "PaymentType"),
        Event.addPaymentInfo(price: Price(currency: .jpy, value: 100)),
        Event.addPaymentInfo(items: [.beer(quantiry: 10)]),
        Event.addPaymentInfo(sessionId: sessionId),
        Event.addPaymentInfo(engagementTime: 100),
        Event.addPaymentInfo(
          coupon: "Coupon",
          paymentType: "PaymentType",
          price: Price(currency: .jpy, value: 100),
          items: [.beer(quantiry: 10)],
          sessionId: sessionId,
          engagementTime: 100,
          timestamp: .now
        ),
        
        Event.addShippingInfo(),
        Event.addShippingInfo(coupon: "Coupon"),
        Event.addShippingInfo(shippingTier: "ShippingTier"),
        Event.addShippingInfo(price: Price(currency: .jpy, value: 100)),
        Event.addShippingInfo(items: [.beer(quantiry: 10)]),
        Event.addShippingInfo(sessionId: sessionId),
        Event.addShippingInfo(engagementTime: 100),
        Event.addShippingInfo(
          coupon: "Coupon",
          shippingTier: "ShippingTier",
          price: Price(currency: .jpy, value: 100),
          items: [.beer(quantiry: 10)],
          sessionId: sessionId,
          engagementTime: 100,
          timestamp: .now
        ),
        
        Event.addToCart(items: [.beer(quantiry: 10)]),
        Event.addToCart(items: [.beer(quantiry: 10)], price: Price(currency: .jpy, value: 100)),
        Event.addToCart(
          items: [.beer(quantiry: 10)],
          price: Price(currency: .jpy, value: 100),
          sessionId: sessionId,
          engagementTime: 100,
          timestamp: .now
        ),
        
        Event.addToWithlist(items: [.beer(quantiry: 10)]),
        Event.addToWithlist(items: [.beer(quantiry: 10)], price: Price(currency: .jpy, value: 100)),
        Event.addToWithlist(
          items: [.beer(quantiry: 10)],
          price: Price(currency: .jpy, value: 100),
          sessionId: sessionId,
          engagementTime: 100,
          timestamp: .now
        ),
        
        Event.beginCheckout(items: [.beer(quantiry: 10)]),
        Event.beginCheckout(items: [.beer(quantiry: 10)], coupon: "Coupon"),
        Event.beginCheckout(items: [.beer(quantiry: 10)], price: Price(currency: .jpy, value: 100)),
        Event.beginCheckout(
          items: [.beer(quantiry: 10)],
          coupon: "Coupon",
          price: Price(currency: .jpy, value: 100),
          sessionId: sessionId,
          engagementTime: 100,
          timestamp: .now
        ),
        
        Event.purchase(items: [.beer(quantiry: 10)]),
        Event.purchase(transactionId: "TransactionId", items: [.beer(quantiry: 10)]),
        Event.purchase(coupon: "Coupon", items: [.beer(quantiry: 10)]),
        Event.purchase(tax: 1000, items: [.beer(quantiry: 10)]),
        Event.purchase(price: Price(currency: .jpy, value: 100), items: [.beer(quantiry: 10)]),
        Event.purchase(shipping: 1000, items: [.beer(quantiry: 10)]),
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
        
        Event.refund(items: [.beer(quantiry: 10)]),
        Event.refund(transactionId: "TransactionId", items: [.beer(quantiry: 10)]),
        Event.refund(coupon: "Coupon", items: [.beer(quantiry: 10)]),
        Event.refund(tax: 1000, items: [.beer(quantiry: 10)]),
        Event.refund(price: Price(currency: .jpy, value: 100), items: [.beer(quantiry: 10)]),
        Event.refund(shipping: 1000, items: [.beer(quantiry: 10)]),
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
        
        Event.removeFromCart(items: [.beer(quantiry: 10)]),
        Event.removeFromCart(items: [.beer(quantiry: 10)], price: Price(currency: .jpy, value: 100)),
        Event.removeFromCart(
          items: [.beer(quantiry: 10)],
          price: Price(currency: .jpy, value: 100),
          sessionId: sessionId,
          engagementTime: 100,
          timestamp: .now
        ),
  
        Event.viewCart(items: [.beer(quantiry: 10)]),
        Event.viewCart(items: [.beer(quantiry: 10)], price: Price(currency: .jpy, value: 100)),
        Event.viewCart(
          items: [.beer(quantiry: 10)],
          price: Price(currency: .jpy, value: 100),
          sessionId: sessionId,
          engagementTime: 100,
          timestamp: .now
        ),
      ]
    )
   
    #expect(messages2.isEmpty)
    print(messages2)
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
  func sampleEvents() async throws {
    let sessionId = UUID().uuidString
    try await client.log(for: [
      Event.sessionStart(sessionId: sessionId, engagementTime: 100000),
      Event.screenView(name: "SampleView1", className: "SampleView1Class", sessionId: sessionId, engagementTime: 8781),
      Event.screenView(name: "SampleView2", className: "SampleView2Class", sessionId: sessionId, engagementTime: 100000),
      Event.addToWithlist(items: [.beer(quantiry: 1)], sessionId: sessionId, engagementTime: 6677),
    ])
  }

  @Test
  func appOpenToPurchaseItem() async throws {
    let sessionId = UUID().uuidString
    let transactionId = UUID().uuidString

    try await client.log(for: [
      Event.sessionStart(sessionId: sessionId, engagementTime: 0),
      Event.appOpen(sessionId: sessionId, engagementTime: 1),
      Event.screenView(name: "TutorialView", className: "TutorialViewClass", sessionId: sessionId, engagementTime: 1),
      Event.tutorialBegin(sessionId: sessionId, engagementTime: 3),
      Event.tutorialComplete(sessionId: sessionId, engagementTime: 6),
      Event.screenView(name: "TopView", className: "TopViewClass", sessionId: sessionId, engagementTime: 100000),
      Event.screenView(name: "SearchView", className: "SearchVieClass", sessionId: sessionId, engagementTime: 100000),
      Event.search(term: "Beer", sessionId: sessionId, engagementTime: 10000),
      Event.viewSearchResults(term: "Beer", sessionId: sessionId, engagementTime: 100),
      Event.selectItem(items: [.beer(quantiry: 2)], sessionId: sessionId),
      Event.addToWithlist(items: [.beer(quantiry: 2)], sessionId: sessionId),
      Event.screenView(name: "WithlistView", className: "WithlistViewClass", sessionId: sessionId, engagementTime: 100000),
      Event.addToCart(items: [.beer(quantiry: 2)], sessionId: sessionId),
      Event.screenView(name: "CartView", className: "CartViewClass", sessionId: sessionId, engagementTime: 100000),
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
      Event.levelStart(levelName: "Level 1", sessionId: sessionId, engagementTime: 100),
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
