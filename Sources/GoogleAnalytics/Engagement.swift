import Foundation

extension Event {
  /// User Engagement event.
  public static func userEngagement(
    sessionId: String? = nil,
    engagementTime: TimeInterval? = nil,
    timestamp: Date? = nil
  ) -> Self {
    Event(
      name: "user_engagement",
      timestamp: timestamp,
      parameters: [
        "session_id": sessionId,
        "engagement_time_msec": engagementTime.map { $0 * 1_000_000 }?.description,
      ]
    )
  }
}
