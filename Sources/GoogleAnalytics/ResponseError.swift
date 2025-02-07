import Foundation
import HTTPTypes

public struct ResponseError: Error {
  var data: Data
  var response: HTTPResponse
}
