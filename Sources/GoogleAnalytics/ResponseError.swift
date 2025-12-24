import Foundation
import HTTPTypes
import MemberwiseInit

@MemberwiseInit(.public)
public struct ResponseError: Error {
  public var data: Data
  public var response: HTTPResponse
}
