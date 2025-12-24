import MemberwiseInit

@MemberwiseInit(.public)
public struct Consent: Encodable, Sendable {
  public var adUserData: Mode?
  public var adPersonalization: Mode?

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
