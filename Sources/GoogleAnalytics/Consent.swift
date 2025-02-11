public struct Consent: Encodable, Sendable {
  public var adUserData: Mode?
  public var adPersonalization: Mode?

  public init(adUserData: Mode? = nil, adPersonalization: Mode? = nil) {
    self.adUserData = adUserData
    self.adPersonalization = adPersonalization
  }

  private enum CodingKeys: String, CodingKey {
    case adUserData = "ad_user_data"
    case adPersonalization = "ad_personalization"
  }

  public enum Mode: String, Encodable, Sendable {
    case granted = "GRANTED"
    case denied = "DENIED"

    public func encode(to encoder: any Encoder) throws {
      var container = encoder.singleValueContainer()
      try container.encode(rawValue)
    }
  }
}
