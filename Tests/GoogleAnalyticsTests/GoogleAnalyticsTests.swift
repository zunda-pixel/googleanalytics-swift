import Foundation
import Testing

@testable import GoogleAnalytics

@Suite
struct GoogleAnalyticsTests {
  let client = GoogleAnalytics(
    httpClient: .urlSession(.shared),
    apiSecret: ProcessInfo.processInfo.environment["API_SECRET"]!,
    id: .firebase(
      firebaseAppId: ProcessInfo.processInfo.environment["APP_ID"]!,
      appInstanceId: UUID().uuidString.replacingOccurrences(of: "-", with: "")
    ),
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
    let sessionId = UUID().uuidString.replacingOccurrences(of: "-", with: "")

    let messages = try await client.validatePayload(
      for: allEvents(sessionId: sessionId)
    )

    #expect(messages.isEmpty)
    print(messages)
  }

  @Test
  func log() async throws {
    let sessionId = UUID().uuidString.replacingOccurrences(of: "-", with: "")

    try await client.send(
      for: allEvents(sessionId: sessionId)
    )
  }

  /// https://developers.google.com/analytics/devguides/collection/protocol/ga4/reference?client_type=firebase#reserved_names
  @Test
  func reservedEventNamesButNoError() async throws {
    let eventNames = [
      "ad_reward",
      "app_exception",
      "notification_send",
      "app_store_refund",
      "app_store_subscription_cancel",
      "app_store_subscription_convert",
      "app_store_subscription_renew",
      "dynamic_link_app_open",
      "dynamic_link_first_open",
      "dynamic_link_app_update",
      "firebase_campaign",
      "firebase_in_app_message_dismiss",
      "firebase_in_app_message_action",
      "firebase_in_app_message_impression",
      "app_upgrade",
      "page_view",
      "scroll",
      "video_complete",
      "video_progress",
      "video_start",
      "form_submit",
      "form_start",
      "file_download",
      "click",
      "fiam_action",
      "fiam_dismiss",
      "fiam_impression",
    ]
    let errors = try await client.validatePayload(
      for: eventNames.map { Event(name: $0, timestamp: nil, parameters: [String: String]()) }
    )
    #expect(errors.isEmpty)
  }

  /// https://developers.google.com/analytics/devguides/collection/protocol/ga4/reference?client_type=firebase#reserved_names
  @Test
  func reservedEventNames() async throws {
    let eventNames = [
      "app_install",
      "user_engagement",
      "ad_query",
      "adunit_exposure",
      "app_clear_data",
      "app_update",
      "session_start",
      "ad_exposure",
      "os_update",
      "notification_receive",
      "ad_click",
      "notification_foreground",
      "notification_dismiss",
      "first_open",
      "app_remove",
      "first_visit",
      "ad_activeview",
      "error",
      "notification_open",
      "in_app_purchase",
    ]

    try await withThrowingTaskGroup { group in
      for eventName in eventNames {
        group.addTask {
          let errors = try await client.validatePayload(
            for: [Event(name: eventName, timestamp: nil, parameters: [String: String]())]
          )
          return (eventName, errors)
        }
      }

      for try await event in group {
        let errorMessage = ValidationResponse.Message(
          fieldPath: "events",
          description: "Event at index: [0] has name [\(event.0)] which is reserved.",
          validationCode: "NAME_RESERVED"
        )

        #expect(event.1 == [errorMessage])
      }
    }
  }

