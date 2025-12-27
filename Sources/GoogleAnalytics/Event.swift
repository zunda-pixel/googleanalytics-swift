import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public struct Event: Encodable {
  public var name: String
  public var timestamp: Date?
  public var parameters: any Encodable

  private enum CodingKeys: String, CodingKey {
    case name
    case timestamp = "timestamp_micros"
    case parameters = "params"
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.name, forKey: .name)
    try container.encodeIfPresent(
      timestamp.map { UInt($0.timeIntervalSince1970 * 1_000_000) },
      forKey: .timestamp
    )
    try container.encode(self.parameters, forKey: .parameters)
  }
}
