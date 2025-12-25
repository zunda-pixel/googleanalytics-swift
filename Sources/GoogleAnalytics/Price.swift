import Currency
import MemberwiseInit

@MemberwiseInit(.public)
public struct Price: Sendable {
  public var currency: Currency
  public var value: Double
}
