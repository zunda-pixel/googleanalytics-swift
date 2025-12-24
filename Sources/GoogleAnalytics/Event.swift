import MemberwiseInit

@MemberwiseInit(.public)
public struct Event<Parameters: Encodable>: Encodable {
  public var name: String
  public var parameters: Parameters

  private enum CodingKeys: String, CodingKey {
    case name
    case parameters = "params"
  }
}
