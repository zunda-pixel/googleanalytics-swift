import Algorithms
import Crypto
import Foundation
import MemberwiseInit
import RegexBuilder

@MemberwiseInit(.public)
public struct Address: Encodable, Sendable {
  public var firstName: String?
  public var lastName: String?
  public var street: String?
  public var city: String?
  public var region: String?
  public var postalCode: String?
  public var country: String?

  private enum CodingKeys: String, CodingKey {
    case firstName = "sha256_first_name"
    case lastName = "sha256_last_name"
    case street = "sha256_street"
    case city
    case region
    case postalCode = "postal_code"
    case country
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    let firstNameSha256 = firstName.map { hashEncode($0) }
    try container.encodeIfPresent(firstNameSha256, forKey: .firstName)
    let lastNameSha256 = lastName.map { hashEncode($0) }
    try container.encodeIfPresent(lastNameSha256, forKey: .lastName)
    let streetSha256 = street.map { hashEncode($0) }
    try container.encodeIfPresent(streetSha256, forKey: .street)
    try container.encodeIfPresent(self.city, forKey: .city)
    try container.encodeIfPresent(self.region, forKey: .region)
    try container.encodeIfPresent(self.postalCode, forKey: .postalCode)
    try container.encodeIfPresent(self.country, forKey: .country)
  }

  func hashEncode(_ value: String) -> String {
    var value = value.trimming(while: \.isWhitespace).lowercased()
    let regex = Regex {
      OneOrMore("0"..."9")
    }
    value.replace(regex, with: "")

    let sha256 = Data(SHA256.hash(data: Data(value.utf8)))
    return sha256.map { String(format: "%02x", $0) }.joined()
  }
}
