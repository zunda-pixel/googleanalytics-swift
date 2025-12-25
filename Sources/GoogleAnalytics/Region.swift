// https://github.com/frederik-jacques/countrykit/blob/2d61cc9137bca33b8942bb58ab96edd52ad94b60/Sources/CountryKit/Models/Region.swift#L33

import Foundation

public enum Region: Int, CustomStringConvertible, Identifiable, Encodable, Sendable {
  case northernAfrica = 15
  case subsaharanAfrica = 202

  case northAmerica = 3
  case latinAmericaAndCaribbean = 419

  case easternAsia = 30
  case southernAsia = 34
  case southEasternAsia = 35
  case centralAsia = 143
  case westernAsia = 145

  case southernEurope = 39
  case easternEurope = 151
  case northernEurope = 154
  case westernEurope = 155

  case australiaAndNewZealand = 53
  case melanesia = 54
  case microneasia = 57
  case polynesia = 61

  /// M-49 code for the region
  /// More info: https://en.wikipedia.org/wiki/UN_M49
  var code: Int { rawValue }

  public var id: Int { rawValue }

  public var description: String {
    return switch self {
    case .northernAfrica: "North Africa"
    case .subsaharanAfrica: "Sub-Saharan Africa"
    case .northAmerica: "North America"
    case .latinAmericaAndCaribbean: "Latin America & the Caribbean"
    case .easternAsia: "East Asia"
    case .southernAsia: "South Asia"
    case .southEasternAsia: "South East Asia"
    case .centralAsia: "Central Asia"
    case .westernAsia: "Western Asia"
    case .southernEurope: "Southern Europe"
    case .easternEurope: "Eastern Europe"
    case .northernEurope: "Northern Europe"
    case .westernEurope: "Western Europe"
    case .australiaAndNewZealand: "Australia & New Zealand"
    case .melanesia: "Melanesia"
    case .microneasia: "Micronesia"
    case .polynesia: "Polynesia"
    }
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue.formatted(.number.zeroPadded(width: 3)))
  }
}
