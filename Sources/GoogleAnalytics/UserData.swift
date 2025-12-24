import Algorithms
import Crypto
import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public struct UserData: Encodable, Sendable {
  /// Hashed and encoded email address of the user. Normalized as such:
  /// - lowercase
  /// - remove periods before @ for gmail.com/googlemail.com addresses
  /// - remove all spaces
  /// - hash using SHA256 algorithm
  /// - encode with hex string format.
  public var emailAddress: [String]

  /// Hashed and encoded phone number of the user. Normalized as such:
  /// - remove all non digit characters
  /// - add + prefix
  /// - hash using SHA256 algorithm
  /// - encode with hex string format.
  public var phoneNumbers: [String]

  /// Identifies a user based on physical location.
  public var address: [Address]

  private enum CodingKeys: String, CodingKey {
    case emailAddress = "sha256_email_address"
    case phoneNumbers = "sha256_phone_number"
    case address
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    let emailAddress = self.emailAddress.map {
      let value = $0.split(whereSeparator: \.isWhitespace).joined().lowercased()
      return Data(SHA256.hash(data: Data(value.utf8))).map { String(format: "%02x", $0) }.joined()
    }
    try container.encode(emailAddress, forKey: .emailAddress)

    let phoneNumbers = self.phoneNumbers.map {
      let value = "+\($0.trimming(while: \.isWhitespace))"
      return Data(SHA256.hash(data: Data(value.utf8))).map { String(format: "%02x", $0) }.joined()
    }
    try container.encode(phoneNumbers, forKey: .phoneNumbers)
    try container.encode(self.address, forKey: .address)
  }

  func hashEncode(_ value: String) -> String {
    var value = value.trimming(while: \.isWhitespace).lowercased()
    value = "+\(value)"
    let sha256 = Data(SHA256.hash(data: Data(value.utf8)))
    return sha256.map { String(format: "%02x", $0) }.joined()
  }
}
