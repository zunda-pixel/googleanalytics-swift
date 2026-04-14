import Foundation
import MemberwiseInit

// MARK: - Ad Events

extension Event {
  /// Ad Reward event.
  ///
  /// This event is automatically collected when the user earns a reward for watching a rewarded video ad.
  public static func adReward(
    adUnitId: String? = nil,
    rewardType: String? = nil,
    rewardValue: Double? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "ad_reward",
      timestamp: timestamp,
      parameters: AdRewardParameters(
        adUnitId: adUnitId,
        rewardType: rewardType,
        rewardValue: rewardValue,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit(.public)
public struct AdRewardParameters: Encodable {
  public var adUnitId: String?
  public var rewardType: String?
  public var rewardValue: Double?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case adUnitId = "ad_unit_id"
    case rewardType = "reward_type"
    case rewardValue = "reward_value"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.adUnitId, forKey: .adUnitId)
    try container.encodeIfPresent(self.rewardType, forKey: .rewardType)
    try container.encodeIfPresent(self.rewardValue, forKey: .rewardValue)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

// MARK: - App Exception

extension Event {
  /// App Exception event.
  ///
  /// This event is automatically collected when the app crashes or throws an exception.
  public static func appException(
    fatal: Bool? = nil,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "app_exception",
      timestamp: timestamp,
      parameters: AppExceptionParameters(
        fatal: fatal
      )
    )
  }
}

@MemberwiseInit(.public)
public struct AppExceptionParameters: Encodable {
  public var fatal: Bool?

  private enum CodingKeys: String, CodingKey {
    case fatal
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.fatal, forKey: .fatal)
  }
}

// MARK: - Notification Events

extension Event {
  /// Notification Send event.
  ///
  /// This event is automatically collected when a notification is sent to the user.
  public static func notificationSend(
    messageId: String? = nil,
    messageName: String? = nil,
    messageTime: Date? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "notification_send",
      timestamp: timestamp,
      parameters: NotificationSendParameters(
        messageId: messageId,
        messageName: messageName,
        messageTime: messageTime,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit(.public)
public struct NotificationSendParameters: Encodable {
  public var messageId: String?
  public var messageName: String?
  public var messageTime: Date?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case messageId = "message_id"
    case messageName = "message_name"
    case messageTime = "message_time"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.messageId, forKey: .messageId)
    try container.encodeIfPresent(self.messageName, forKey: .messageName)
    try container.encodeIfPresent(
      messageTime.map { UInt($0.timeIntervalSince1970 * 1_000_000) },
      forKey: .messageTime
    )
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

// MARK: - App Store Events

extension Event {
  /// App Store Refund event.
  ///
  /// This event is automatically collected when a user receives a refund for an in-app purchase.
  public static func appStoreRefund(
    productId: String? = nil,
    quantity: Int? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "app_store_refund",
      timestamp: timestamp,
      parameters: AppStoreRefundParameters(
        productId: productId,
        quantity: quantity,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit(.public)
public struct AppStoreRefundParameters: Encodable {
  public var productId: String?
  public var quantity: Int?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case productId = "product_id"
    case quantity
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.productId, forKey: .productId)
    try container.encodeIfPresent(self.quantity, forKey: .quantity)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

extension Event {
  /// App Store Subscription Cancel event.
  ///
  /// This event is automatically collected when a user cancels a subscription.
  public static func appStoreSubscriptionCancel(
    productId: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "app_store_subscription_cancel",
      timestamp: timestamp,
      parameters: AppStoreSubscriptionParameters(
        productId: productId,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// App Store Subscription Convert event.
  ///
  /// This event is automatically collected when a user converts from a free trial to a paid subscription.
  public static func appStoreSubscriptionConvert(
    productId: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "app_store_subscription_convert",
      timestamp: timestamp,
      parameters: AppStoreSubscriptionParameters(
        productId: productId,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// App Store Subscription Renew event.
  ///
  /// This event is automatically collected when a subscription is renewed.
  public static func appStoreSubscriptionRenew(
    productId: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "app_store_subscription_renew",
      timestamp: timestamp,
      parameters: AppStoreSubscriptionParameters(
        productId: productId,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit(.public)
public struct AppStoreSubscriptionParameters: Encodable {
  public var productId: String?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case productId = "product_id"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.productId, forKey: .productId)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

// MARK: - Dynamic Link Events

extension Event {
  /// Dynamic Link App Open event.
  ///
  /// This event is automatically collected when the app is opened via a dynamic link.
  public static func dynamicLinkAppOpen(
    linkUrl: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "dynamic_link_app_open",
      timestamp: timestamp,
      parameters: DynamicLinkParameters(
        linkUrl: linkUrl,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// Dynamic Link First Open event.
  ///
  /// This event is automatically collected when the app is opened for the first time via a dynamic link.
  public static func dynamicLinkFirstOpen(
    linkUrl: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "dynamic_link_first_open",
      timestamp: timestamp,
      parameters: DynamicLinkParameters(
        linkUrl: linkUrl,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// Dynamic Link App Update event.
  ///
  /// This event is automatically collected when the app is updated via a dynamic link.
  public static func dynamicLinkAppUpdate(
    linkUrl: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "dynamic_link_app_update",
      timestamp: timestamp,
      parameters: DynamicLinkParameters(
        linkUrl: linkUrl,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit(.public)
public struct DynamicLinkParameters: Encodable {
  public var linkUrl: String?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case linkUrl = "link_url"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.linkUrl, forKey: .linkUrl)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

// MARK: - Firebase Events

extension Event {
  /// Firebase Campaign event.
  ///
  /// This event is automatically collected for Firebase campaigns.
  public static func firebaseCampaign(
    source: String? = nil,
    medium: String? = nil,
    campaign: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "firebase_campaign",
      timestamp: timestamp,
      parameters: FirebaseCampaignParameters(
        source: source,
        medium: medium,
        campaign: campaign,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit(.public)
public struct FirebaseCampaignParameters: Encodable {
  public var source: String?
  public var medium: String?
  public var campaign: String?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case source
    case medium
    case campaign
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.source, forKey: .source)
    try container.encodeIfPresent(self.medium, forKey: .medium)
    try container.encodeIfPresent(self.campaign, forKey: .campaign)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

// MARK: - Firebase In-App Message Events

extension Event {
  /// Firebase In-App Message Dismiss event.
  ///
  /// This event is automatically collected when an in-app message is dismissed.
  public static func firebaseInAppMessageDismiss(
    messageId: String? = nil,
    messageName: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "firebase_in_app_message_dismiss",
      timestamp: timestamp,
      parameters: FirebaseInAppMessageParameters(
        messageId: messageId,
        messageName: messageName,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// Firebase In-App Message Action event.
  ///
  /// This event is automatically collected when a user interacts with an in-app message.
  public static func firebaseInAppMessageAction(
    messageId: String? = nil,
    messageName: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "firebase_in_app_message_action",
      timestamp: timestamp,
      parameters: FirebaseInAppMessageParameters(
        messageId: messageId,
        messageName: messageName,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// Firebase In-App Message Impression event.
  ///
  /// This event is automatically collected when an in-app message is displayed.
  public static func firebaseInAppMessageImpression(
    messageId: String? = nil,
    messageName: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "firebase_in_app_message_impression",
      timestamp: timestamp,
      parameters: FirebaseInAppMessageParameters(
        messageId: messageId,
        messageName: messageName,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit(.public)
public struct FirebaseInAppMessageParameters: Encodable {
  public var messageId: String?
  public var messageName: String?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case messageId = "message_id"
    case messageName = "message_name"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.messageId, forKey: .messageId)
    try container.encodeIfPresent(self.messageName, forKey: .messageName)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

// MARK: - App Upgrade

extension Event {
  /// App Upgrade event.
  ///
  /// This event is automatically collected when the app is upgraded to a new version.
  public static func appUpgrade(
    previousAppVersion: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "app_upgrade",
      timestamp: timestamp,
      parameters: AppUpgradeParameters(
        previousAppVersion: previousAppVersion,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit(.public)
public struct AppUpgradeParameters: Encodable {
  public var previousAppVersion: String?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case previousAppVersion = "previous_app_version"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.previousAppVersion, forKey: .previousAppVersion)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

// MARK: - Web Events

extension Event {
  /// Page View event.
  ///
  /// This event is automatically collected when a page is viewed.
  public static func pageView(
    pageLocation: String? = nil,
    pageTitle: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "page_view",
      timestamp: timestamp,
      parameters: PageViewParameters(
        pageLocation: pageLocation,
        pageTitle: pageTitle,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit(.public)
public struct PageViewParameters: Encodable {
  public var pageLocation: String?
  public var pageTitle: String?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case pageLocation = "page_location"
    case pageTitle = "page_title"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.pageLocation, forKey: .pageLocation)
    try container.encodeIfPresent(self.pageTitle, forKey: .pageTitle)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

extension Event {
  /// Scroll event.
  ///
  /// This event is automatically collected when a user scrolls to the bottom of a page.
  public static func scroll(
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "scroll",
      timestamp: timestamp,
      parameters: ScrollParameters(
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit(.public)
public struct ScrollParameters: Encodable {
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

// MARK: - Video Events

extension Event {
  /// Video Complete event.
  ///
  /// This event is automatically collected when a video completes playing.
  public static func videoComplete(
    videoTitle: String? = nil,
    videoUrl: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "video_complete",
      timestamp: timestamp,
      parameters: VideoParameters(
        videoTitle: videoTitle,
        videoUrl: videoUrl,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// Video Progress event.
  ///
  /// This event is automatically collected when a video reaches a progress milestone.
  public static func videoProgress(
    videoTitle: String? = nil,
    videoUrl: String? = nil,
    videoPercent: Int? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "video_progress",
      timestamp: timestamp,
      parameters: VideoProgressParameters(
        videoTitle: videoTitle,
        videoUrl: videoUrl,
        videoPercent: videoPercent,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// Video Start event.
  ///
  /// This event is automatically collected when a video starts playing.
  public static func videoStart(
    videoTitle: String? = nil,
    videoUrl: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "video_start",
      timestamp: timestamp,
      parameters: VideoParameters(
        videoTitle: videoTitle,
        videoUrl: videoUrl,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit(.public)
public struct VideoParameters: Encodable {
  public var videoTitle: String?
  public var videoUrl: String?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case videoTitle = "video_title"
    case videoUrl = "video_url"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.videoTitle, forKey: .videoTitle)
    try container.encodeIfPresent(self.videoUrl, forKey: .videoUrl)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

@MemberwiseInit(.public)
public struct VideoProgressParameters: Encodable {
  public var videoTitle: String?
  public var videoUrl: String?
  public var videoPercent: Int?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case videoTitle = "video_title"
    case videoUrl = "video_url"
    case videoPercent = "video_percent"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.videoTitle, forKey: .videoTitle)
    try container.encodeIfPresent(self.videoUrl, forKey: .videoUrl)
    try container.encodeIfPresent(self.videoPercent, forKey: .videoPercent)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

// MARK: - Form Events

extension Event {
  /// Form Submit event.
  ///
  /// This event is automatically collected when a form is submitted.
  public static func formSubmit(
    formId: String? = nil,
    formName: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "form_submit",
      timestamp: timestamp,
      parameters: FormParameters(
        formId: formId,
        formName: formName,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// Form Start event.
  ///
  /// This event is automatically collected when a user starts filling out a form.
  public static func formStart(
    formId: String? = nil,
    formName: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "form_start",
      timestamp: timestamp,
      parameters: FormParameters(
        formId: formId,
        formName: formName,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit(.public)
public struct FormParameters: Encodable {
  public var formId: String?
  public var formName: String?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case formId = "form_id"
    case formName = "form_name"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.formId, forKey: .formId)
    try container.encodeIfPresent(self.formName, forKey: .formName)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

// MARK: - File Download

extension Event {
  /// File Download event.
  ///
  /// This event is automatically collected when a file is downloaded.
  public static func fileDownload(
    fileName: String? = nil,
    linkUrl: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "file_download",
      timestamp: timestamp,
      parameters: FileDownloadParameters(
        fileName: fileName,
        linkUrl: linkUrl,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit(.public)
public struct FileDownloadParameters: Encodable {
  public var fileName: String?
  public var linkUrl: String?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case fileName = "file_name"
    case linkUrl = "link_url"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.fileName, forKey: .fileName)
    try container.encodeIfPresent(self.linkUrl, forKey: .linkUrl)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

// MARK: - Click

extension Event {
  /// Click event.
  ///
  /// This event is automatically collected when a user clicks an outbound link.
  public static func click(
    linkUrl: String? = nil,
    linkText: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "click",
      timestamp: timestamp,
      parameters: ClickParameters(
        linkUrl: linkUrl,
        linkText: linkText,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

@MemberwiseInit(.public)
public struct ClickParameters: Encodable {
  public var linkUrl: String?
  public var linkText: String?
  public var sessionId: String
  public var engagementTime: TimeInterval

  private enum CodingKeys: String, CodingKey {
    case linkUrl = "link_url"
    case linkText = "link_text"
    case sessionId = "session_id"
    case engagementTime = "engagement_time_msec"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.linkUrl, forKey: .linkUrl)
    try container.encodeIfPresent(self.linkText, forKey: .linkText)
    try container.encode(self.sessionId, forKey: .sessionId)
    try container.encode(self.engagementTime * 1_000_000, forKey: .engagementTime)
  }
}

// MARK: - FIAM Aliases (Firebase In-App Messaging)

extension Event {
  /// FIAM Action event (alias for firebase_in_app_message_action).
  ///
  /// This event is automatically collected when a user interacts with a Firebase in-app message.
  public static func fiamAction(
    messageId: String? = nil,
    messageName: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "fiam_action",
      timestamp: timestamp,
      parameters: FirebaseInAppMessageParameters(
        messageId: messageId,
        messageName: messageName,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// FIAM Dismiss event (alias for firebase_in_app_message_dismiss).
  ///
  /// This event is automatically collected when a Firebase in-app message is dismissed.
  public static func fiamDismiss(
    messageId: String? = nil,
    messageName: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "fiam_dismiss",
      timestamp: timestamp,
      parameters: FirebaseInAppMessageParameters(
        messageId: messageId,
        messageName: messageName,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}

extension Event {
  /// FIAM Impression event (alias for firebase_in_app_message_impression).
  ///
  /// This event is automatically collected when a Firebase in-app message is displayed.
  public static func fiamImpression(
    messageId: String? = nil,
    messageName: String? = nil,
    sessionId: String,
    engagementTime: TimeInterval,
    timestamp: Date? = nil
  ) -> Event {
    Event(
      name: "fiam_impression",
      timestamp: timestamp,
      parameters: FirebaseInAppMessageParameters(
        messageId: messageId,
        messageName: messageName,
        sessionId: sessionId,
        engagementTime: engagementTime
      )
    )
  }
}