  func allEvents(sessionId: String) -> [Event] {
    [
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
      Event.login(method: "Email", sessionId: sessionId, engagementTime: 10000, timestamp: .now),
      Event.signUp(method: "Email", sessionId: sessionId, engagementTime: 10000),
      Event.appOpen(sessionId: sessionId, engagementTime: 10000, timestamp: .now),
      Event.screenView(
        name: "ScreenName",
        className: "ClassName",
        sessionId: sessionId,
        engagementTime: 10000,
        timestamp: .now
      ),
      Event.search(term: "Term", sessionId: sessionId, engagementTime: 10000, timestamp: .now),
      Event.selectContent(
        itemId: "ItemId",
        contentType: "Book",
        sessionId: sessionId,
        engagementTime: 10000,
        timestamp: .now
      ),
      Event.share(
        method: "Native",
        itemId: "ItemId",
        contentType: "ContentType",
        sessionId: sessionId,
        engagementTime: 1,
        timestamp: .now
      ),
      Event.tutorialBegin(sessionId: sessionId, engagementTime: 10, timestamp: .now),
      Event.tutorialComplete(sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.viewSearchResults(
        term: "Term",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.joinGroup(id: "GroupID", sessionId: sessionId, engagementTime: 100, timestamp: .now),
      Event.levelStart(
        levelName: "LevelName",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.unlockAchievement(
        achievementId: "AchivementId",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
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
      Event.selectItem(
        items: [.beer(quantiry: 10)],
        listId: "ListId",
        listName: "ListName",
        sessionId: sessionId,
        engagementTime: 10000,
        timestamp: .now
      ),
      Event.selectPromotion(
        id: "PromotionId",
        name: "PromotionName",
        creativeName: "CreativeName",
        creativeSlot: "CreativeSlot",
        items: [.beer(quantiry: 10)],
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
      Event.closeConvertLead(
        price: Price(currency: .yer, value: 100),
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.closeUnConvertLead(
        price: Price(currency: .yer, value: 100),
        reason: "Reason",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.disqualifyLead(
        price: Price(currency: .yer, value: 100),
        reason: "Reason",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.qualifyLead(
        price: Price(currency: .yer, value: 100),
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.workingLead(
        price: Price(currency: .yer, value: 100),
        leadStatus: "LeadStatus",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.levelUp(
        level: 1,
        character: "Hero",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.levelEnd(
        levelName: "LevelName",
        success: true,
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.postScore(
        score: 1,
        level: 1,
        character: "Hero",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.earnVirtualCurrency(
        currencyName: "CurrencyName",
        value: 123,
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.spendVirtualCurrency(
        itemName: "ItemName",
        currencyName: "CurrencyName",
        value: 123,
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.viewPromotion(
        id: "PromotionId",
        name: "PromotionName",
        creativeName: "CreativeName",
        creativeSlot: "CreativeSlot",
        items: [.beer(quantiry: 10)],
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.generateLead(
        price: Price(currency: .jpy, value: 100),
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
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
      Event.addToWishlist(
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
      // Automatically collected events
      Event.adReward(
        adUnitId: "AdUnitId",
        rewardType: "Coins",
        rewardValue: 100,
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.appException(
        fatal: false,
        timestamp: .now
      ),
      Event.notificationSend(
        messageId: "MessageId",
        messageName: "MessageName",
        messageTime: .now,
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.appStoreRefund(
        productId: "ProductId",
        quantity: 1,
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.appStoreSubscriptionCancel(
        productId: "ProductId",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.appStoreSubscriptionConvert(
        productId: "ProductId",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.appStoreSubscriptionRenew(
        productId: "ProductId",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.dynamicLinkAppOpen(
        linkUrl: "https://example.com",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.dynamicLinkFirstOpen(
        linkUrl: "https://example.com",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.dynamicLinkAppUpdate(
        linkUrl: "https://example.com",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.firebaseCampaign(
        source: "Source",
        medium: "Medium",
        campaign: "Campaign",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.firebaseInAppMessageDismiss(
        messageId: "MessageId",
        messageName: "MessageName",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.firebaseInAppMessageAction(
        messageId: "MessageId",
        messageName: "MessageName",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.firebaseInAppMessageImpression(
        messageId: "MessageId",
        messageName: "MessageName",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.appUpgrade(
        previousAppVersion: "1.0.0",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.pageView(
        pageLocation: "https://example.com",
        pageTitle: "Example Page",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.scroll(
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.videoComplete(
        videoTitle: "Video Title",
        videoUrl: "https://example.com/video",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.videoProgress(
        videoTitle: "Video Title",
        videoUrl: "https://example.com/video",
        videoPercent: 50,
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.videoStart(
        videoTitle: "Video Title",
        videoUrl: "https://example.com/video",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.formSubmit(
        formId: "FormId",
        formName: "FormName",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.formStart(
        formId: "FormId",
        formName: "FormName",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.fileDownload(
        fileName: "file.pdf",
        linkUrl: "https://example.com/file.pdf",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.click(
        linkUrl: "https://example.com",
        linkText: "Click here",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.fiamAction(
        messageId: "MessageId",
        messageName: "MessageName",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.fiamDismiss(
        messageId: "MessageId",
        messageName: "MessageName",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
      Event.fiamImpression(
        messageId: "MessageId",
        messageName: "MessageName",
        sessionId: sessionId,
        engagementTime: 100,
        timestamp: .now
      ),
    ]
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
