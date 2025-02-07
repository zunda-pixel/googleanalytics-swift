public struct Event<Parameters: Encodable>: Encodable {
  public var name: String
  public var parameters: Parameters
  
  public init(name: String, parameters: Parameters) {
    self.name = name
    self.parameters = parameters
  }
  
  private enum CodingKeys: String, CodingKey {
    case name
    case parameters = "params"
  }
}
