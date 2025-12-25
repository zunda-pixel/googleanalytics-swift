import Foundation
import ISO_639
import MemberwiseInit

@MemberwiseInit(.public)
public struct Device: Encodable, Sendable {
  public var category: Category?
  public var language: ISO_639.LanguageCode?
  public var screenResolution: CGSize?
  public var os: OS?
  public var model: String?
  public var brand: String?
  public var browser: Browswer?

  private enum CodingKeys: String, CodingKey {
    case category
    case language
    case screenResolution = "screen_resolution"
    case operatingSystem = "operating_system"
    case operatingSystemVersion = "operating_system_version"
    case model
    case brand
    case browser
    case browserVersion = "browser_version"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.category, forKey: .category)
    try container.encodeIfPresent(self.language, forKey: .language)
    if let screenResolution {
      try container.encodeIfPresent(
        "\(screenResolution.width)x\(screenResolution.height)", forKey: .screenResolution)
    }
    try container.encodeIfPresent(self.os?.name, forKey: .operatingSystem)
    try container.encodeIfPresent(self.os?.verison, forKey: .operatingSystemVersion)
    try container.encodeIfPresent(self.model, forKey: .model)
    try container.encodeIfPresent(self.brand, forKey: .brand)
    try container.encodeIfPresent(self.browser?.name, forKey: .browser)
    try container.encodeIfPresent(self.browser?.verison, forKey: .browserVersion)
  }
}

extension Device {
  public enum Category: String, Hashable, Sendable, Codable {
    case deskop
    case tablet
    case mobile
    case smartTV = "smart TV"
  }
}

@MemberwiseInit(.public)
public struct OS: Codable, Hashable, Sendable {
  public var name: String?
  public var verison: String?
}

@MemberwiseInit(.public)
public struct Browswer: Codable, Hashable, Sendable {
  public var name: String?
  public var verison: String?
}
