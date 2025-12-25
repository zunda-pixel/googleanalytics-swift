import Algorithms
import Crypto
import Foundation
import ISO_3166
import MemberwiseInit

@MemberwiseInit(.public)
public struct UserLocation: Encodable, Sendable {
  public var city: String?
  public var regionID: ISO_3166.Alpha3?
  public var countryID: ISO_3166.Alpha2?
  public var subcontinentID: Region?
  public var continentID: Region?

  private enum CodingKeys: String, CodingKey {
    case city
    case regionID = "region_id"
    case countryID = "country_id"
    case subcontinentID = "subcontinent_id"
    case continentID = "continent_id"
  }
}
